//  Step Into Vision - Example Code
//
//  Title: Example136
//
//  Subtitle: RealityKit Basics: 3D Text
//
//  Description: We can generate 3D text from an attributed string and some configuration options.
//
//  Type: Volume
//
//  Featured: false
//
//  Created by Joseph Simpson on 12/16/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example136: View {
    var body: some View {
        RealityView { content in
            
            let entity = makeTextEntity(title: "visionOS")
            spinSubject(entity: entity)
            content.add(entity)
            
        }
        .realityViewLayoutBehavior(.centered)
    }

    func makeTextEntity(title: String) -> ModelEntity {

        let mat1 = SimpleMaterial(color: .stepBackgroundPrimary, roughness: 0.2, isMetallic: false)
        let mat2 = SimpleMaterial(color: .stepGreen, roughness: 0.2, isMetallic: false)
        let mat3 = SimpleMaterial(color: .black, roughness: 0.2, isMetallic: false)

        // Create an AttributedString, set the font, and merge any attributes
        var textString = AttributedString(title)
        textString.font = .systemFont(ofSize: 12.0)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        textString.mergeAttributes(AttributeContainer([.paragraphStyle: paragraphStyle]))

        // Generate some Text Options. We'll make a small rectangle
        var textOptions = MeshResource.GenerateTextOptions()
        textOptions.containerFrame = CGRect(x: -50, y: -25, width: 100, height: 50)

        // Set up our extrusion options. Here we'll set a depth and chamfer. We can also assign material indexes to each face.
        var extrusionOptions = MeshResource.ShapeExtrusionOptions()
        extrusionOptions.extrusionMethod = .linear(depth: 2)
        extrusionOptions.chamferRadius = 0.1
        // These are the indexes of the materals array that we'll bass to ModelEntity
        extrusionOptions.materialAssignment = .init(front: 0, back: 0, extrusion: 1, frontChamfer: 2, backChamfer: 2)

        // Bring it all together by creating a Mesh Resource with our string and options.
        let textMesh = try! MeshResource(extruding: textString,
                                         textOptions: textOptions,
                                         extrusionOptions: extrusionOptions)

        // Create an entity with the mesh resource and an array of materials
        return ModelEntity(mesh: textMesh, materials: [mat1, mat2, mat3])
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
    Example136()
}
