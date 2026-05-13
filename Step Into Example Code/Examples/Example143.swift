//  Step Into Vision - Example Code
//
//  Title: Example143
//
//  Subtitle: RealityKit Basics: MeshDescriptor
//
//  Description: We can use MeshDescriptor to build shapes and render them with MeshResource.
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 5/13/26.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example143: View {
    var body: some View {
        RealityView { content in

            // We generate a mesh resource using our helper function
            let mesh = try! MeshResource.generate(from: [Self.tetrahedronDescriptor])

            // Create some materials
            let materials = [
                SimpleMaterial(color: .green, roughness: 0.2, isMetallic: false),
                SimpleMaterial(color: .yellow, roughness: 0.2, isMetallic: false),
                SimpleMaterial(color: .orange, roughness: 0.2, isMetallic: false),
                SimpleMaterial(color: .blue, roughness: 0.2, isMetallic: false)
            ]

            // Create our entity and add it to the scene
            let entity = ModelEntity(mesh: mesh, materials: materials)
            spinSubject(entity: entity)
            content.add(entity)

        }
        .realityViewLayoutBehavior(.fixedSize)
    }

    private static var tetrahedronDescriptor: MeshDescriptor {
        // Set the length for each side of the shape
        let sideLength: Float = 0.5
        let coordinate = sideLength / (2 * sqrt(2))

        // A tetrahedron has four vertices. This arrangement keeps the shape centered
        let topFrontRight = SIMD3<Float>(coordinate, coordinate, coordinate)
        let bottomBackRight = SIMD3<Float>(coordinate, -coordinate, -coordinate)
        let topBackLeft = SIMD3<Float>(-coordinate, coordinate, -coordinate)
        let bottomFrontLeft = SIMD3<Float>(-coordinate, -coordinate, coordinate)

        // MeshDescriptor uses one positions buffer for the mesh's vertex data.
        // Here, each face gets its own copy of the vertices.
        let positions: [SIMD3<Float>] = [
            topFrontRight, bottomBackRight, topBackLeft,
            topFrontRight, bottomFrontLeft, bottomBackRight,
            topFrontRight, topBackLeft, bottomFrontLeft,
            bottomBackRight, bottomFrontLeft, topBackLeft
        ]

        // Create the MeshDescriptor and set the positions data
        var descriptor = MeshDescriptor(name: "Tetrahedron")
        descriptor.positions = MeshBuffers.Positions(positions)

        // The triangle list reads positions in groups of three
        // Each group below is one face of the shape
        descriptor.primitives = .triangles([
            0, 1, 2,
            3, 4, 5,
            6, 7, 8,
            9, 10, 11
        ])

        // Bonus: we'll map a different material to each face
        descriptor.materials = .perFace([0, 1, 2, 3])

        return descriptor
    }

    // Spin the entity so we can see all faces from within the simulator
    private func spinSubject(entity: Entity) {
        Task {
            let action = SpinAction(revolutions: 1.2,
                                    localAxis: [0.2, 1, 0],
                                    timingFunction: .easeInOut,
                                    isAdditive: false)
            let animation = try AnimationResource.makeActionAnimation(for: action,
                                                                      duration: 5,
                                                                      bindTarget: .transform
                                                                      ,repeatMode: .autoReverse)
            entity.playAnimation(animation)
        }
    }
}

#Preview {
    Example143()
}
