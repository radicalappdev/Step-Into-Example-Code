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
    @State private var selectedAnimation: Animation = .easeInOut(duration: 1)
    var subjectAToggleAnimation: Binding<Bool> {
        $subjectAToggle.animation(selectedAnimation)
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
                // Animate part of the transfrm
                let scaler: Float = subjectAToggle ? 2.0 : 1.0
                subjectA.scale = .init(repeating: scaler)

                // Animate a material value
                if var material = subjectA.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial {
                    material.baseColor.tint = UIColor(subjectAToggle ? .stepRed : .stepGreen)
                    subjectA.components[ModelComponent.self]?.materials[0] = material
                }

                // Animate a light value
                if let spotLightEntity = subjectA.findEntity(named: "SpotLight") {
                    spotLightEntity.components[SpotLightComponent.self]?.innerAngleInDegrees = subjectAToggle ? 45.0 : 15.0
                    spotLightEntity.components[SpotLightComponent.self]?.innerAngleInDegrees = subjectAToggle ? 60.0 : 20.0
                }
            }

        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    Toggle(isOn: subjectAToggleAnimation, label: {
                        Text("Toggle")
                    })
                }
            })
        }
        .ornament(attachmentAnchor: .scene(.trailing), ornament: {
            VStack {
                Button(action: {
                    selectedAnimation = .easeInOut(duration: 1)
                }, label: {
                    Text("Ease In Out")
                })

                Button(action: {
                    selectedAnimation = .smooth
                }, label: {
                    Text("Smooth")
                })

                Button(action: {
                    selectedAnimation = .snappy
                }, label: {
                    Text("Snappy")
                })

                Button(action: {
                    selectedAnimation = .bouncy
                }, label: {
                    Text("Bouncy")
                })

                Button(action: {
                    selectedAnimation = .bouncy(duration: 1.0, extraBounce: 0.1)
                }, label: {
                    Text("Bouncy + Extra")
                })

                Button(action: {
                    selectedAnimation = .spring(.bouncy(duration: 2.0, extraBounce: 0.1), blendDuration: 0.2)
                }, label: {
                    Text("Spring Bounce")
                })

            }
            .padding()
            .glassBackgroundEffect()
        })
    }
}

#Preview {
    Example110()
}
