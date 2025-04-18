//  Step Into Vision - Example Code
//
//  Title: Example072
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/18/25.

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct Example072: View {
    @State var session = ARKitSession()
    @State private var planeAnchors: [UUID: Entity] = [:]
    @State private var planeColors: [UUID: Color] = [:]

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
        let planeData = PlaneDetectionProvider(alignments: [.horizontal, .vertical, .slanted])
        if PlaneDetectionProvider.isSupported {
            do {
                try await session.run([planeData])
                for await update in planeData.anchorUpdates {
                    switch update.event {
                    case .added, .updated:
                        let anchor = update.anchor
                        if planeColors[anchor.id] == nil {
                            planeColors[anchor.id] = generatePastelColor()
                        }
                        let planeEntity = createPlaneEntity(for: anchor, color: planeColors[anchor.id]!)
                        planeAnchors[anchor.id] = planeEntity
                    case .removed:
                        let anchor = update.anchor
                        planeAnchors.removeValue(forKey: anchor.id)
                        planeColors.removeValue(forKey: anchor.id)
                    }
                }
            } catch {
                print("ARKit session error \(error)")
            }
        }
    }

    private func generatePastelColor() -> Color {
        let hue = Double.random(in: 0...1)
        let saturation = Double.random(in: 0.2...0.4)
        let brightness = Double.random(in: 0.8...1.0)
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }

    private func createPlaneEntity(for anchor: PlaneAnchor, color: Color) -> Entity {
        let mesh = MeshResource.generatePlane(
            width: anchor.geometry.extent.width,
            depth: anchor.geometry.extent.height
        )

        var material = PhysicallyBasedMaterial()
        material.baseColor.tint = UIColor(color)

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.transform = Transform(matrix: anchor.originFromAnchorTransform)

        return entity
    }
}

#Preview {
    Example072()
}
