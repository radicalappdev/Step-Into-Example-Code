//  Step Into Vision - Example Code
//
//  Title: Example066
//
//  Subtitle: Collisions & Physics: Physics Material
//
//  Description: We can adjust friction and restitution.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 4/8/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example066: View {

    @State var subject = Entity()

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "PhysicsMaterialResource", in: realityKitContentBundle) else { return }
            guard let blueSpere = scene.findEntity(named: "Blue") else { return }
            subject = blueSpere

            scene.position.y = -0.4
            scene.addChild(subject)
            content.add(scene)
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    Text("Restitution:")
                    Button(action: {
                        updatePhysics(restitution: 0.0)
                    }, label: {
                        Text("0.0")
                    })
                    Button(action: {
                        updatePhysics(restitution: 0.3)
                    }, label: {
                        Text("0.3")
                    })
                    Button(action: {
                        updatePhysics(restitution: 0.7)
                    }, label: {
                        Text("0.7")
                    })
                }
            })
        }
    }
    
    func updatePhysics(restitution: Float) {
        // Create a new instance of PhysicsBodyComponent using the restitution value
        let physicsBody = PhysicsBodyComponent(
            massProperties: .default,
            material: .generate(staticFriction: 0.0, dynamicFriction: 0.0, restitution: restitution),
            mode: .dynamic
        )
        // We can assing an new instance of PhysicsMotionComponent to reset any existing velocity on the subject
        let physicsMotion = PhysicsMotionComponent()
        subject.components.set([physicsBody, physicsMotion])
        subject.position.y = 0.8
    }

}

#Preview {
    Example066()
}



