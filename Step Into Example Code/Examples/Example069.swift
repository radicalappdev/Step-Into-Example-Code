//  Step Into Vision - Example Code
//
//  Title: Example069
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/15/25.

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct Example069: View {
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

    private func createPlaneEntity(for anchor: PlaneAnchor, color: Color) -> Entity {
        let entity = Entity()
        entity.name = "Plane \(anchor.id)"
        entity.setTransformMatrix(anchor.originFromAnchorTransform, relativeTo: nil)



        var material = PhysicallyBasedMaterial()
        material.baseColor.tint = UIColor(color)

        if let meshResource = createMeshResource(anchor: anchor) {
            entity.components.set(ModelComponent(mesh: meshResource, materials: [material]))
        }

        return entity
    }
}

#Preview {
    Example069()
}

