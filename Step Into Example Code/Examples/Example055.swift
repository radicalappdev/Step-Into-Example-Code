//  Step Into Vision - Example Code
//
//  Title: Example055
//
//  Subtitle: Collisions & Physics: Getting started with Collision Component
//
//  Description: This component is vital to user input, collision detection, and physics.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 3/10/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example055: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "CollisionLabs", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            // Generate a sphere collision shape
            if let sphereExample = scene.findEntity(named: "SphereExample") {
                let collision = CollisionComponent(shapes: [.generateSphere(radius: 0.1)])
                sphereExample.components.set(collision)
            }

            // Generate a capsule collision shape
            if let capsuleExample = scene.findEntity(named: "CapsuleExample") {
                let collision = CollisionComponent(shapes: [.generateCapsule(height: 0.4, radius: 0.1)])
                capsuleExample.components.set(collision)
            }

            // Generate a cube collision shape
            if let cubeExample = scene.findEntity(named: "CubeExample") {
                let collision = CollisionComponent(shapes: [.generateBox(size: .init(x: 0.2, y: 0.2, z: 0.2))])
                cubeExample.components.set(collision)
            }

        }
    }
}

#Preview {
    Example055()
}
