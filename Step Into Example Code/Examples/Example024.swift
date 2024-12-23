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
    @State var leftHandTransform: Transform?
    @State private var leftHandAnchor: AnchorEntity?

    var body: some View {
        RealityView { content, attachments in
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

                    Task {
                        while true {
                            if let anchor = leftHandAnchor {
                                leftHandTransform = Transform(matrix: anchor.transformMatrix(relativeTo: nil))
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
                VStack(alignment: .leading, spacing: 12) {
                    if let transform = leftHandTransform {


                        VStack(alignment: .leading) {
                            Text("Translation")
                                .fontWeight(.bold)
                            HStack {
                                Text("X: \(String(format: "%8.3f", transform.translation.x))")
                                    .frame(width: 120, alignment: .leading)
                                Text("Y: \(String(format: "%8.3f", transform.translation.y))")
                                    .frame(width: 120, alignment: .leading)
                                Text("Z: \(String(format: "%8.3f", transform.translation.z))")
                                    .frame(width: 120, alignment: .leading)
                            }
                        }

                        VStack(alignment: .leading) {
                            Text("Scale")
                                .fontWeight(.bold)
                            HStack {
                                Text("X: \(String(format: "%8.3f", transform.scale.x))")
                                    .frame(width: 120, alignment: .leading)
                                Text("Y: \(String(format: "%8.3f", transform.scale.y))")
                                    .frame(width: 120, alignment: .leading)
                                Text("Z: \(String(format: "%8.3f", transform.scale.z))")
                                    .frame(width: 120, alignment: .leading)
                            }
                        }

                        VStack(alignment: .leading) {
                            Text("Rotation \(transform.rotation.angle)")
                                .fontWeight(.bold)
                            HStack {
                            Text("X: \(String(format: "%8.3f", transform.rotation.axis.x))")
                                    .frame(width: 120, alignment: .leading)
                                Text("Y: \(String(format: "%8.3f", transform.rotation.axis.y))")
                                    .frame(width: 120, alignment: .leading)
                                Text("Z: \(String(format: "%8.3f", transform.rotation.axis.z))")
                                    .frame(width: 120, alignment: .leading)
                            }
                        }
                    } else {
                        Text("Hand not tracked")
                    }
                }
                .monospaced()
                .padding()
                .glassBackgroundEffect()
            }
        }
    }
}

#Preview {
    Example024()
}
