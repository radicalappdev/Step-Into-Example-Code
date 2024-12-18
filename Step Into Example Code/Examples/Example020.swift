//  Step Into Vision - Example Code
//
//  Title: Example020
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

struct Example020: View {

    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "HandTrackingLabs", in: realityKitContentBundle) {
                content.add(scene)

                if let leftHandSphere = scene.findEntity(named: "StepSphereBlue") {
                    let leftHandAnchor = AnchorEntity(.hand(.left, location: .indexFingerTip), trackingMode: .continuous)
                    leftHandAnchor.addChild(leftHandSphere)
                    leftHandAnchor.position = leftHandSphere.position
                    content.add(leftHandAnchor)
                }

                if let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {
                    let rightHandAnchor = AnchorEntity(.hand(.right, location: .indexFingerTip), trackingMode: .continuous)
                    rightHandAnchor.addChild(rightHandSphere)
                    rightHandAnchor.position = rightHandSphere.position
                    content.add(rightHandAnchor)
                }

            }

        } update: { content in

        }
//        .persistentSystemOverlays(.hidden)
    }
}

#Preview {
    Example020()
}
