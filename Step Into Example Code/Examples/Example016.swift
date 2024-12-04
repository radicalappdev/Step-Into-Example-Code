//  Step Into Vision - Example Code
//
//  Title: Example016
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 12/4/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example016: View {


    @State var vis: Visibility = .automatic

    @State var handTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.left, location: .aboveHand))
        return handAnchor
    }()

    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(scene)
            }

            content.add(handTrackedEntity)

            if let attachmentEntity = attachments.entity(for: "AttachmentContent") {
                attachmentEntity.components[BillboardComponent.self] = .init()

                handTrackedEntity.addChild(attachmentEntity)

            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                HStack(spacing: 12) {
                    Button(action: {
                        vis = .hidden
                    }, label: {
                        Image(systemName: vis == .hidden ? "eye.slash.fill" : "eye.slash")
                    })

                    Button(action: {
                        vis = .visible
                    }, label: {
                        Image(systemName: vis == .visible ? "eye.fill" : "eye")
                    })
                }
            }
        }
        .persistentSystemOverlays(vis)
    }
}

#Preview {
    Example016()
}
