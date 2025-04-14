//  Step Into Vision - Example Code
//
//  Title: Example068
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/14/25.

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct Example068: View {
    @State var session = ARKitSession()
    @State private var planeAnchors: [UUID: Entity] = [:]

    var body: some View {
        RealityView { content in

        } update: { content in

            for (_, entity) in planeAnchors {
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
        let planeData = PlaneDetectionProvider(alignments: [.horizontal, .vertical])
        if PlaneDetectionProvider.isSupported {
            do {
                try await session.run([planeData])
                for await update in planeData.anchorUpdates {
                    switch update.event {
                    case .added, .updated:
                        let anchor = update.anchor
                        let planeEntity = createPlaneEntity(for: anchor)
                        planeAnchors[anchor.id] = planeEntity
                    case .removed:
                        let anchor = update.anchor
                        planeAnchors.removeValue(forKey: anchor.id)
                    }
                }
            } catch {
                print("ARKit session error \(error)")
            }
        }
    }
    
    private func createPlaneEntity(for anchor: PlaneAnchor) -> Entity {
        let mesh = MeshResource.generatePlane(
            width: anchor.geometry.extent.width,
            depth: anchor.geometry.extent.height
        )
        
        var material = PhysicallyBasedMaterial()
        material.baseColor.tint = .stepBackgroundSecondary

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.transform = Transform(matrix: anchor.originFromAnchorTransform)
        
        return entity
    }
}

#Preview {
    Example068()
}
