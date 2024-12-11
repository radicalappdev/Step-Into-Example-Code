//  Step Into Vision - Example Code
//
//  Title: Example017
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 12/10/24.

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct Example017: View {
    let arSession = ARKitSession()
    let handTrackingProvider = HandTrackingProvider()
    let leftCollection = Entity()
    let rightCollection = Entity()
    
    let tipJoints: [HandSkeleton.JointName] = [
        .thumbTip, .indexFingerTip, .middleFingerTip, .ringFingerTip, .littleFingerTip
    ]
    
    var body: some View {
        RealityView { content in
            content.add(leftCollection)
            content.add(rightCollection)
            
            if let scene = try? await Entity(named: "HandTrackingLabs", in: realityKitContentBundle) {
                content.add(scene)
                
                if let leftHandSphere = scene.findEntity(named: "StepSphereBlue") {
                    // Create clones of the left hand sphere for each joint
                    for jointName in tipJoints {
                        let sphere = leftHandSphere.clone(recursive: true)
                        sphere.name = jointName.description
                        leftCollection.addChild(sphere)
                    }
                    leftHandSphere.isEnabled = false
                }
                
                if let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {
                    // Create clones of the right hand sphere for each joint
                    for jointName in tipJoints {
                        let sphere = rightHandSphere.clone(recursive: true)
                        sphere.name = jointName.description
                        rightCollection.addChild(sphere)
                    }
                    rightHandSphere.isEnabled = false
                }
            }
        }
        .persistentSystemOverlays(.hidden)

        .task { try! await arSession.run([handTrackingProvider]) }

        // Left Hand: Receive updates from the provider and process them over time
        .task {
            for await update in handTrackingProvider.anchorUpdates where update.anchor.chirality == .left {
                let handAnchor = update.anchor
                for jointName in tipJoints {
                    if let joint = handAnchor.handSkeleton?.joint(jointName),
                       let sphere = leftCollection.findEntity(named: jointName.description) {
                        let transform = handAnchor.originFromAnchorTransform 
                        let jointTransform = joint.anchorFromJointTransform
                        sphere.setTransformMatrix(transform * jointTransform, relativeTo: nil)
                    }
                }
            }
        }
        // Right Hand: Receive updates from the provider and process them over time
        .task {
            for await update in handTrackingProvider.anchorUpdates where update.anchor.chirality == .right {
                let handAnchor = update.anchor
                for jointName in tipJoints {
                    if let joint = handAnchor.handSkeleton?.joint(jointName),
                       let sphere = rightCollection.findEntity(named: jointName.description) {
                        let transform = handAnchor.originFromAnchorTransform 
                        let jointTransform = joint.anchorFromJointTransform
                        sphere.setTransformMatrix(transform * jointTransform, relativeTo: nil)
                    }
                }
            }
        }
        // Alternate version using latestAnchors instead of anchorUpdates
//        .task {
//            while true {
//                let anchors = handTrackingProvider.latestAnchors
//                if let handAnchor = anchors.rightHand {
//                    for jointName in tipJoints {
//                        if let joint = handAnchor.handSkeleton?.joint(jointName),
//                           let sphere = rightCollection.findEntity(named: jointName.description) {
//                            let transform = handAnchor.originFromAnchorTransform
//                            let jointTransform = joint.anchorFromJointTransform
//                            sphere.setTransformMatrix(transform * jointTransform, relativeTo: nil)
//                        }
//                    }
//                }
//                try? await Task.sleep(for: .milliseconds(8)) // ~120fps
//            }
//        }

    }
}

#Preview {
    Example017()
}



