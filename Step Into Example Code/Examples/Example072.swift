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
    @State private var planeAnchorsSimple: [UUID: Entity] = [:]


    var body: some View {
        RealityView { content in

        } update: { content in
            for (_, entity) in planeAnchors {
                if !content.entities.contains(entity) {
                    content.add(entity)
                }
            }
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

                        let planeEntity = createPlaneEntity(for: anchor)
                        planeAnchors[anchor.id] = planeEntity
                        let planeEntitySimple = createSimplePlaneEntity(for: anchor)
                        planeAnchorsSimple[anchor.id] = planeEntitySimple

                    case .removed:
                        let anchor = update.anchor
                        planeAnchors.removeValue(forKey: anchor.id)
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
        var material = PhysicallyBasedMaterial()
        material.baseColor.tint = UIColor(.stepBackgroundSecondary)
        material.blending =
            .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: 0.5))

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.generateCollisionShapes(recursive: false)
        entity.transform = Transform(matrix: matrix_multiply(anchor.originFromAnchorTransform, extent.anchorFromExtentTransform))

        // Just a hack to prevent z fighting with the other planes
        if(anchor.alignment == .vertical) {
            entity.position.z -= 0.05
        } else if(anchor.alignment == .horizontal) {
            entity.position.y -= 0.05
        }


        return entity
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

            print("vertices \(vertices)")
            print("was converted to \(vertexArray)")

            // Convert faces to UInt32
            let faces = anchor.geometry.meshFaces
            var faceArray: [UInt32] = []
            let totalFaces = faces.count * faces.primitive.indexCount
            for i in 0..<totalFaces {
                let face = faces.buffer.contents().advanced(by: i * MemoryLayout<Int32>.size).assumingMemoryBound(to: Int32.self).pointee
                faceArray.append(UInt32(face))
            }
            part.triangleIndices = MeshBuffer(faceArray)

            print("faces \(faces)")
            print("was converted to \(faceArray)")

            contents.models = [MeshResource.Model(id: "model", parts: [part])]
            meshResource = try MeshResource.generate(from: contents)
            return meshResource
        } catch {
            print("Failed to create a mesh resource for a plane anchor: \(error).")
        }
        return nil
    }

    private func createPlaneEntity(for anchor: PlaneAnchor) -> Entity {
        let entity = Entity()
        entity.name = "Plane \(anchor.id)"
        entity.setTransformMatrix(anchor.originFromAnchorTransform, relativeTo: nil)

        var material = PhysicallyBasedMaterial()
        material.baseColor.tint = UIColor(.stepRed)

        if let meshResource = createMeshResource(anchor: anchor) {
            entity.components.set(ModelComponent(mesh: meshResource, materials: [material]))
        }

        return entity
    }
}

#Preview {
    Example072()
}
