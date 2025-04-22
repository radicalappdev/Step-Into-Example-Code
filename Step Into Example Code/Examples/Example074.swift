//  Step Into Vision - Example Code
//
//  Title: Example074
//
//  Subtitle:
//
//  Description:
//
//  Type:
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
    @State var portal = Entity()

    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "PortalFrame", in: realityKitContentBundle) else { return }
            content.add(scene)

            guard let frame = scene.findEntity(named: "picture_frame_02") else { return }
            frameEntity = frame
            frameEntity.isEnabled = false
            scene.addChild(frameEntity)


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
