//  Step Into Vision - Example Code
//
//  Title: Example123
//
//  Subtitle: Timelines: Sending one Notification to trigger multiple Behaviors
//
//  Description: We can trigger more than one Behavior/Timeline using a single notification, even when the timelines are defined in different files.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 11/13/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example123: View {

    @Environment(\.realityKitScene) var scene
    
    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "SharedNotification", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                Button(action: {
                    notifyTimeline("RunTimelines")
                }, label: {
                    Text("Send")
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
    Example123()
}
