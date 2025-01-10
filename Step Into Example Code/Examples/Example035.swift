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
        VStack(spacing: 24) {

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
            .frame(height: 100)

            HStack(spacing: 24) {

                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("Custom: fade"))
                    .hoverEffect(FadeHoverEffect())

                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("Custom: scale"))
                    .hoverEffect(.highlight, isEnabled: enableHoverEffect)
                    .hoverEffect(ScaleHoverEffect())

                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("lift"))
                    .hoverEffect(.lift, isEnabled: enableHoverEffect)
            }
            .frame(height: 100)

            HStack(spacing: 24) {
                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("automatic"))
                    .hoverEffect(isEnabled: enableHoverEffect)

                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("highlight"))
                    .hoverEffect(isEnabled: enableHoverEffect)

                Capsule()
                    .foregroundStyle(.regularMaterial)
                    .overlay(Text("lift"))
                    .hoverEffect(isEnabled: enableHoverEffect)
            }
            .frame(height: 100)
            .defaultHoverEffect(.highlight)

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


#Preview {
    Example035()
}
