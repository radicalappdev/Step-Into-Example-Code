//  Step Into Vision - Example Code
//
//  Title: Example114
//
//  Subtitle: Environment Blending Component
//
//  Description: We can use this to control how entities blend in with objects in our environment.
//
//  Type: Space
//
//  Created by Joseph Simpson on 10/23/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example114: View {
    var body: some View {
        RealityView { content in

            let subject1 = createStepDemoBox("subject1")
            subject1.position = [-0.2, 0.1, -1]
            content.add(subject1)

            let subject2 = createStepDemoBox("subject2")
            subject2.position = [0.2, 0.1, -1]

            let ebc = EnvironmentBlendingComponent(
                preferredBlendingMode: .occluded(by: .surroundings)
            )

            subject2.components.set(ebc)
            content.add(subject2)

        }
    }
}

#Preview {
    Example114()
}
