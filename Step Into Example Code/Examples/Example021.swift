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
                // This will add ARKit features to our Anchor Entities.
                let configuration = SpatialTrackingSession.Configuration(
                    tracking: [.hand])
                let session = SpatialTrackingSession()
                await session.run(configuration)

                if let subject = scene.findEntity(named: "StepSphereRed"), let leftHandSphere = scene.findEntity(named: "StepSphereBlue"), let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {
                    content.add(subject)

                    // 2. Anchor some spheres to our index fingers
                    // Set up left index finger sphere
                    leftHandSphere.name = "leftIndex"
                    let leftIndexAnchor = AnchorEntity(.hand(.left, location: .indexFingerTip), trackingMode: .continuous)

                    // 3. Disable the default physics simulation on the anchor
                    leftIndexAnchor.anchoring.physicsSimulation = .none
                    leftIndexAnchor.addChild(leftHandSphere)
                    content.add(leftIndexAnchor)


                    // Set up right index finger sphere
                    rightHandSphere.name = "rightIndex"
                    let rightIndexAnchor = AnchorEntity(.hand(.right, location: .indexFingerTip), trackingMode: .continuous)
                    rightIndexAnchor.anchoring.physicsSimulation = .none //
                    rightIndexAnchor.addChild(rightHandSphere.clone(recursive: true))
                    content.add(rightIndexAnchor)

                    _ = content.subscribe(to: CollisionEvents.Began.self)  { collisionEvent in
                        print("Collision unfiltered \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                        collisionEvent.entityA.components[ParticleEmitterComponent.self]?.burst()

                    }

                    _ = content
                        .subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
                            print("Collision Subject Color Change \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                            if(collisionEvent.entityB.name == "leftIndex") {
                                swapColorEntity(subject, color: .stepBlue)
                            } else if (collisionEvent.entityB.name == "rightIndex") {
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
