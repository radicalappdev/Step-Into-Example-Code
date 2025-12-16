//  Step Into Vision - Example Code
//
//  Title: Example136
//
//  Subtitle: RealityKit Basics: 3D Text
//
//  Description:
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/16/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example136: View {
    var body: some View {
        RealityView { content in
            
            let entity = makeTextEntity(title: "visionOS")
            content.add(entity)
            
        }
        .realityViewLayoutBehavior(.centered)
    }
    
    let mat1 = SimpleMaterial(color: .stepBackgroundPrimary, roughness: 0.2, isMetallic: false)
    let mat2 = SimpleMaterial(color: .stepGreen, roughness: 0.2, isMetallic: false)
    let mat3 = SimpleMaterial(color: .black, roughness: 0.2, isMetallic: false)

    private func makeTextEntity(title: String) -> ModelEntity {
        
        var textString = AttributedString(title)
        textString.font = .system(size: 8.0, weight: .medium, design: .rounded)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        textString.mergeAttributes(AttributeContainer([.paragraphStyle: paragraphStyle]))
        
        var textOptions = MeshResource.GenerateTextOptions()
        textOptions.containerFrame = CGRect(x: 0, y: 0, width: 100, height: 50)

        var extrusionOptions = MeshResource.ShapeExtrusionOptions()
        extrusionOptions.extrusionMethod = .linear(depth: 2)
        extrusionOptions.materialAssignment = .init(front: 0, back: 0, extrusion: 1, frontChamfer: 2, backChamfer: 2)
        extrusionOptions.chamferRadius = 0.1
        
        let textMesh = try! MeshResource(extruding: textString,
                                         textOptions: textOptions,
                                         extrusionOptions: extrusionOptions)
        
        return ModelEntity(mesh: textMesh, materials: [mat1, mat2, mat3])
    }
}

#Preview {
    Example136()
}
