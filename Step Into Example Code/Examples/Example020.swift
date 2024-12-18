//  Step Into Vision - Example Code
//
//  Title: Example020
//
//  Subtitle: AnchorEntity Locations and Joints for Hands
//
//  Description: Unpacking all the locations and joints that we can track with AnchorEntity in RealityKit.
//
//  Type: Space
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

                // Left Hand: Create and customize entities for each primary location
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

                // Right Hand: Create an entity for each joint
                if let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {
                    // In ARKit, joints are availble as a ENUM HandSkeleton.JointName.allCases
                    // But in RealityKit we are not so lucky. Create an array of all joints to iterate over.
                    let joints: [AnchoringComponent.Target.HandLocation.HandJoint] = [
                        .forearmArm,
                        .forearmWrist,
                        .indexFingerIntermediateBase,
                        .indexFingerIntermediateTip,
                        .indexFingerKnuckle,
                        .indexFingerMetacarpal,
                        .indexFingerTip,
                        .littleFingerIntermediateBase,
                        .littleFingerIntermediateTip,
                        .littleFingerKnuckle,
                        .littleFingerMetacarpal,
                        .littleFingerTip,
                        .middleFingerIntermediateBase,
                        .middleFingerIntermediateTip,
                        .middleFingerKnuckle,
                        .middleFingerMetacarpal,
                        .middleFingerTip,
                        .ringFingerIntermediateBase,
                        .ringFingerIntermediateTip,
                        .ringFingerKnuckle,
                        .ringFingerMetacarpal,
                        .ringFingerTip,
                        .thumbIntermediateBase,
                        .thumbIntermediateTip,
                        .thumbKnuckle,
                        .thumbTip,
                        .wrist
                    ]
                    
                    for joint in joints {
                        let anchor = AnchorEntity(
                            .hand(.right, location: .joint(for: joint)),
                            trackingMode: .continuous
                        )
                        anchor.addChild(rightHandSphere.clone(recursive: true))
                        anchor.position = rightHandSphere.position
                        content.add(anchor)
                    }
                }

            }
        }
        .persistentSystemOverlays(.hidden)
    }
}

#Preview {
    Example020()
}
