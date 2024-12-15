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

    @State var leftHandTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.left, location: .indexFingerTip), trackingMode: .continuous)
        return handAnchor
    }()

    @State var rightHandTrackedEntity: Entity = {
        let handAnchor = AnchorEntity(.hand(.right, location: .indexFingerTip), trackingMode: .predicted)
        return handAnchor
    }()

    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "HandTrackingLabs", in: realityKitContentBundle) {
                content.add(scene)

                if let leftHandSphere = scene.findEntity(named: "StepSphereBlue") {
                    content.add(leftHandTrackedEntity)
                    leftHandTrackedEntity.position = leftHandSphere.position
                    leftHandTrackedEntity.addChild(leftHandSphere)
                }

                if let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {
                    content.add(rightHandTrackedEntity)
                    rightHandTrackedEntity.position = rightHandSphere.position
                    rightHandTrackedEntity.addChild(rightHandSphere)
                }

            }

        } update: { content in

        }
        .persistentSystemOverlays(.hidden)
    }
}

#Preview {
    Example019()
}
