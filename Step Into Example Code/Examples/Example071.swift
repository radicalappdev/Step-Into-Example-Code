//  Step Into Vision - Example Code
//
//  Title: Example071
//
//  Subtitle:
//
//  Description: We can filter anchors based on classification or alignment values.
//
//  Type: Space
//
//  Created by Joseph Simpson on 4/17/25.

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct Example071: View {
    @State var session = ARKitSession()
    @State private var planeAnchors: [UUID: Entity] = [:]

    /// Debug value: use classification colors when false, alignment colors when true
    private var useAlighmentColors: Bool = false

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

                        let planeEntity = createPlaneEntity(for: anchor)
                        planeAnchors[anchor.id] = planeEntity
                    case .removed:
                        let anchor = update.anchor
                        if let entity = planeAnchors[anchor.id] {
                            entity.removeFromParent()
                            planeAnchors.removeValue(forKey: anchor.id)
                        }
                    }
                }
            } catch {
                print("ARKit session error \(error)")
            }
        }
    }

    private func createPlaneEntity(for anchor: PlaneAnchor) -> Entity {
        let entity = Entity()
        entity.name = "Plane \(anchor.id)"
        entity.setTransformMatrix(anchor.originFromAnchorTransform, relativeTo: nil)

        var material = PhysicallyBasedMaterial()
        // Use eithr the classification or alignment colors
        material.baseColor.tint = useAlighmentColors ? colorForPlaneAlignment(anchor.alignment) : colorForPlaneClassification(anchor.classification)

        if let meshResource = createMeshResource(anchor: anchor) {
            entity.components.set(ModelComponent(mesh: meshResource, materials: [material]))
        }

        return entity
    }

    // Helper functions to determine color from classification or alignment
    private func colorForPlaneClassification(_ classification: PlaneAnchor.Classification?) -> UIColor {
        guard let classification else {
            return .white
        }

        // Current cases: https://developer.apple.com/documentation/arkit/planeanchor/classification-swift.enum
        // We only care about wall, ceiling, and floor today
        switch classification {
        case .wall:
            return .systemRed
        case .ceiling:
            return .systemBlue
        case .floor:
            return .systemGreen
        default:
            return .white
        }
    }

    private func colorForPlaneAlignment(_ alignment: PlaneAnchor.Alignment?) -> UIColor {
        guard let alignment else {
            return .white
        }

        // Only three cases as of visionOS 2.4
        switch alignment {
        case .horizontal:
            return .systemOrange
        case .vertical:
            return .systemPurple
        case .slanted:
            return .systemCyan
        default:
            return .white
        }
    }


    private func createMeshResource(anchor: PlaneAnchor) -> MeshResource? {
        // Generate a mesh for the plane (for occlusion).
        var meshResource: MeshResource? = nil
        do {
            var contents = MeshResource.Contents()
            contents.instances = [MeshResource.Instance(id: "main", model: "model")]
            var part = MeshResource.Part(id: "part", materialIndex: 0)

            // Convert vertices to SIMD3<Float>
            let vertices = anchor.geometry.meshVertices
            var vertexArray: [SIMD3<Float>] = []
            for i in 0..<vertices.count {
                let vertex = vertices.buffer.contents().advanced(by: vertices.offset + vertices.stride * i).assumingMemoryBound(to: (Float, Float, Float).self).pointee
                vertexArray.append(SIMD3<Float>(vertex.0, vertex.1, vertex.2))
            }
            part.positions = MeshBuffers.Positions(vertexArray)

            // Convert faces to UInt32
            let faces = anchor.geometry.meshFaces
            var faceArray: [UInt32] = []
            let totalFaces = faces.count * faces.primitive.indexCount
            for i in 0..<totalFaces {
                let face = faces.buffer.contents().advanced(by: i * MemoryLayout<Int32>.size).assumingMemoryBound(to: Int32.self).pointee
                faceArray.append(UInt32(face))
            }
            part.triangleIndices = MeshBuffer(faceArray)

            contents.models = [MeshResource.Model(id: "model", parts: [part])]
            meshResource = try MeshResource.generate(from: contents)
            return meshResource
        } catch {
            print("Failed to create a mesh resource for a plane anchor: \(error).")
        }
        return nil
    }

}

#Preview {
    Example071()
}
