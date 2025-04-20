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

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "MaterialEdit", in: realityKitContentBundle) else { return }
            content.add(scene)

            guard let sphere = scene.findEntity(named: "Sphere") else { return }
            guard let box = scene.findEntity(named: "Box") else { return }
            sphereEntity = sphere
            boxEntity = box

        }
        .onChange(of: color) { _, newValue in
            let uiColor = UIColor(newValue) // color picker uses Color, but these materials want UIColor...

            // Edit the color for a PhysicallyBasedMaterial
            if var pbrMaterial = sphereEntity.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial {
                pbrMaterial.baseColor.tint = uiColor
                sphereEntity.components[ModelComponent.self]?.materials[0] = pbrMaterial
            }

            // Edit the color for a ShaderGraphMaterial
            if var shaderMaterial = boxEntity.components[ModelComponent.self]?.materials.first as? ShaderGraphMaterial {
                do {
                    try shaderMaterial.setParameter(name: "Basecolor_Tint", value: MaterialParameters.Value.color(uiColor))
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

                }
            })
        }
    }
}




#Preview {
    Example075()
}
