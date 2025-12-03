//  Step Into Vision - Example Code
//
//  Title: Example132
//
//  Subtitle: Some name
//
//  Description: wow
//
//  Type: Window
// Featured: true
//  Created by Joseph Simpson on 12/3/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example132: View {
    var body: some View {
        RealityView { content, attachments in

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Example132()
}
