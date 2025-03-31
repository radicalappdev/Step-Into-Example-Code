//  Step Into Vision - Example Code
//
//  Title: Example060
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/31/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example060: View {
    var body: some View {
        RealityView { content, attachments in

            // Load the scene and position it in the volume
            guard let scene = try? await Entity(named: "PhysicsBodyBasics", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.setScale(.init(repeating: 0.8), relativeTo: nil)
            scene.position.y = -0.4

            guard let stepSphereRed = scene.findEntity(named: "Red_Kinematic"),
                  let stepSphereGreen = scene.findEntity(named: "Green_Trigger"),
                  let stepSphereBlue = scene.findEntity(named: "Blue_Dynamic")
            else { return }
            

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .modifier(DragGestureImproved())
    }
}

#Preview {
    Example060()
}
