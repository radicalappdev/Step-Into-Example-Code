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
                    let indexTipAnchor = AnchorEntity(.hand(.left, location: .indexFingerTip), trackingMode: .continuous)
                    indexTipAnchor.addChild(leftHandSphere)
                    content.add(indexTipAnchor)
                    
                    let palmAnchor = AnchorEntity(.hand(.left, location: .palm), trackingMode: .continuous)
                    palmAnchor.addChild(leftHandSphere.clone(recursive: true))
                    palmAnchor.position =  [0, 0.05, 0]
                    palmAnchor.scale = [3, 3, 3]
                    content.add(palmAnchor)
                    
                    let thumbTipAnchor = AnchorEntity(.hand(.left, location: .thumbTip), trackingMode: .continuous)
                    thumbTipAnchor.addChild(leftHandSphere.clone(recursive: true))
                    content.add(thumbTipAnchor)
                    
                    let wristAnchor = AnchorEntity(.hand(.left, location: .wrist), trackingMode: .continuous)
                    wristAnchor.addChild(leftHandSphere.clone(recursive: true))
                    wristAnchor.scale = [3, 3, 3]
                    content.add(wristAnchor)

                    let aboveHandAnchor = AnchorEntity(.hand(.left, location: .aboveHand), trackingMode: .continuous)
                    aboveHandAnchor.addChild(leftHandSphere.clone(recursive: true))
                    aboveHandAnchor.scale = [2, 2, 2]
                    content.add(aboveHandAnchor)
                }

                if let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {
                    let indexTipAnchor = AnchorEntity(.hand(.right, location: .indexFingerTip), trackingMode: .continuous)
                    indexTipAnchor.addChild(rightHandSphere)
                    indexTipAnchor.position = rightHandSphere.position
                    content.add(indexTipAnchor)
                    
                }

            }

        } update: { content in

        }
        .persistentSystemOverlays(.hidden)
    }
}

#Preview {
    Example020()
}
