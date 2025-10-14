//  Step Into Vision - Example Code
//
//  Title: Example111
//
//  Subtitle: RealityKit Basics: SwiftUi Animation Completion
//
//  Description: Calling code when our animation finishes.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 10/14/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example111: View {

    // For this example, we'll use a state var. In a production app it makes more sense to keep entity state in components
    @State private var subjectAToggle = false
    @State private var animationCounter: Int = 0

    var body: some View {
        RealityView { content in

            let subjectA = createStepDemoBox("subjectA", true)
            content.add(subjectA)
            let tapA = TapGesture().onEnded({ [weak subjectA] _ in
                // We'll use a SwiftUI animation to scale the entity
                Entity.animate(.bouncy(duration: 0.6, extraBounce: 0.2), body: {
                    subjectAToggle.toggle()

                    if let entity = subjectA {
                        let scaler: Float = subjectAToggle ? 1.5 : 1.0
                        entity.scale = .init(repeating: scaler)
                    }

                }, completion: {
                    // When the animation finishes we'll increment the counter
                    withAnimation(.easeOut) {
                        animationCounter += 1
                    }
                })
            })
            let gestureA = GestureComponent(tapA)
            subjectA.components.set(gestureA)

        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    Text("Count:")
                    Spacer()
                    Text("\(animationCounter)")
                        .contentTransition(.numericText(countsDown: false))
                }
                .font(.title)
                .frame(width: 120)
            })
        }
    }
}

#Preview {
    Example111()
}
