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

            if let scene = try? await Entity(named: "HandTrackingLabs", in: realityKitContentBundle) {
                content.add(scene)
                
                // 1. Set up a Spatial Tracking Session with hand tracking.
                // This will add ARKit features to our Anchor Entities, enabling access to transforms, collisions, and physics.
                let configuration = SpatialTrackingSession.Configuration(
                    tracking: [.hand]
                )
                let session = SpatialTrackingSession()
                await session.run(configuration)

                if let leftHandSphere = scene.findEntity(named: "StepSphereBlue") {

                    // 2. Create an anchor for the left index finger
                    let leftThumbTip = AnchorEntity(.hand(.left, location: .joint(for: .thumbTip)),
                                                    trackingMode: .continuous)
                    leftThumbTip.addChild(leftHandSphere.clone(recursive: true))

                    // 3. Disable the default physics simulation on the anchor
                    leftThumbTip.anchoring.physicsSimulation = .none
                    content.add(leftThumbTip)

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
