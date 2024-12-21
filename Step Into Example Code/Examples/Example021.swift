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

    @State var trackedSession: SpatialTrackingSession?
    @State var collisionBeganUnfiltered: EventSubscription?
    @State var collisionBeganSubject: EventSubscription?

    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "HandTrackingLabs", in: realityKitContentBundle) {
                // Add physics simulation to the scene level
                scene.components.set(PhysicsSimulationComponent())
                content.add(scene)

                let configuration = SpatialTrackingSession.Configuration(
                    tracking: [.hand])
                let session = SpatialTrackingSession()
                await session.run(configuration)
                trackedSession = session


                if let subject = scene.findEntity(named: "StepSphereRed"), let leftHandSphere = scene.findEntity(named: "StepSphereBlue"), let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {

                    // Set up left index finger sphere
                    leftHandSphere.name = "leftIndex"
                    let leftIndexAnchor = AnchorEntity(.hand(.left, location: .indexFingerTip), trackingMode: .continuous)
                    leftIndexAnchor.addChild(leftHandSphere)
                    content.add(leftIndexAnchor)


                    // Set up right index finger sphere
                    rightHandSphere.name = "rightIndex"
                    let rightIndexAnchor = AnchorEntity(.hand(.right, location: .indexFingerTip), trackingMode: .continuous)
                    rightIndexAnchor.addChild(rightHandSphere.clone(recursive: true))
                    content.add(rightIndexAnchor)

                    collisionBeganUnfiltered = content.subscribe(to: CollisionEvents.Began.self)  { collisionEvent in
                        print("Collision unfiltered \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                        collisionEvent.entityA.components[ParticleEmitterComponent.self]?.burst()

                    }

//                    collisionBeganSubject = content
//                        .subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
//                            print("Collision Subject Bounce \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
//                            // Do something to show the trigger
//                            subject.components[ParticleEmitterComponent.self]?.burst()
//                        }

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
