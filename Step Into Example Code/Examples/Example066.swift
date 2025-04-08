//  Step Into Vision - Example Code
//
//  Title: Example066
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/8/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example066: View {
    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(named: "PhysicsMaterialResource", in: realityKitContentBundle) else { return }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Example066()
}
