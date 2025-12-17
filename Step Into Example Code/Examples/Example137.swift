//  Step Into Vision - Example Code
//
//  Title: Example137
//
//  Subtitle: RealityKit Basics: Extruding Meshes
//
//  Description:
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

        let mat1 = SimpleMaterial(color: .stepGreen, roughness: 0.2, isMetallic: false)
        let mat2 = SimpleMaterial(color: .stepRed, roughness: 0.2, isMetallic: false)
        let mat3 = SimpleMaterial(color: .stepBlue, roughness: 0.2, isMetallic: false)
        let mat4 = SimpleMaterial(color: .stepBackgroundPrimary, roughness: 0.2, isMetallic: false)

        // Set up our extrusion options. Here we'll set a depth and chamfer. We can also assign material indexes to each face.
        var extrusionOptions = MeshResource.ShapeExtrusionOptions()
        extrusionOptions.extrusionMethod = .linear(depth: 0.05) // in meters
        extrusionOptions.chamferRadius = 0.01
        extrusionOptions.materialAssignment = .init(front: 0, back: 1, extrusion: 2, frontChamfer: 3, backChamfer: 3)

        
        let mesh = try! await MeshResource(extruding: path, extrusionOptions: extrusionOptions)

        let subject = ModelEntity(mesh: mesh, materials: [mat1, mat2, mat3, mat4])
        subject.name = "Subject"
        subject.orientation = .init(angle: .pi / 4, axis: [0, 1, 0])

        return subject

    }

    func simplePath() -> Path {
        let rect = CGRect(x: -0.1, y: -0.1, width: 0.2, height: 0.2)
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))

        return path
    }

    func spinSubject(entity: Entity) {
        Task {
            let action = SpinAction(revolutions: 0.5,
                                    localAxis: [0, 1, 0],
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
