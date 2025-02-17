//  Step Into Vision - Example Code
//
//  Title: Example049
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 2/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example049: View {


    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "RKBasicsLoading", in: realityKitContentBundle) {
                content.add(scene)
                scene.position.y = -0.4



            }

        } update: { content, attachments in

            if let earth = content.entities.first?.findEntity(named: "Earth") {

            }


        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Example049()
}
