//  Step Into Vision - Example Code
//
//  Title: Example058
//
//  Subtitle: Collisions & Physics: Collision Modes
//
//  Description: Exploring Triggers and Rigid Bodies in RealityKit
//
//  Type: Volume
//
//  Created by Joseph Simpson on 3/24/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example058: View {

    @State var lastCollision = "none"

    @State var collisionEventExample: EventSubscription?

    var body: some View {
        RealityView { content in

            // Load the scene and position it in the volume
            guard let scene = try? await Entity(named: "CollisionModes", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.setScale(.init(repeating: 0.8), relativeTo: nil)
            scene.position.y = -0.4

            // Let's add a collision event to the red sphere. We'll capture the name of the other entity we collide with
            if let subject = scene.findEntity(named: "ExampleInput") {
                collisionEventExample = content
                    .subscribe(to: CollisionEvents.Began.self, on: subject)  { event in
                        lastCollision = event.entityB.name
                    }
            }

        }
        .ornament(attachmentAnchor: .scene(.back), ornament: {
            VStack() {
                Text("Last Collision:")
                Text(lastCollision)
            }
            .font(.extraLargeTitle)
            .padding()
            .frame(width: 460, height: 200)
            .glassBackgroundEffect()
        })
        .modifier(DragGestureImproved())
    }
}

#Preview {
    Example058()
}
