//  Step Into Vision - Example Code
//
//  Title: Example021
//
//  Subtitle: Hand Anchored Collision Triggers
//
//  Description: We can add a Spatial Tracking Session if we need to track collision triggers in our scene.
//
//  Type: Space
//
//  Created by Joseph Simpson on 12/21/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example021: View {

    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "HandTrackingLabs", in: realityKitContentBundle) {
                content.add(scene)

                // 1. Set up a Spatial Tracking Session with hand tracking.
                // This will add ARKit features to our Anchor Entities, enabling collisions.
                let configuration = SpatialTrackingSession.Configuration(
                    tracking: [.hand])
                let session = SpatialTrackingSession()
                await session.run(configuration)

                if let subject = scene.findEntity(named: "StepSphereRed"), let stepSphereBlue = scene.findEntity(named: "StepSphereBlue"), let stepSphereGreen = scene.findEntity(named: "StepSphereGreen") {
                    content.add(subject)

                    // 2. Create an anchor for the left index finger
                    let leftIndexAnchor = AnchorEntity(.hand(.left, location: .indexFingerTip), trackingMode: .continuous)

                    // 3. Disable the default physics simulation on the anchor
                    leftIndexAnchor.anchoring.physicsSimulation = .none

                    // 4. Add the sphere to the anchor and add the anchor to the scene graph
                    leftIndexAnchor.addChild(stepSphereBlue)
                    content.add(leftIndexAnchor)

                    // Repeat the same steps for the right index finger
                    let rightIndexAnchor = AnchorEntity(.hand(.right, location: .indexFingerTip), trackingMode: .continuous)
                    rightIndexAnchor.anchoring.physicsSimulation = .none //
                    rightIndexAnchor.addChild(stepSphereGreen)
                    content.add(rightIndexAnchor)

                    // Example 1: Any entity can collide with any entity. Fire a particle burst
                    // Allow collision between the hand anchors
                    // Allow collision between a hand anchor and the subject
                    _ = content.subscribe(to: CollisionEvents.Began.self)  { collisionEvent in
                        print("Collision unfiltered \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                        collisionEvent.entityA.components[ParticleEmitterComponent.self]?.burst()
                    }

                    // Example 2: Only track collisions on the subject. Swap the color of the material based on left or right hand.
                    _ = content
                        .subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
                            print("Collision Subject Color Change \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                            if(collisionEvent.entityB.name == "StepSphereBlue") {
                                swapColorEntity(subject, color: .stepBlue)
                            } else if (collisionEvent.entityB.name == "StepSphereGreen") {
                                swapColorEntity(subject, color: .stepGreen)
                            }
                        }

                }
            }
        }
    }

    func swapColorEntity(_ entity: Entity, color: UIColor) {
        if var mat = entity.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial {
            mat.baseColor = .init(tint: color)
            entity.components[ModelComponent.self]?.materials[0] = mat
        }
    }
}

#Preview {
    Example021()
}
