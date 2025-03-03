//  Step Into Vision - Example Code
//
//  Title: Example053
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/3/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example053: View {
    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(named: "SwiftUIScienceLab", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            if let panel = attachments.entity(for: "AttachmentContent") {

                panel.position.y = 0.1
                content.add(panel)
            }



        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                VStack() {
                    Text("Attachment")
                        .font(.extraLargeTitle2)

                    HStack {
                        Image(systemName: "chart.bar.xaxis")
                        Image(systemName: "chart.xyaxis.line")
                    }
                    .padding()
                    .font(.system(size: 144))
                    .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding()

                .frame(width: 460, height: 500)
                .glassBackgroundEffect()
            }
        }
    }
}

#Preview {
    Example053()
}
