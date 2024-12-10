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
    let session = ARKitSession()
    let provider = HandTrackingProvider()
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
                }
                
                if let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {
                    // Create clones of the right hand sphere for each joint
                    for jointName in tipJoints {
                        let sphere = rightHandSphere.clone(recursive: true)
                        sphere.name = jointName.description
                        rightCollection.addChild(sphere)
                    }
                }
            }
        }
        .task { try! await session.run([provider]) }
        .task {
            for await update in provider.anchorUpdates {
                let handAnchor = update.anchor
                let collection = handAnchor.chirality == .left ? leftCollection : rightCollection
                
                for jointName in tipJoints {
                    guard let joint = handAnchor.handSkeleton?.joint(jointName),
                          let jointEntity = collection.findEntity(named: jointName.description) else {
                        continue
                    }
                    jointEntity.setTransformMatrix(handAnchor.originFromAnchorTransform * joint.anchorFromJointTransform,
                                                 relativeTo: nil)
                }
            }
        }
    }
}

#Preview {
    Example017()
}
