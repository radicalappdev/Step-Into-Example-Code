//  Step Into Vision - Example Code
//
//  Title: Example059
//
//  Subtitle: Collisions & Physics: Collision Events
//
//  Description: A few examples of how to respond to collisions in RealityKit.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 3/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example059: View {

    @State var collisionBeganUnfiltered: EventSubscription?
    @State var collisionSubjectBegan: EventSubscription?
    @State var collisionSubjectUpdated: EventSubscription?
    @State var collisionSubjectEnded: EventSubscription?

    var body: some View {
        RealityView { content in

            // Load the scene and position it in the volume
            guard let scene = try? await Entity(named: "CollisionEvents", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            guard let subject = scene.findEntity(named: "Subject"),
                  let stepSphereRed = scene.findEntity(named: "StepSphereRed"),
                  let stepSphereGreen = scene.findEntity(named: "StepSphereGreen"),
                  let stepSphereBlue = scene.findEntity(named: "StepSphereBlue")
            else { return }


            // Example 1: This unfiltered event will fire twice. Once for each entity in the collision
            // Each will be entityA in their own version of the event, so we don't need the burst for entityB
            collisionBeganUnfiltered = content.subscribe(to: CollisionEvents.Began.self)  { collisionEvent in
                print("Collision unfiltered \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                collisionEvent.entityA.components[ParticleEmitterComponent.self]?.burst()
            }

            // Example 2: Only trigger collisions on the subject.
            // Subject will always be entityA in this event
            collisionSubjectBegan = content
                .subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
                    print("Collision Subject Example \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")

                    // When we reach the Base, we'll fire the particle burst on the other three spheres
                    if(collisionEvent.entityB.name == "Base") {
                        stepSphereRed.components[ParticleEmitterComponent.self]?.burst()
                        stepSphereGreen.components[ParticleEmitterComponent.self]?.burst()
                        stepSphereBlue.components[ParticleEmitterComponent.self]?.burst()
                    }
                }

            // Example 3: We can use Updated to fire an event for each frame that the subject is in contact with the Base
            collisionSubjectUpdated = content
                .subscribe(to: CollisionEvents.Updated.self, on: subject)  { collisionEvent in
                    print("Collision Subject Grow \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                    if(collisionEvent.entityB.name == "StepSphereRed") {
                        collisionEvent.entityB.scale *= 1.002
                    } else if(collisionEvent.entityB.name == "StepSphereGreen") {
                        collisionEvent.entityB.scale *= 0.998
                    }
                }

            // Example 4: We can reset the scale on ended. We'll also change the subject color
            collisionSubjectEnded = content
                .subscribe(to: CollisionEvents.Ended.self, on: subject)  { collisionEvent in
                    print("Collision Subject Reset \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")

                    if(collisionEvent.entityB.name == "StepSphereRed") {
                        swapColorEntity(subject, color: .stepRed)
                    } else if (collisionEvent.entityB.name == "StepSphereGreen") {
                        swapColorEntity(subject, color: .stepGreen)
                    } else if (collisionEvent.entityB.name == "StepSphereBlue") {
                        swapColorEntity(subject, color: .stepBlue)
                    } else {
                        return
                    }
                    collisionEvent.entityB.scale = .init(repeating: 0.8)
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
    Example059()
}





