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

    @State var subject: Entity?
    @State var collisionBeganUnfiltered: EventSubscription?
    @State var collisionBeganSubject: EventSubscription?
    @State var collisionBeganSubjectColor: EventSubscription?
    @State var collisionEndedSubject: EventSubscription?

    var body: some View {
        RealityView { content in

            // Load the scene and position it in the volume
            guard let scene = try? await Entity(named: "CollisionEvents", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            subject = scene.findEntity(named: "Subject")

            // Example 1: This unfiltered event will fire twice. Once for each entity in the collision
            // Each will be entityA in their own version of the event, so we don't need the burst for entityB
            collisionBeganUnfiltered = content.subscribe(to: CollisionEvents.Began.self)  { collisionEvent in
                print("Collision unfiltered \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                collisionEvent.entityA.components[ParticleEmitterComponent.self]?.burst()

            }

        }
    }
}

#Preview {
    Example059()
}
