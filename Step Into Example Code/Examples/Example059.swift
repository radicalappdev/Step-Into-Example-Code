//  Step Into Vision - Example Code
//
//  Title: Example059
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example059: View {
    var body: some View {
        RealityView { content, attachments in

            // Load the scene and position it in the volume
            guard let scene = try? await Entity(named: "PhysicsBodyBasics", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Example059()
}
