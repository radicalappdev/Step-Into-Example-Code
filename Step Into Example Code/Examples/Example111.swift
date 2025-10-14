//  Step Into Vision - Example Code
//
//  Title: Example111
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/14/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example111: View {

    // For this example, we'll use a state var. In a production app it makes more sense to keep entity state in components
    @State private var subjectAToggle = false
    @State private var subjectBToggle = false

    var body: some View {
        RealityView { content in

            let subjectA = createStepDemoBox("subjectA", true)
            content.add(subjectA)
            let tapA = TapGesture().onEnded({ [weak subjectA] _ in
                // We'll use a SwiftUI animation to scale the entity
                Entity.animate(.easeInOut(duration: 1), body: {
                    subjectBToggle.toggle()
                    let scaler: Float = subjectBToggle ? 1.5 : 1.0
                    subjectA?.scale = .init(repeating: scaler)
                })
            })
            let gestureA = GestureComponent(tapA)
            subjectA.components.set(gestureA)
            subjectA.position.x = -0.2

            let subjectB = createStepDemoBox("subjectB", true)
            content.add(subjectB)

            let tapB = TapGesture().onEnded({ [weak subjectB] _ in
                // We'll use a SwiftUI animation to scale the entity
                Entity.animate(.easeInOut(duration: 1), body: {
                    subjectBToggle.toggle()
                    let scaler: Float = subjectBToggle ? 1.5 : 1.0
                    subjectB?.scale = .init(repeating: scaler)
                })
            })
            let gestureB = GestureComponent(tapB)
            subjectB.components.set(gestureB)
            subjectB.position.x = 0.2
            subjectB.transform.rotation = .init(angle: .pi / 4, axis: [0, 1, 0])

        }
    }
}

#Preview {
    Example111()
}
