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
            let leftHandMode = AnchoringComponent.TrackingMode.continuous
            let rightHandMode = AnchoringComponent.TrackingMode.predicted

            if let scene = try? await Entity(named: "HandTrackingLabs", in: realityKitContentBundle) {
                content.add(scene)

                if let leftHandSphere = scene.findEntity(named: "StepSphereBlue") {


                    let leftThumbTip = AnchorEntity(.hand(.left, location: .joint(for: .thumbTip)),
                                                    trackingMode: leftHandMode)
                    leftThumbTip.addChild(leftHandSphere.clone(recursive: true))
                    content.add(leftThumbTip)

                    let leftIndexFingerTip = AnchorEntity(.hand(.left, location: .joint(for: .indexFingerTip)),
                                                      trackingMode: leftHandMode)
                    leftIndexFingerTip.addChild(leftHandSphere.clone(recursive: true))
                    content.add(leftIndexFingerTip)

                    let leftMiddleFingerTip = AnchorEntity(.hand(.left, location: .joint(for: .middleFingerTip)),
                                                           trackingMode: leftHandMode)
                    leftMiddleFingerTip.addChild(leftHandSphere.clone(recursive: true))
                    content.add(leftMiddleFingerTip)

                    let leftRingFingerTip = AnchorEntity(.hand(.left, location: .joint(for: .ringFingerTip)),
                                                         trackingMode: leftHandMode)
                    leftRingFingerTip.addChild(leftHandSphere.clone(recursive: true))
                    content.add(leftRingFingerTip)

                    let leftLittleFingerTip = AnchorEntity(.hand(.left, location: .joint(for: .littleFingerTip)),
                                                          trackingMode: leftHandMode)
                    leftLittleFingerTip.addChild(leftHandSphere.clone(recursive: true))
                    content.add(leftLittleFingerTip)

                }

                if let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {

                    let rightThumbTip = AnchorEntity(.hand(.right, location: .joint(for: .thumbTip)),
                                                     trackingMode: rightHandMode)
                    rightThumbTip.addChild(rightHandSphere.clone(recursive: true))
                    content.add(rightThumbTip)

                    let rightIndexFingerTip = AnchorEntity(.hand(.right, location: .joint(for: .indexFingerTip)),
                                                           trackingMode: rightHandMode)
                    rightIndexFingerTip.addChild(rightHandSphere.clone(recursive: true))
                    content.add(rightIndexFingerTip)

                    let rightMiddleFingerTip = AnchorEntity(.hand(.right, location: .joint(for: .middleFingerTip)),
                                                            trackingMode: rightHandMode)
                    rightMiddleFingerTip.addChild(rightHandSphere.clone(recursive: true))
                    content.add(rightMiddleFingerTip)

                    let rightRingFingerTip = AnchorEntity(.hand(.right, location: .joint(for: .ringFingerTip)),
                                                          trackingMode: rightHandMode)
                    rightRingFingerTip.addChild(rightHandSphere.clone(recursive: true))
                    content.add(rightRingFingerTip)

                    let rightLittleFingerTip = AnchorEntity(.hand(.right, location: .joint(for: .littleFingerTip)),
                                                            trackingMode: rightHandMode)
                    rightLittleFingerTip.addChild(rightHandSphere.clone(recursive: true))
                    content.add(rightLittleFingerTip)
                }

            }
        }
        .persistentSystemOverlays(.hidden)
    }
}

#Preview {
    Example022()
}
