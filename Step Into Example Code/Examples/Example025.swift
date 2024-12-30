//  Step Into Vision - Example Code
//
//  Title: Example025
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 12/30/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example025: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "HandAnchoringLabs", in: realityKitContentBundle) {
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
    Example025()
}
