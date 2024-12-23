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

// FYI, this is only an example for how to access and display the transform data from an AnchorEntity
struct Example024: View {
    @State var session: SpatialTrackingSession?
    @State var leftHandTransform: Transform?
    @State var leftHandAnchor: AnchorEntity?

    var body: some View {
        RealityView { content, attachments in

            // 1. Set up a Spatial Tracking Session with hand tracking.
            // This will add ARKit features to our Anchor Entities, enabling access to transforms, collisions, and physics.
            let configuration = SpatialTrackingSession.Configuration(
                tracking: [.hand]
            )
            let session = SpatialTrackingSession()
            await session.run(configuration)
            self.session = session

            if let scene = try? await Entity(named: "HandTrackingLabsTransform", in: realityKitContentBundle) {
                content.add(scene)

                // 2. Attach a sphere to our anchor so we can see something in the scene
                if let leftHandSphere = scene.findEntity(named: "LeftHand") {
                    let leftHand = AnchorEntity(.hand(.left, location: .indexFingerTip))
                    leftHand.addChild(leftHandSphere.clone(recursive: true))
                    leftHand.anchoring.physicsSimulation = .none
                    content.add(leftHand)
                    self.leftHandAnchor = leftHand
                }

                if let redSphere = scene.findEntity(named: "StepSphereRed"), let panel = attachments.entity(for: "AttachmentContent") {
                    redSphere.addChild(panel)
                    panel.setPosition([0, 0.2 ,0], relativeTo: redSphere)
                    panel.components[BillboardComponent.self] = .init()
                    content.add(redSphere)
                }
            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                VStack(alignment: .leading, spacing: 12) {
                    if let transform = leftHandTransform {
                        VectorDisplay(title: "Translation", vector: transform.translation)
                        VectorDisplay(title: "Scale", vector: transform.scale)
                        VStack(alignment: .leading) {
                            Text("Rotation \(transform.rotation.angle)")
                                .fontWeight(.bold)
                            VectorDisplay(title: "", vector: transform.rotation.axis)
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
        .modifier(DragGestureImproved())
        .persistentSystemOverlays(.hidden)
        .upperLimbVisibility(.hidden)
        .task {
            while true {
                // 3. Periodically check the anchor transform and stash it in SwiftUi state.
                // This will update our attachment
                if let anchor = leftHandAnchor {
                    // anchor.transform does not work. This seems to be the anchored entity's transform relative to the anchor itself, which we are never changing.
                    // leftHandTransform = anchor.transform
                    // Instead we can access the anchors global transform
                    leftHandTransform = Transform(matrix: anchor.transformMatrix(relativeTo: nil))
                }
                try? await Task.sleep(for: .seconds(1/30))
            }

        }
    }
}

fileprivate struct VectorDisplay: View {
    let title: String
    let vector: SIMD3<Float>

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.bold)
            HStack {
                ForEach(["X", "Y", "Z"], id: \.self) { axis in
                    Text("\(axis): \(String(format: "%8.3f", axis == "X" ? vector.x : axis == "Y" ? vector.y : vector.z))")
                        .frame(width: 120, alignment: .leading)
                }
            }
        }
    }
}

#Preview {
    Example024()
}
