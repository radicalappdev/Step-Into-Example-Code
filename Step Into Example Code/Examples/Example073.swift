//  Step Into Vision - Example Code
//
//  Title: Example073
//
//  Subtitle: ARKit PlaneDetectionProvider: occlusion material
//
//  Description: We can use Occlusion material to hide our planes while letting them participate in collisions and physics.
//
//  Type: Space
//
//  Created by Joseph Simpson on 4/19/25.

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct Example073: View {
    @State var session = ARKitSession()

    @State private var planeAnchorsSimple: [UUID: Entity] = [:]


    var body: some View {
        RealityView { content in

        } update: { content in

            for (_, entity) in planeAnchorsSimple {
                if !content.entities.contains(entity) {
                    content.add(entity)
                }
            }
        }
        .task {
            try! await setupAndRunPlaneDetection()
        }
    }

    func setupAndRunPlaneDetection() async throws {
        let planeData = PlaneDetectionProvider(alignments: [.horizontal, .vertical, ])
        if PlaneDetectionProvider.isSupported {
            do {
                try await session.run([planeData])
                for await update in planeData.anchorUpdates {
                    switch update.event {
                    case .added, .updated:
                        let anchor = update.anchor

                        let planeEntitySimple = createSimplePlaneEntity(for: anchor)
                        planeAnchorsSimple[anchor.id] = planeEntitySimple

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

    private func createSimplePlaneEntity(for anchor: PlaneAnchor) -> Entity {

        let extent = anchor.geometry.extent
        let mesh = MeshResource.generatePlane(width: extent.width, height: extent.height)
        let material = OcclusionMaterial()

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.generateCollisionShapes(recursive: true)
        entity.transform = Transform(matrix: matrix_multiply(anchor.originFromAnchorTransform, extent.anchorFromExtentTransform))



        return entity
    }
}

#Preview {
    Example073()
}
