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


        } update: { content, attachments in

        } attachments: {
            Attachment(id: "Example01") {
                Text("Collision + Input")
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

                NotificationCenter.default.post(
                    name: NSNotification.Name("RealityKit.NotificationTrigger"),
                    object: nil,
                    userInfo: [
                        "RealityKit.NotificationTrigger.Scene": scene,
                        "RealityKit.NotificationTrigger.Identifier": "MoveTriggerToSwitch"
                    ]
                )
            })
    }
}

#Preview {
    Example056()
}
