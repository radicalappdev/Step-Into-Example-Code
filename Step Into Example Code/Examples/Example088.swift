//  Step Into Vision - Example Code
//
//  Title: Example088
//
//  Subtitle: Using events with Manipulation Component
//
//  Description: We can use events to modify the entity during the gesture or save state at the end.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 7/1/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example088: View {

    // An entity we can manipulate
    @State private var subject = createStepDemoBox()
    
    var body: some View {
        RealityView { content in

            subject.position.y = -0.2

            // We'll use configureEntity to set up input and collision on the subject
            ManipulationComponent
                .configureEntity(
                    subject,
                    hoverEffect: .spotlight(.default),
                    collisionShapes: [.generateBox(width: 0.25, height: 0.25, depth: 0.25)]
                )

            // Create the component and add it to the entity
            let mc = ManipulationComponent()

            // Add the component and
            subject.components.set(mc)
            content.add(subject)


            // Manipulation Component Events

            // *WillBegin* fires when manipulation starts
            // For example, changing from dynamic to kinematic physics, hiding a hover effect, deactiving children, etc.
            _ = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                // Remove the hover effect when manipulating an entity
                event.entity.components.remove(HoverEffectComponent.self)
            }


            // *DidUpdateTransform* can be useful for constraining the transform of the entity
            // For example, don't allow an entity to move out of fixed area or disallow rotation on an axis
            _ = content.subscribe(to: ManipulationEvents.DidUpdateTransform.self) { event in
                // For an example, see [Constrain position with ManipulationComponent](https://stepinto.vision/example-code/constrain-position-with-manipulationcomponent/)
            }


            // *DidHandOff* can be useful if we need to apply hand-specific offsets to the entity
            _ = content.subscribe(to: ManipulationEvents.DidHandOff.self) { event in
                // Apply offsets by using the pose of the hands
            }


            // *WillRelease* is fired just before manipulation ends
            // This can be a good place to reset visual effects
            // We use this to re-add the hover effect
            _ = content.subscribe(to: ManipulationEvents.WillRelease.self)  { event in
                let hover = HoverEffectComponent(.spotlight(.default))
                event.entity.components.set(hover)

            }


            // *WillEnd* is fired at the end. The gesture is no longer updating the entity
            // This can be useful to reset physics or save transform data in app state
            _ = content.subscribe(to: ManipulationEvents.WillEnd.self)  { event in
                // persist transform data here
            }

        }
        .debugBorder3D(.white)
    }
}

#Preview {
    Example088()
}
