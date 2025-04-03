//  Step Into Vision - Example Code
//
//  Title: Example063
//
//  Subtitle: Collisions & Physics: Hello Physics Motion Component
//
//  Description: We can use this component to read or write angular and linear velocity.
//
//  Type:
//
//  Created by Joseph Simpson on 4/3/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example063: View {
    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(named: "PhysicsMotionBasics", in: realityKitContentBundle) else { return }

            content.add(scene)

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Example063()
}
