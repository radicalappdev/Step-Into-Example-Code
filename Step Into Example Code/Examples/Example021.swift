//  Step Into Vision - Example Code
//
//  Title: Example021
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 12/18/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example021: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "HandTrackingLabs", in: realityKitContentBundle) {
                content.add(scene)

                if let leftHandSphere = scene.findEntity(named: "StepSphereBlue") {
                    let indexTipAnchor = AnchorEntity(.hand(.left, location: .indexFingerTip), trackingMode: .continuous)
                    indexTipAnchor.addChild(leftHandSphere)
                    content.add(indexTipAnchor)

                    let thumbTipAnchor = AnchorEntity(.hand(.left, location: .thumbTip), trackingMode: .continuous)
                    thumbTipAnchor.addChild(leftHandSphere.clone(recursive: true))
                    content.add(thumbTipAnchor)
                }

                if let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {

                    let palmAnchor = AnchorEntity(.hand(.left, location: .palm), trackingMode: .continuous)
                    palmAnchor.addChild(rightHandSphere.clone(recursive: true))
                    palmAnchor.position =  [0, 0.05, 0]
                    palmAnchor.scale = [3, 3, 3]
                    content.add(palmAnchor)

                }

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
    Example021()
}
