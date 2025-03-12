//  Step Into Vision - Example Code
//
//  Title: Example056
//
//  Subtitle: Collisions & Physics: Collision Usecases
//
//  Description: The Collision Component is used input, collision detection, and physics.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 3/12/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example056: View {
    // We need to get the realityKitScene to be able to send notifications that trigger behaviors
    @Environment(\.realityKitScene) var scene

    @State var exampleInput = Entity()
    @State var collisionExampleEvent: EventSubscription?

    var body: some View {
        RealityView { content, attachments in

            // Load the scene and position it in the volume
            guard let scene = try? await Entity(named: "CollisionUsecases", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            // Example 01: The red sphere has input and collision components, which allows it to receive targeted gestures like tap drag, etc. We'll send a notification to call a timeline to start moving the green sphere.
            // Example 02: The green sphere has a collision the mode set to trigger. When it collides with the triggerSwitch, we will reset the position of the blue sphere.
            // Example 03: The blue sphere collision and physics body components. Gravity is enabled, so it will fall to the table.
            if let input = scene.findEntity(named: "ExampleInput"),
                let triggerSwitch = scene.findEntity(named: "ExampleTriggerSwitch"),
                let examplePhysics = scene.findEntity(named: "ExamplePhysics")  {

                input.components.set(HoverEffectComponent())
                exampleInput = input

                collisionExampleEvent = content
                    .subscribe(to: CollisionEvents.Began.self, on: triggerSwitch)  { _ in
                        examplePhysics.setPosition([0.25, 1, 0], relativeTo: examplePhysics.parent)
                    }

                // Position our attachments
                if let label01 = attachments.entity(for: "Example01") {
                    label01.setPosition([0,0.2,0], relativeTo: input)
                    label01.components.set(BillboardComponent())
                    content.add(label01)
                }
                if let label02 = attachments.entity(for: "Example02") {
                    label02.setPosition([0,0.12,0], relativeTo: triggerSwitch)
                    label02.components.set(BillboardComponent())
                    content.add(label02)
                }

                if let label03 = attachments.entity(for: "Example03") {
                    label03.setPosition([0.25,0.3,0], relativeTo: nil)
                    label03.components.set(BillboardComponent())
                    content.add(label03)
                }

            }

        } update: { content, attachments in
        } attachments: {
            Attachment(id: "Example01") {
                Text("Collision + Input")
                    .font(.title)
                    .padding()
                    .glassBackgroundEffect()
            }

            Attachment(id: "Example02") {
                Text("Collision triggers an action")
                    .font(.title)
                    .padding()
                    .glassBackgroundEffect()
            }

            Attachment(id: "Example03") {
                Text("Collision shapes are used for physics")
                    .font(.title)
                    .padding()
                    .glassBackgroundEffect()
            }
        }
        .gesture(inputTapExample)
    }

    var inputTapExample: some Gesture {
        TapGesture().targetedToEntity(exampleInput)
            .onEnded({ value in

                // Fire a behavior from the scene in Reality Composer Pro
                _ = value.entity.applyTapForBehaviors()

                // Then fire a notification to move the trigger sphere to the switch
                NotificationCenter.default.post(
                    name: NSNotification.Name("RealityKit.NotificationTrigger"),
                    object: nil,
                    userInfo: [
                        "RealityKit.NotificationTrigger.Scene": scene as Any,
                        "RealityKit.NotificationTrigger.Identifier": "MoveTriggerToSwitch"
                    ]
                )
            })
    }
}

#Preview {
    Example056()
}
