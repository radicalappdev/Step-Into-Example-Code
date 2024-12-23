//  Step Into Vision - Example Code
//
//  Title: Example023
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 12/23/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example023: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "HandTrackingLabsPhysics", in: realityKitContentBundle) {
                content.add(scene)
                
                // 1. Set up a Spatial Tracking Session with hand tracking.
                // This will add ARKit features to our Anchor Entities, enabling access to transforms, collisions, and physics.
                let configuration = SpatialTrackingSession.Configuration(
                    tracking: [.hand]
                )
                let session = SpatialTrackingSession()
                await session.run(configuration)

                if let leftHandSphere = scene.findEntity(named: "LeftHand") {

                    // 2. Create an anchor for the left index finger
                    let leftHand = AnchorEntity(.hand(.left, location: .indexFingerTip),
                                                    trackingMode: .continuous)
                    leftHand.addChild(leftHandSphere.clone(recursive: true))
                    leftHandSphere.position = .zero

                    // 3. Disable the default physics simulation on the anchor
                    leftHand.anchoring.physicsSimulation = .none
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
    Example023()
}
