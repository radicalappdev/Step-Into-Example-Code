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

                Text("automatic")
                    .contentShape(.capsule)
//                    .foregroundStyle(.regularMaterial)
                    .hoverEffect(.automatic, isEnabled: enableHoverEffect)

                Circle()
                    .foregroundStyle(.regularMaterial)
                    .hoverEffect(.highlight, isEnabled: enableHoverEffect)

                Circle()
                    .foregroundStyle(.regularMaterial)
                    .hoverEffect(.lift, isEnabled: enableHoverEffect)
            }

            .frame(height: 100)

            HStack(spacing: 24) {

                Circle()
                    .foregroundStyle(.regularMaterial)
                    .hoverEffect(isEnabled: enableHoverEffect)


                Circle()
                    .foregroundStyle(.regularMaterial)
                    .hoverEffect(isEnabled: enableHoverEffect)

                Circle()
                    .foregroundStyle(.regularMaterial)
                    .hoverEffect(isEnabled: enableHoverEffect)

            }
            .defaultHoverEffect(.highlight) // Set the default hover effect for any child views

            .frame(height: 100)
        }
        .padding()
    }
}

#Preview {
    Example035()
}
