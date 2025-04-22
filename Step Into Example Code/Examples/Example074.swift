//  Step Into Vision - Example Code
//
//  Title: Example074
//
//  Subtitle: ARKit PlaneDetectionProvider: adding an entity to an anchor
//
//  Description: Placing virtual content on a plane anchor.
//
//  Type: Space
//
//  Created by Joseph Simpson on 4/20/25.

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct Example074: View {

    @State var session = ARKitSession()
    @State var planeAnchorsSimple: [UUID: Entity] = [:]
    @State var frameEntity = Entity()

    var body: some View {
        RealityView { content in

            // Load the asset that we'll use to render the portal
            guard let scene = try? await Entity(named: "PortalFrame", in: realityKitContentBundle) else { return }
            content.add(scene)

            // Loadd the scene that will serve as the content for the portal
            guard let portalContent = try? await Entity(named: "PortalFrameContent", in: realityKitContentBundle) else { return }
            portalContent.components.set(WorldComponent())
            scene.addChild(portalContent)

            // Save the frame so we can access it from the tap gesture
            guard let frame = scene.findEntity(named: "picture_frame_02") else { return }
            frameEntity = frame
            frameEntity.isEnabled = false

            // Set up the portal
            guard let portalEntity = scene.findEntity(named: "portal_entity") else { return }
            portalEntity.components[ModelComponent.self]?.materials[0] = PortalMaterial()
            portalEntity.components.set(PortalComponent(target: portalContent))

        } update: { content in

            for (_, entity) in planeAnchorsSimple {
                if !content.entities.contains(entity) {
                    content.add(entity)
                }
            }

        }
        .gesture(TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                // Place the frame on on the tapped plane
                frameEntity.transform = value.entity.transform
                frameEntity.isEnabled = true
            })
        .task {
            try! await setupAndRunPlaneDetection()
        }
    }

    func setupAndRunPlaneDetection() async throws {
        let planeData = PlaneDetectionProvider(alignments: [.vertical])
        if PlaneDetectionProvider.isSupported {
            do {
                try await session.run([planeData])
                for await update in planeData.anchorUpdates {
                    switch update.event {
                    case .added, .updated:
                        let anchor = update.anchor
                        // Only add walls for this demo
                        if(anchor.classification == .wall) {
                            let planeEntitySimple = createSimplePlaneEntity(for: anchor)
                            planeAnchorsSimple[anchor.id] = planeEntitySimple
                        }
                    case .removed:
                        let anchor = update.anchor
                        planeAnchorsSimple.removeValue(forKey: anchor.id)
                    }
                }
            } catch {
                print("ARKit session error \(error)")
            }
        }
    }

    func createSimplePlaneEntity(for anchor: PlaneAnchor) -> Entity {
        let extent = anchor.geometry.extent
        let mesh = MeshResource.generatePlane(width: extent.width, height: extent.height)
        let material = OcclusionMaterial()

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.transform = Transform(matrix: matrix_multiply(anchor.originFromAnchorTransform, extent.anchorFromExtentTransform))

        entity.generateCollisionShapes(recursive: true, static: true)
        entity.components.set(InputTargetComponent())

        return entity
    }
}

#Preview {
    Example074()
}
