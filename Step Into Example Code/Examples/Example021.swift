//  Step Into Vision - Example Code
//
//  Title: Example021
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

struct Example021: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "HandTrackingLabs", in: realityKitContentBundle) {
                content.add(scene)

                if let subject = scene.findEntity(named: "StepSphereRed"), let leftHandSphere = scene.findEntity(named: "StepSphereBlue"), let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {


                    leftHandSphere.name = "leftIndex"
                    let indexTipAnchor = AnchorEntity(.hand(.left, location: .indexFingerTip), trackingMode: .continuous)
                    indexTipAnchor.addChild(leftHandSphere)
                    content.add(indexTipAnchor)

                    let thumbTipAnchor = AnchorEntity(.hand(.left, location: .thumbTip), trackingMode: .continuous)
                    let leftThumb = leftHandSphere.clone(recursive: true)
                    leftThumb.name = "leftThumb"
                    thumbTipAnchor.addChild(leftHandSphere.clone(recursive: true))
                    content.add(thumbTipAnchor)


                    rightHandSphere.name = "rightPalm"
                    let palmAnchor = AnchorEntity(.hand(.right, location: .palm), trackingMode: .continuous)
                    palmAnchor.addChild(rightHandSphere.clone(recursive: true))
                    palmAnchor.position =  [0, 0.05, 0]
                    palmAnchor.scale = [3, 3, 3]
                    content.add(palmAnchor)


                    // Add collision subscription
                    content.subscribe(to: CollisionEvents.Began.self) { event in
                        print("Collision detected!", event.entityA.name, event.entityB.name)
                        // Add your collision response here

                        // When we detect the leftIndex and leftThumb collision, scale the subect up by 10%
                        if (event.entityA.name == "leftIndex" && event.entityB.name == "leftThumb") ||
                            (event.entityA.name == "leftThumb" && event.entityB.name == "leftIndex") {
                            print("Collision detected! Index finger and thumb")
                            // Add specific response for index-thumb collision here
                        }
                        // When we detect a collision between leftIndex and rightPalm, reset the subject scale to 1.0
                        if (event.entityA.name == "leftIndex" && event.entityB.name == "rightPalm") ||
                            (event.entityA.name == "rightPalm" && event.entityB.name == "leftIndex") {
                            print("Collision detected! Index finger and right palm")
                            
                        }
                    }


                }


            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Example021()
}
