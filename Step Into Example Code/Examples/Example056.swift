//  Step Into Vision - Example Code
//
//  Title: Example056
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/12/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example056: View {
    @Environment(\.realityKitScene) var scene

    @State var exampleInput = Entity()
    @State var collisionExampleEvent: EventSubscription?

    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(named: "CollisionUsecases", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            if let input = scene.findEntity(named: "ExampleInput") {
                input.components.set(HoverEffectComponent())
                exampleInput = input

                if let label01 = attachments.entity(for: "Example01") {
                    label01.setPosition([0,0.2,0], relativeTo: input)
                    label01.components.set(BillboardComponent())
                    content.add(label01)
                }
            }

            if let label02 = attachments.entity(for: "Example02") {
                label02.setPosition([0,0.12,0], relativeTo: nil)
                label02.components.set(BillboardComponent())
                content.add(label02)
            }

            if let triggerSwitch = scene.findEntity(named: "ExampleTriggerSwitch"), let examplePhysics = scene.findEntity(named: "ExamplePhysics") {


                collisionExampleEvent = content
                    .subscribe(to: CollisionEvents.Began.self, on: triggerSwitch)  { collisionEvent in
                        print("Collision Subject Bounce \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")

                        examplePhysics.setPosition([0.25, 1, 0], relativeTo: nil)
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
