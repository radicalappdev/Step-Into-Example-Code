//  Step Into Vision - Example Code
//
//  Title: Example119
//
//  Subtitle:
//
//  Description:
//
//  Type:
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
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("RealityKit.NotificationTrigger"))) { notification in
            guard
                let userInfo = notification.userInfo,
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
                break
            }
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
    Example119()
}
