//  Step Into Vision - Example Code
//
//  Title: Example086
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 6/28/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example086: View {
    var body: some View {
        RealityView { content in

            // An entity we can manipulate
            let subject = createStepDemoBox()

            // We'll use configureEntity to set up input and collision
            ManipulationComponent.configureEntity(subject, collisionShapes: [.generateBox(width: 0.25, height: 0.25, depth: 0.25)])


            // Create the component and add it to the entity
            var mc = ManipulationComponent()
            mc.releaseBehavior = .reset
            subject.components.set(mc)

            // Listen to the transform change event and constrain the position within a fixed volume
            _ = content.subscribe(to: ManipulationEvents.DidUpdateTransform.self) { event in
                let newPostion = event.entity.position
                // An arbitrary value to constrain movement with the hardcoded volume size
                // Ideally, this should be read from the current size of the volume
                let limit: Float = 0.34
                let posX = min(max(newPostion.x, -limit), limit)
                let posY = min(max(newPostion.y, -limit), limit)
                let posZ = min(max(newPostion.z, -limit), limit)
                event.entity.position = .init(x: posX, y: posY, z: posZ)
            }
            content.add(subject)
        }
        .debugBorder3D(.white)
    }
}

#Preview {
    Example086()
}
