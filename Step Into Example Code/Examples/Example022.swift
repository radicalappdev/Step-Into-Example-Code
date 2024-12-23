//  Step Into Vision - Example Code
//
//  Title: Example022
//
//  Subtitle: AnchorEntity Hand Tracking Mode
//
//  Description: The default tracking mode `.continuous` is very accurate but it can lag slightly behind. We can also use `.predicted`, which can feel much faster but it has a tendency to overshoot during very fast motions.
//
//  Type: Space
//
//  Created by Joseph Simpson on 12/23/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example022: View {
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
    Example022()
}
