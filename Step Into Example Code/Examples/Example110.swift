//  Step Into Vision - Example Code
//
//  Title: Example110
//
//  Subtitle: RealityKit Basics: Exploring SwiftUi Animations
//
//  Description: Selecting from a short list of animation. Animating several RealityKit values.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 10/13/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example110: View {

    @State private var subjectA = Entity()
    @State private var subjectAToggle = false
    enum AnimChoice {
        case easeInOut
        case smooth
        case snappy
        case bouncy
        case bouncyExtra
        case springBounce

        var animation: Animation {
            switch self {
            case .easeInOut:
                return .easeInOut(duration: 1)
            case .smooth:
                return .smooth
            case .snappy:
                return .snappy
            case .bouncy:
                return .bouncy
            case .bouncyExtra:
                return .bouncy(duration: 1.0, extraBounce: 0.1)
            case .springBounce:
                return .spring(.bouncy(duration: 2.0, extraBounce: 0.1), blendDuration: 0.2)
            }
        }
    }

    @State private var selectedAnim: AnimChoice = .easeInOut
    var selectedAnimation: Animation { selectedAnim.animation }
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
        .ornament(attachmentAnchor: .scene(.trailing), ornament: {
            VStack(alignment: .leading, spacing: 8) {
                Button(action: { selectedAnim = .easeInOut }) {
                    Label("EaseInOut", systemImage: selectedAnim == .easeInOut ? "checkmark.circle.fill" : "circle")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button(action: { selectedAnim = .springBounce }) {
                    Label("Spring", systemImage: selectedAnim == .springBounce ? "checkmark.circle.fill" : "circle")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button(action: { selectedAnim = .smooth }) {
                    Label("Smooth", systemImage: selectedAnim == .smooth ? "checkmark.circle.fill" : "circle")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button(action: { selectedAnim = .snappy }) {
                    Label("Snappy", systemImage: selectedAnim == .snappy ? "checkmark.circle.fill" : "circle")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button(action: { selectedAnim = .bouncy }) {
                    Label("Bouncy", systemImage: selectedAnim == .bouncy ? "checkmark.circle.fill" : "circle")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button(action: { selectedAnim = .bouncyExtra }) {
                    Label("Bouncy+ ", systemImage: selectedAnim == .bouncyExtra ? "checkmark.circle.fill" : "circle")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(width: 160)
            .padding()
            .glassBackgroundEffect()
            // Yep, ornament on an ornament. What are you going to do? Call the ornament police?
            .ornament(attachmentAnchor: .parent(.top), contentAlignment: .bottom, ornament: {
                HStack {
                    Toggle(isOn: subjectAToggleAnimation, label: {
                        Text("Toggle")
                    })
                    .toggleStyle(.button)
                    .padding()
                }
                .glassBackgroundEffect()
            })
        })
    }
}

#Preview {
    Example110()
}


