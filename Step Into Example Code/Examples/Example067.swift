//  Step Into Vision - Example Code
//
//  Title: Example067
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/10/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example067: View {

    @State var subjectEntity = Entity()

    var body: some View {
        RealityView { content in


            var material = PhysicallyBasedMaterial()
            material.baseColor.tint = .stepRed
            material.roughness = 0.5
            material.metallic = 0.0

            let shape = MeshResource.generateSphere(radius: 0.2)

            let model = ModelComponent(mesh: shape, materials: [material])

            subjectEntity.components.set(model)
            subjectEntity.name = "Subject"
            content.add(subjectEntity)

        } update: { content in

        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    ColorButton(color: .stepRed, subjectEntity: $subjectEntity)
                    ColorButton(color: .stepGreen, subjectEntity: $subjectEntity)
                    ColorButton(color: .stepBlue, subjectEntity: $subjectEntity)

                }
            })
        }
    }
}

fileprivate struct ColorButton: View {

    @State var color: Color
    @Binding var subjectEntity: Entity

    var body: some View {
        Button(action: {
            if var material = subjectEntity.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial {
                material.baseColor.tint = UIColor(color)
                subjectEntity.components[ModelComponent.self]?.materials[0] = material
            }

        }, label: {
            color
                .frame(width: 44, height: 44)
                .clipShape(.circle)
        })
        .buttonStyle(.plain)
    }
}

#Preview {
    Example067()
}
