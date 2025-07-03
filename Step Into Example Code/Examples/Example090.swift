//  Step Into Vision - Example Code
//
//  Title: Example090
//
//  Subtitle: Redirect input with Manipulation Component
//
//  Description: We can use HitTargetComponent to send manipulation input from one entity to another.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 7/3/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example090: View {

    var body: some View {
        RealityView { content in

            let subject = createStepDemoBox()

            let audioComponent = AmbientAudioComponent()
            subject.components.set(audioComponent)

            // We'll use configureEntity to set up input and collision on the subject
            ManipulationComponent
                .configureEntity(
                    subject,
                    allowedInputTypes: .direct,
                    collisionShapes: [.generateBox(width: 0.25, height: 0.25, depth: 0.25)]
                )

            // Create the component and add it to the entity
            let mc = ManipulationComponent()

            // Add the component and
            subject.components.set(mc)
            content.add(subject)

            // Create a second entity.
            let delegate = createStepDemoBox()

            delegate.scale = .init(repeating: 0.5)
            delegate.position = .init(x: 0, y: -0.3, z: 0.3)

            // ❌ If we use configureEntity on the entity, then this does not work
            // ManipulationComponent.configureEntity(delegate,collisionShapes: [.generateSphere(radius: 0.1)])

            // ✅ Create the collision and input manually
            delegate.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
            delegate.components.set(InputTargetComponent())
            delegate.components.set(HoverEffectComponent())
            
            let hitTargetComponent = ManipulationComponent.HitTargetComponent(redirectedEntityID: subject.id)
            delegate.components.set(hitTargetComponent)
            content.add(delegate)

        }
    }
}

#Preview {
    Example090()
}
