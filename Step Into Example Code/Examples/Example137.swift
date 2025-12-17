//  Step Into Vision - Example Code
//
//  Title: Example137
//
//  Subtitle: RealityKit Basics: Extruding Meshes
//
//  Description: We use data from a Swift Path to extrude a 3D Shape.
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example137: View {
    var body: some View {
        RealityView { content in

            let subject = await makeExtrudedEntity(title: "Subject", path: simplePath())
            spinSubject(entity: subject)
            content.add(subject)

        }
        .realityViewLayoutBehavior(.centered)
    }

    func makeExtrudedEntity(title: String, path: Path) async -> ModelEntity {

        // Create some materials for our shape
        let mat1 = SimpleMaterial(color: .stepGreen, roughness: 0.2, isMetallic: false)
        let mat2 = SimpleMaterial(color: .stepRed, roughness: 0.2, isMetallic: false)
        let mat3 = SimpleMaterial(color: .stepBlue, roughness: 0.2, isMetallic: false)
        let mat4 = SimpleMaterial(color: .stepBackgroundPrimary, roughness: 0.2, isMetallic: false)

        // Set up our extrusion options. Here we'll set a depth and chamfer. We can also assign material indexes to each face.
        var extrusionOptions = MeshResource.ShapeExtrusionOptions()
        extrusionOptions.extrusionMethod = .linear(depth: 0.05) // in meters
        extrusionOptions.chamferRadius = 0.01
        extrusionOptions.materialAssignment = .init(front: 0, back: 1, extrusion: 2, frontChamfer: 3, backChamfer: 3)

        // Create a Mesh Resource using the provided path and the extrusion options
        let mesh = try! await MeshResource(extruding: path, extrusionOptions: extrusionOptions)

        // Create an entity with the Mesh Resource and an array of materials
        return ModelEntity(mesh: mesh, materials: [mat1, mat2, mat3, mat4])

    }

    // Just a helper function to create a Path
    func simplePath() -> Path {
        let points = 5
        let outerRadius: CGFloat = 0.12
        let innerRadius: CGFloat = 0.05
        let center = CGPoint(x: 0, y: 0)

        var path = Path()
        let angleStep = .pi * 2 / CGFloat(points * 2)

        for i in 0..<(points * 2) {
            let radius = (i % 2 == 0) ? outerRadius : innerRadius
            let angle = CGFloat(i) * angleStep - .pi / 2
            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()
        return path
    }

    // A helper function to spin the subject to showcase the extrusion
    func spinSubject(entity: Entity) {
        Task {
            let action = SpinAction(revolutions: 1,
                                    localAxis: [-0.25, 1, 0.25],
                                    timingFunction: .easeInOut,
                                    isAdditive: false)
            let animation = try AnimationResource.makeActionAnimation(for: action,
                                                                      duration: 3,
                                                                      bindTarget: .transform
                                                                      ,repeatMode: .autoReverse)
            entity.playAnimation(animation)
        }
    }
}

#Preview {
    Example137()
}
