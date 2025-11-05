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

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "SimpleTimeline", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)

        }
        .ornament(attachmentAnchor: .scene(.back), ornament: {
            VStack(spacing: 12) {
                Button(action: {
                    notifyTimeline("MoveRightMessage")
                }, label: {
                    Text("MoveRight")
                })

                Button(action: {
                    notifyTimeline("MoveLeftMessage")
                }, label: {
                    Text("MoveLeft")
                })
            }
            .padding()
            .glassBackgroundEffect()
        })
        
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
