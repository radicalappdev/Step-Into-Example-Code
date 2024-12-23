//  Step Into Vision - Example Code
//
//  Title: Example024
//
//  Subtitle: Access Hand Anchor Transforms
//
//  Description: We can add a Spatial Tracking Session if we need to access the transforms of hand anchors.
//
//  Type: Space
//
//  Created by Joseph Simpson on 12/23/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example024: View {

    @State var leftHand = AnchorEntity(.hand(.left, location: .indexFingerTip))

    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "HandTrackingLabsTransform", in: realityKitContentBundle) {
                content.add(scene)

                // 1. Set up a Spatial Tracking Session with hand tracking.
                // This will add ARKit features to our Anchor Entities, enabling access to transforms, collisions, and physics.
                let configuration = SpatialTrackingSession.Configuration(
                    tracking: [.hand]
                )
                let session = SpatialTrackingSession()
                await session.run(configuration)

                if let leftHandSphere = scene.findEntity(named: "LeftHand") {
                    leftHand.addChild(leftHandSphere.clone(recursive: true))
                    content.add(leftHand)
                }

                if let rightHandSphere = scene.findEntity(named: "RightHand") {

                    let rightHand = AnchorEntity(.hand(.right, location: .indexFingerTip),
                                                 trackingMode: .continuous)
                    rightHand.addChild(rightHandSphere.clone(recursive: true))
                    rightHandSphere.position = .zero

                    rightHand.anchoring.physicsSimulation = .none
                    content.add(rightHand)
                }

                // add our attachment to the scene
                if let panel = attachments.entity(for: "AttachmentContent") {
                    panel.position = [0, 1, -1]
                    content.add(panel)
                }

            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                VStack {
                    Text("Left Hand: \(leftHand.transform)")

                }
                .padding()
                .glassBackgroundEffect()

            }
        }
    }
}

#Preview {
    Example024()
}
