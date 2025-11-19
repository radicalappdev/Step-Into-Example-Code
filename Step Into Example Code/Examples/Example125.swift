//  Step Into Vision - Example Code
//
//  Title: Example125
//
//  Subtitle: Timelines: Composing Timelines with Behavior Collisions
//
//  Description: We can use Behaviors in a parent scene to trigger Timelines in a child scene.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 11/19/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example125: View {

    @Environment(\.realityKitScene) var scene

    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "SharedCollisions", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)

            guard let plane = scene.findEntity(named: "ToyBiplane") else { return }
            let mc = ManipulationComponent()
            plane.components.set(mc)
        }
    }
}

#Preview {
    Example124()
}
