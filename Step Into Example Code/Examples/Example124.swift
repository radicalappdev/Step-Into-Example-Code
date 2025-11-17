//  Step Into Vision - Example Code
//
//  Title: Example124
//
//  Subtitle: Timelines: Composing Timelines
//
//  Description: We can next Timelines in others to group actions into small sequences.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 11/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example124: View {

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
                    notifyTimeline("RunParent")
                }, label: {
                    Text("Play")
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
    Example124()
}
