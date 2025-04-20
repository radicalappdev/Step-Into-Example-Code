//  Step Into Vision - Example Code
//
//  Title: Example075
//
//  Subtitle: RealityKit Basics: Modify Material Values
//
//  Description: Changing material values is similar to changing component values, but with a few considerations.
//
//  Type: Window
//
//  Created by Joseph Simpson on 4/20/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example075: View {

    @State var color: Color = .stepBackgroundSecondary
    @State var opacity: Float = 1.0

    @State var sphereEntity = Entity()
    @State var boxEntity = Entity()

    var body: some View {
        HStack(alignment: .center) {
            Form {
                ColorPicker("Color", selection: $color)

                HStack {
                    Text("Opacity")
                        .frame(width: 100, alignment: .leading)
                    Slider(value: $opacity, in: 0...1)
                }
                .padding(.vertical, 4)

            }
            .padding()
            .frame(width: 400)
            RealityView { content in

                guard let scene = try? await Entity(named: "MaterialEdit", in: realityKitContentBundle) else { return }
                content.add(scene)
                scene.scale = [0.3, 0.3, 0.3]
                scene.position = [0, 0, -0.1]

                // Get the entities we want to modify and save them in state
                guard let sphere = scene.findEntity(named: "Sphere") else { return }
                guard let box = scene.findEntity(named: "Box") else { return }
                sphereEntity = sphere
                boxEntity = box

            } update: { content in
                // Editing either of these values will trigger the update closure
                let colorChange = UIColor(color) // color picker uses Color, but these materials want UIColor...
                let opacityChange = opacity

                // Edit the color for a PhysicallyBasedMaterial
                if var pbrMaterial = sphereEntity.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial {
                    pbrMaterial.baseColor.tint = colorChange
                    pbrMaterial.blending =
                        .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: opacityChange))
                    sphereEntity.components[ModelComponent.self]?.materials[0] = pbrMaterial
                }

                // Edit the color for a ShaderGraphMaterial
                if var shaderMaterial = boxEntity.components[ModelComponent.self]?.materials.first as? ShaderGraphMaterial {
                    do {
                        try shaderMaterial.setParameter(name: "Basecolor_Tint", value: MaterialParameters.Value.color(colorChange))
                        try shaderMaterial.setParameter(name: "Opacity", value: MaterialParameters.Value.float(opacityChange))
                        boxEntity.components[ModelComponent.self]?.materials[0] = shaderMaterial
                    } catch {
                        print("could not set parameter")
                    }

                }
            }
        }

    }
}




#Preview {
    Example075()
}


