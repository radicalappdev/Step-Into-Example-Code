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
    @State private var session: SpatialTrackingSession?
    @State var leftHandTransform: float4x4?
    @State private var leftHandAnchor: AnchorEntity?

    var body: some View {
        RealityView { content, attachments in
            // First set up the session
            let configuration = SpatialTrackingSession.Configuration(
                tracking: [.hand]
            )
            let session = SpatialTrackingSession()
            await session.run(configuration)
            self.session = session

            if let scene = try? await Entity(named: "HandTrackingLabsTransform", in: realityKitContentBundle) {
                content.add(scene)

                if let leftHandSphere = scene.findEntity(named: "LeftHand") {
                    let leftHand = AnchorEntity(.hand(.left, location: .indexFingerTip))
                    leftHand.addChild(leftHandSphere.clone(recursive: true))
                    leftHand.anchoring.physicsSimulation = .none
                    content.add(leftHand)
                    self.leftHandAnchor = leftHand

                    // Set up transform tracking
                    Task {
                        while true {
                            if let anchor = leftHandAnchor {
                                // Get the world transform directly from the anchor
                                leftHandTransform = anchor.transformMatrix(relativeTo: nil)
                            }
                            try? await Task.sleep(for: .seconds(1/30))
                        }
                    }
                }

                if let panel = attachments.entity(for: "AttachmentContent") {
                    panel.position = [0, 1, -1]
                    content.add(panel)
                }
            }
        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                VStack {
                    
                    Text("Left Hand: \(String(describing: leftHandTransform))")
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
