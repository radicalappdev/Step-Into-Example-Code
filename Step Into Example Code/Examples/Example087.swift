//  Step Into Vision - Example Code
//
//  Title: Example087
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 6/30/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example087: View {
    var body: some View {
        RealityView { content in

            // An entity we can manipulate
            let subject = createStepDemoBox()

            // We'll use configureEntity to set up input and collision
            ManipulationComponent.configureEntity(subject, collisionShapes: [.generateBox(width: 0.25, height: 0.25, depth: 0.25)])

            // Create the component and add it to the entity
            var mc = ManipulationComponent()
            mc.releaseBehavior = .reset

            // Add the component and
            subject.components.set(mc)
            content.add(subject)
        }
        .debugBorder3D(.white)
    }
}

#Preview {
    Example087()
}
