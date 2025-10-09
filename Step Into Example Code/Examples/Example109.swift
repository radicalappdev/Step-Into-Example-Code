//  Step Into Vision - Example Code
//
//  Title: Example109
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/9/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example109: View {
    @State private var subjectA = Entity()

    @State private var subjectAToggle = false
    var subjectAToggleAnimation: Binding<Bool> {
        $subjectAToggle.animation(.easeInOut(duration: 1))
    }

    @State private var subjectBToggle = false

    var body: some View {
        RealityView { content in

            let subjectA = createStepDemoBox("subjectA", true)
            self.subjectA = subjectA
            subjectA.position.x = -0.2
            content.add(subjectA)


            let subjectB = createStepDemoBox("subjectB", true)
            subjectB.position.x = 0.2
            content.add(subjectB)

            let tap = TapGesture().onEnded({ [weak subjectB] _ in
                // We'll use a SwiftUI animation to scale the entity
                Entity.animate(.easeInOut(duration: 1), body: {
                    subjectBToggle.toggle()
                    let scaler: Float = subjectBToggle ? 2.0 : 1.0
                    subjectB?.scale = .init(repeating: scaler)
                })
            })
            let gesture = GestureComponent(tap)
            subjectB.components.set(gesture)


        } update: { content in

            content.animate {
                let scaler: Float = subjectAToggle ? 2.0 : 1.0
                subjectA.scale = .init(repeating: scaler)
            }

        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                Toggle(isOn: subjectAToggleAnimation, label: {
                    Text("Toggle Subject")
                })
            })
        }
    }
}

#Preview {
    Example109()
}
