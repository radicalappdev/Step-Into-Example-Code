//  Step Into Vision - Example Code
//
//  Title: Example126
//
//  Subtitle: Timelines: Select multiple Entities with Collision Behaviors
//
//  Description: The `OnCollision` Behavior can fire a Timeline when colliding with more than one Entity.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 11/20/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example126: View {
    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "SharedGroupActions", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)

            guard let plane = scene.findEntity(named: "ToyBiplane") else { return }
            guard let car = scene.findEntity(named: "ToyCar") else { return }
            let mc = ManipulationComponent()
            plane.components.set(mc)
            car.components.set(mc)
        }
    }
}

#Preview {
    Example126()
}
