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
            .defaultHoverEffect(.highlight)

            .frame(height: 100)
        }
        .padding()
    }
}

#Preview {
    Example035()
}
