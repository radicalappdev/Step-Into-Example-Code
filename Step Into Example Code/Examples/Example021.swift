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
                // Add physics simulation to the scene level
                scene.components.set(PhysicsSimulationComponent())
                content.add(scene)

                if let subject = scene.findEntity(named: "StepSphereRed"), let leftHandSphere = scene.findEntity(named: "StepSphereBlue"), let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {

                    // Create a root entity for all hand tracking
                    let handTrackingRoot = Entity()
                    handTrackingRoot.components.set(PhysicsSimulationComponent())
                    content.add(handTrackingRoot)

                    // Set up index finger sphere
                    leftHandSphere.name = "leftIndex"
                    let indexTipAnchor = AnchorEntity(.hand(.left, location: .indexFingerTip), trackingMode: .continuous)
                    indexTipAnchor.addChild(leftHandSphere)
                    handTrackingRoot.addChild(indexTipAnchor)

                    // Set up thumb sphere
                    let thumbTipAnchor = AnchorEntity(.hand(.left, location: .thumbTip), trackingMode: .continuous)
                    let leftThumb = leftHandSphere.clone(recursive: true)
                    leftThumb.name = "leftThumb"
                    thumbTipAnchor.addChild(leftThumb)
                    handTrackingRoot.addChild(thumbTipAnchor)

                    // Set up palm sphere
                    rightHandSphere.name = "rightPalm"
                    let palmAnchor = AnchorEntity(.hand(.right, location: .palm), trackingMode: .continuous)
                    palmAnchor.addChild(rightHandSphere.clone(recursive: true))
                    palmAnchor.position = [0, 0.05, 0]
                    palmAnchor.scale = [3, 3, 3]
                    handTrackingRoot.addChild(palmAnchor)

                    // Keep collision subscription on content
                    content.subscribe(to: CollisionEvents.Began.self) { event in
                        print("Collision detected!", event.entityA.name, event.entityB.name)
                        // Add your collision response here

                        // When we detect the leftIndex and leftThumb collision, scale the subect up by 10%
                        if (event.entityA.name == "leftIndex" && event.entityB.name == "leftThumb") ||
                            (event.entityA.name == "leftThumb" && event.entityB.name == "leftIndex") {
                            print("Collision detected! Index finger and thumb")
                            subject.setScale(subject.scale * 1.1, relativeTo: subject.parent)
                        }
                        // When we detect a collision between leftIndex and rightPalm, reset the subject scale to 1.0
                        if (event.entityA.name == "leftIndex" && event.entityB.name == "rightPalm") ||
                            (event.entityA.name == "rightPalm" && event.entityB.name == "leftIndex") {
                            print("Collision detected! Index finger and right palm")
                            subject.setScale(SIMD3<Float>(1.0, 1.0, 1.0), relativeTo: nil)
                        }
                    }

//                    let configuration = SpatialTrackingSession.Configuration(
//                        tracking: [.hand])
//                    let session = SpatialTrackingSession()
//                    await session.run(configuration)

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
