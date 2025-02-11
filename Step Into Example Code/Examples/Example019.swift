//  Step Into Vision - Example Code
//
//  Title: Example019
//
//  Subtitle: AnchorEntity Hands
//
//  Description: Using AnchorEntity in RealityKit without ARKit.
//
//  Type: Space
//
//  Created by Joseph Simpson on 12/15/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example019: View {
    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "HandTrackingLabs", in: realityKitContentBundle) {
                content.add(scene)

                if let leftHandSphere = scene.findEntity(named: "StepSphereBlue") {
                    let leftHandAnchor = AnchorEntity(.hand(.left, location: .indexFingerTip),
                                                      trackingMode: .continuous)
                    leftHandAnchor.addChild(leftHandSphere)
                    leftHandAnchor.position = leftHandSphere.position
                    content.add(leftHandAnchor)
                }

                if let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {
                    let rightHandAnchor = AnchorEntity(.hand(.right, location: .indexFingerTip),
                                                       trackingMode: .predicted)
                    rightHandAnchor.addChild(rightHandSphere)
                    rightHandAnchor.position = rightHandSphere.position
                    content.add(rightHandAnchor)
                }

            }
        }
        .persistentSystemOverlays(.hidden)
    }
}

#Preview {
    Example019()
}
