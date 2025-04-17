//  Step Into Vision - Example Code
//
//  Title: Example071
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/17/25.

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct Example071: View {
    @State var session = ARKitSession()
    @State private var planeAnchors: [UUID: Entity] = [:]

    @State var subject : ModelEntity = {
        let subject = ModelEntity(
            mesh: .generateSphere(radius: 0.1),
            materials: [SimpleMaterial(color: .stepRed, isMetallic: false)])
        subject.setPosition([1, 1, -1], relativeTo: nil)

        let collision = CollisionComponent(shapes: [.generateSphere(radius: 0.1)])

        var physics = PhysicsBodyComponent(
            shapes: [.generateSphere(radius: 0.1)],
            mass: 1.0,
            material: .generate(friction: 0, restitution: 1),
            mode: .dynamic
        )
        physics.isAffectedByGravity = false

        let input = InputTargetComponent()
        subject.components.set([collision, physics, input])

        return subject
    }()

    var body: some View {
        RealityView { content in
            content.add(subject)
        } update: { content in
            for (_, entity) in planeAnchors {
                if !content.entities.contains(entity) {
                    content.add(entity)
                }
            }
        }
        .gesture(TapGesture()
            .targetedToEntity(subject)
            .onEnded { value in
                // Add some force when we tap the subject
                let force = SIMD3<Float>(
                    x: Float.random(in: -1...1),
                    y: Float.random(in: -1...1),
                    z: Float.random(in: -1...1)
                )
                var motion = PhysicsMotionComponent()
                motion.linearVelocity = force * 3
                value.entity.components.set(motion)
            })
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


    private func colorForPlaneClassification(_ classification: PlaneAnchor.Classification?) -> UIColor {
        guard let classification else {
            return .white
        }
        
        switch classification {
        case .wall:
            return .systemRed
        case .ceiling:
            return .white
        case .floor:
            return .systemGreen
        default:
            return .white
        }
    }

    private func createPlaneEntity(for anchor: PlaneAnchor) -> Entity {
        let entity = Entity()
        entity.name = "Plane \(anchor.id)"
        entity.setTransformMatrix(anchor.originFromAnchorTransform, relativeTo: nil)

        var material = PhysicallyBasedMaterial()
        material.baseColor.tint = colorForPlaneClassification(anchor.classification)

        if let meshResource = createMeshResource(anchor: anchor) {
            entity.components.set(ModelComponent(mesh: meshResource, materials: [material]))
        }

        Task {
            let shape = await self.createCollisionShape(anchor: anchor)
            if let shape = shape {
                let collision = CollisionComponent(shapes: [shape], mode: .default)
                entity.components.set(collision)

                let physicsMaterial = PhysicsMaterialResource.generate(friction: 0, restitution: 0.8)
                let physics = PhysicsBodyComponent(shapes: [shape], mass: 0.0, material: physicsMaterial, mode: .static)
                entity.components.set(physics)
            }
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

    private func createCollisionShape(anchor: PlaneAnchor) async -> ShapeResource? {
        // Generate a collision shape for the plane
        var shape: ShapeResource? = nil
        do {
            // Convert vertices to SIMD3<Float>
            let vertices = anchor.geometry.meshVertices
            var vertexArray: [SIMD3<Float>] = []
            for i in 0..<vertices.count {
                let vertex = vertices.buffer.contents().advanced(by: vertices.offset + vertices.stride * i).assumingMemoryBound(to: (Float, Float, Float).self).pointee
                vertexArray.append(SIMD3<Float>(vertex.0, vertex.1, vertex.2))
            }

            // Convert faces to UInt16
            let faces = anchor.geometry.meshFaces
            var faceArray: [UInt16] = []
            let totalFaces = faces.count * faces.primitive.indexCount
            for i in 0..<totalFaces {
                let face = faces.buffer.contents().advanced(by: i * MemoryLayout<Int32>.size).assumingMemoryBound(to: Int32.self).pointee
                faceArray.append(UInt16(face))
            }

            shape = try await ShapeResource.generateStaticMesh(positions: vertexArray, faceIndices: faceArray)
            return shape
        } catch {
            print("Failed to create a shape for collision \(error).")
        }
        return nil
    }
}

#Preview {
    Example071()
}
