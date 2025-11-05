//  Step Into Vision - Example Code
//
//  Title: Example119
//
//  Subtitle: Timelines: Working with Notifications
//
//  Description: Sending notifications from code to trigger a behavior, and sending notifications from a timeline to trigger code.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 11/5/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example119: View {
    @Environment(\.realityKitScene) var scene

    @State var isLeft: Bool = true
    @State var isRight: Bool = false

    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "SimpleTimeline", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)
        }
        .ornament(attachmentAnchor: .scene(.back), ornament: {
            VStack(spacing: 12) {
                HStack {
                    Button(action: {
                        notifyTimeline("MoveLeftMessage")
                        isLeft = false
                        isRight = false
                    }, label: {
                        Text("MoveLeft")
                    })

                    Spacer()

                    Button(action: {
                        notifyTimeline("MoveRightMessage")
                        isLeft = false
                        isRight = false
                    }, label: {
                        Text("MoveRight")
                    })
                }

                HStack {
                    Circle()
                        .fill(isLeft ? .green : .white)
                        .frame(width: 60, height: 60)
                    Spacer()
                    Circle()
                        .fill(isRight ? .green : .white)
                        .frame(width: 60, height: 60)

                }
                .frame(width: 300)
            }
            .padding()
            .glassBackgroundEffect()
        })
        // 2. Timelines can use the Notification action to send a message that we can receive here
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("RealityKit.NotificationTrigger"))) { notification in
            // We can unpack Scene and Identifier
            // We use Identifier to determine what notification was sent
            // We can use Scene if we need to do something inside the RealityKit context
            guard
                let userInfo = notification.userInfo,
                let scene = userInfo["RealityKit.NotificationTrigger.Scene"] as? RealityKit.Scene,
                let identifier = userInfo["RealityKit.NotificationTrigger.Identifier"] as? String
            else { return }

            switch identifier {
            case "ReachedRight":
                print("Timeline sent: ReachedRight")
                isRight = true
            case "ReachedLeft":
                print("Timeline sent: ReachedLeft")
                isLeft = true
            default:
                print("Unknown message from timeline: \(identifier) in \(scene)")
                break
            }
        }
    }

    // 1. Send notifications to trigger a behavior on an entity, which will run a timeline
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
    Example119()
}


