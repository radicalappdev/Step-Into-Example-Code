//  Step Into Vision - Example Code
//
//  Title: Example028
//
//  Subtitle: Using Anchoring Component with Spatial Tracking Session
//
//  Description: We can add a Spatial Tracking Session if we need to use hand tracking features such as physics, collisions, and accessing transforms.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 1/1/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example028: View {
    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "HandAnchoringLabs", in: realityKitContentBundle) {
                content.add(scene)

                // 1. Set up a Spatial Tracking Session with hand tracking.
                // This will add ARKit features to our Anchor Entities, enabling collisions.
                let configuration = SpatialTrackingSession.Configuration(
                    tracking: [.hand])
                let session = SpatialTrackingSession()
                await session.run(configuration)

                // Left Hand: An entity in Reality Composer Pro with an Anchoring Component.
                if let subject = scene.findEntity(named: "CollisionSubject"), let leftHandIndex = scene.findEntity(named: "LeftHandIndex") {

                    var leftHandIndexAnchor = AnchoringComponent(
                        .hand(.left, location: .indexFingerTip)
                    )
                    // Disable the default physics simulation on the anchor to use collisions and physics
                    leftHandIndexAnchor.physicsSimulation = .none
                    leftHandIndex.components.set(leftHandIndexAnchor)

                    _ = content.subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
                        print("Collision subject \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                        collisionEvent.entityA.components[ParticleEmitterComponent.self]?.burst()
                    }

                }


                // Right Hand: Create an entity for each joint
                if let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {
                    // Create an array of all joints to iterate over.
                    let joints: [AnchoringComponent.Target.HandLocation.HandJoint] = [
                        .thumbTip,
                        .indexFingerTip,
                        .middleFingerTip,
                        .ringFingerTip,
                        .littleFingerTip
                    ]

                    for joint in joints {
                        let entity = rightHandSphere.clone(recursive: true)
                        var anchor = AnchoringComponent(
                            .hand(.right, location: .joint(for: joint)),
                            trackingMode: .continuous
                        )
                        // Disable the default physics simulation on the anchor to use collisions and physics
                        anchor.physicsSimulation = .none
                        entity.components.set(anchor)
                        content.add(entity)
                    }
                }

            }

        }
        .persistentSystemOverlays(.hidden)
        .upperLimbVisibility(.hidden)
    }
}

#Preview {
    Example028()
}
