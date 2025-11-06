//  Step Into Vision - Example Code
//
//  Title: Example120
//
//  Subtitle: Working with Behaviors
//
//  Description: We can use Behaviors in Reality Composer Pro run Timelines that contain one or more actions.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 11/6/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example120: View {

    @Environment(\.realityKitScene) var scene

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "SimpleBehaviors", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)

            guard let car = scene.findEntity(named: "ToyCar") else { return }
            let tapGesture = TapGesture()
                .targetedToEntity(car)
                .onEnded { value in

                    let didTap = value.entity.applyTapForBehaviors()
                    print("did tap car: \(didTap)")

                }
            car.components.set(GestureComponent(tapGesture))


        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                Button(action: {
                    notifyTimeline("JumpThePlane")
                }, label: {
                    Text("Jump the Plane")
                })
            })
        }

    }
    func notifyTimeline(_ identifier: String) {
        if let scene = scene {
            NotificationCenter.default.post(
                name: NSNotification.Name("RealityKit.NotificationTrigger"),
                object: nil,
                userInfo: [
                    "RealityKit.NotificationTrigger.Scene": scene,
                    "RealityKit.NotificationTrigger.Identifier": identifier
                ]
            )
        }
    }
}

#Preview {
    Example120()
}

