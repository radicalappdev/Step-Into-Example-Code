//  Step Into Vision - Example Code
//
//  Title: Example035
//
//  Subtitle: Spatial SwiftUI: hoverEffect modifier
//
//  Description: Taking a look (😜) at hoverEffect modifier.
//
//  Type: Window
//
//  Created by Joseph Simpson on 1/10/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example035: View {

    @State var enableHoverEffect: Bool = false

    var body: some View {
        VStack() {

            Toggle("Hover Effect", isOn: $enableHoverEffect)
                .toggleStyle(.button)

            HStack(spacing: 24) {

                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("automatic"))
                    .hoverEffect(.automatic, isEnabled: enableHoverEffect)

                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("highlight"))
                    .hoverEffect(.highlight, isEnabled: enableHoverEffect)

                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("lift"))
                    .hoverEffect(.lift, isEnabled: enableHoverEffect)
            }
            .frame(height: 60)
            Text("system hover effects")
                .font(.caption2)

            HStack(spacing: 24) {

                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("Custom: fade"))
                    .hoverEffect(FadeHoverEffect(), isEnabled: enableHoverEffect)

                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("Custom: scale"))
                    .hoverEffect(ScaleHoverEffect(), isEnabled: enableHoverEffect)

                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("Custom: tilt"))
                    .hoverEffect(TiltHoverEffect(), isEnabled: enableHoverEffect)
            }
            .frame(height: 60)

            Text("custom hover effects")
                .font(.caption2)

            HStack(spacing: 24) {
                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("Custom: mashup"))
                    .hoverEffect(isEnabled: enableHoverEffect)

                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("Custom: mashup"))
                    .hoverEffect(isEnabled: enableHoverEffect)

                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("Custom: mashup"))
                    .hoverEffect(isEnabled: enableHoverEffect)
            }
            .frame(height: 60)
            .defaultHoverEffect(CustomMashupHoverEffect())
            Text("from parent using defaultHoverEffect")
                .font(.caption2)

        }
        .padding()
    }
}

struct FadeHoverEffect: CustomHoverEffect {
    func body(content: Content) -> some CustomHoverEffect {
        content.hoverEffect { effect, isActive, proxy in
            effect.animation(.easeOut) {
                $0.opacity(isActive ? 0.5 : 1)
            }
        }
    }
}

struct ScaleHoverEffect: CustomHoverEffect {
    func body(content: Content) -> some CustomHoverEffect {
        content.hoverEffect { effect, isActive, proxy in
            effect.animation(.easeOut) {
                $0.scaleEffect(
                    isActive ? CGSize(width: 1.2, height: 1.2) : CGSize(width: 1, height: 1),
                    anchor: .center
                )
            }
        }
    }
}

struct TiltHoverEffect: CustomHoverEffect {
    func body(content: Content) -> some CustomHoverEffect {
        content.hoverEffect { effect, isActive, proxy in
            effect.animation(.easeOut) {
                $0.rotationEffect(.degrees(isActive ? 15 : 0), anchor: .bottomTrailing)
            }
        }
    }
}

// add a versin to combine these three examples
struct CustomMashupHoverEffect: CustomHoverEffect {
    func body(content: Content) -> some CustomHoverEffect {
        content.hoverEffect { effect, isActive, proxy in
            effect.animation(.easeOut) {
                $0.opacity(isActive ? 1 : 0.5)
                    .rotationEffect(.degrees(isActive ? 10 : 0), anchor: .bottomTrailing)
                    .scaleEffect(
                        isActive ? CGSize(width: 1.1, height: 1.1) : CGSize(width: 1, height: 1),
                        anchor: .center
                    )
            }
        }
    }
}



#Preview {
    Example035()
}
