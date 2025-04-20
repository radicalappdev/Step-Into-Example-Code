//  Step Into Vision - Example Code
//
//  Title: Example075
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/20/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example075: View {

    @State var sphereEntity = Entity()
    @State var boxEntity = Entity()

    @State var color: Color = .red
    @State var opacity: Float = 1.0

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "MaterialEdit", in: realityKitContentBundle) else { return }
            content.add(scene)

            guard let sphere = scene.findEntity(named: "Sphere") else { return }
            guard let box = scene.findEntity(named: "Box") else { return }
            sphereEntity = sphere
            boxEntity = box

        } update: { content in
            let uiColor = UIColor(color) // color picker uses Color, but these materials want UIColor...
            let opacityChange = opacity

            // Edit the color for a PhysicallyBasedMaterial
            if var pbrMaterial = sphereEntity.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial {
                pbrMaterial.baseColor.tint = uiColor
                pbrMaterial.blending =
                    .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: opacityChange))
                sphereEntity.components[ModelComponent.self]?.materials[0] = pbrMaterial
            }

            // Edit the color for a ShaderGraphMaterial
            if var shaderMaterial = boxEntity.components[ModelComponent.self]?.materials.first as? ShaderGraphMaterial {
                do {
                    try shaderMaterial.setParameter(name: "Basecolor_Tint", value: MaterialParameters.Value.color(uiColor))
                    try shaderMaterial.setParameter(name: "Opacity", value: MaterialParameters.Value.float(opacityChange))
                    boxEntity.components[ModelComponent.self]?.materials[0] = shaderMaterial
                } catch {
                    print("could not set parameter")
                }

            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    ColorPicker("Color", selection: $color)
                    Divider()
                        .padding(.horizontal, 12)
                    Slider(value: $opacity, in: 0...1)

                }
            })
        }
    }
}




#Preview {
    Example075()
}
