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

            let entity = makeTextEntity(titleA: "Step Into", titleB: "Vision")
            content.add(entity)

        }
        .realityViewLayoutBehavior(.centered)
    }

    @MainActor private let faceMaterial: PhysicallyBasedMaterial = {
        var faceMaterial = PhysicallyBasedMaterial()
        faceMaterial.metallic = .init(floatLiteral: 1)
        faceMaterial.roughness = .init(floatLiteral: 0.85)
        faceMaterial.baseColor = .init(tint: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        return faceMaterial
    }()

    @MainActor private let borderMaterial: PhysicallyBasedMaterial = {
        var borderMaterial = PhysicallyBasedMaterial()
        borderMaterial.metallic = .init(floatLiteral: 0.15)
        borderMaterial.roughness = .init(floatLiteral: 0.85)
        borderMaterial.baseColor = .init(tint: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        return borderMaterial
    }()

    private func makeTextEntity(titleA: String, titleB: String) -> ModelEntity {

        var textString = AttributedString(titleA)
        textString.font = .monospacedSystemFont(ofSize: 8.0, weight: .light)

        let attributes = AttributeContainer([.font: Font.system(size: 8.0, weight: .heavy)])
        textString.append(AttributedString("\(titleB)", attributes: attributes))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        textString.mergeAttributes(AttributeContainer([.paragraphStyle: paragraphStyle]))

        var textOptions = MeshResource.GenerateTextOptions()
        textOptions.containerFrame = CGRect(x: 0, y: 0, width: 80, height: 50)

        var extrusionOptions = MeshResource.ShapeExtrusionOptions()
        extrusionOptions.extrusionMethod = .linear(depth: 1)
        extrusionOptions.materialAssignment = .init(front: 0, back: 0, extrusion: 1, frontChamfer: 1, backChamfer: 1)
        extrusionOptions.chamferRadius = 0.1

        let textMesh = try! MeshResource(extruding: textString,
                                         textOptions: textOptions,
                                         extrusionOptions: extrusionOptions)

        return ModelEntity(mesh: textMesh, materials: [faceMaterial, borderMaterial])
    }
}

#Preview {
    Example136()
}
