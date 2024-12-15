//  Step Into Vision - Example Code
//
//  Title: Example019
//
//  Subtitle: AnchorEntity Hands
//
//  Description: Using AnchorEntity in RealityKit without ARKit.
//
//  Type: Space
//
//  Created by Joseph Simpson on 12/15/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example019: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "HandTrackingLabs", in: realityKitContentBundle) {
                content.add(scene)
                
            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Example019()
}
