//  Step Into Vision - Example Code
//
//  Title: Example110
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/13/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example110: View {

    @State private var subjectA = Entity()
    @State private var subjectAToggle = false
    var subjectAToggleAnimation: Binding<Bool> {
        $subjectAToggle.animation(.easeInOut(duration: 1))
    }

    
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "AnimatedComponents", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)
            guard let subjectA = scene.findEntity(named: "SubjectA") else { return }
            self.subjectA = subjectA


        } update: { content in

            content.animate {
                let scaler: Float = subjectAToggle ? 2.0 : 1.0
                subjectA.scale = .init(repeating: scaler)

                if var material = subjectA.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial {
                    material.baseColor.tint = UIColor(subjectAToggle ? .stepRed : .stepGreen)
                    subjectA.components[ModelComponent.self]?.materials[0] = material
                }

                if let spotLightEntity = subjectA.findEntity(named: "SpotLight") {
                    
                }
            }

        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                Toggle(isOn: subjectAToggleAnimation, label: {
                    Text("Toggle Subject A")
                })
            })
        }
    }
}

#Preview {
    Example110()
}
