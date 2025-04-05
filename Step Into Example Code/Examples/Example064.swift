//  Step Into Vision - Example Code
//
//  Title: Example064
//
//  Subtitle: Collisions & Physics: Hello Physics Joints Component
//
//  Description: We can create collections of entities that are linked together.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 4/4/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example064: View {
    var body: some View {
        RealityView { content in

            // Set up a top level entity for the simulation and the joints component
            let jointsSimulation = Entity()
            jointsSimulation.components.set([PhysicsSimulationComponent(), PhysicsJointsComponent()])
            content.add(jointsSimulation)

            // Create some shapes and add them to the simulation
            let boxA = makeSampleBox(color: .stepRed)
            boxA.position.x = -0.1
            jointsSimulation.addChild(boxA)

            let boxB = makeSampleBox(color: .stepGreen)
            boxB.position.x = 0.1
            jointsSimulation.addChild(boxB)

            // Create a basic hinge
            let hingeOrientation = simd_quatf(from: [1, 0, 0], to: [0, 0, 1])

            // Create a pin for each box
            let pin1 = boxA.pins.set(
                named: "boxA_to_boxB_hinge",
                position: .zero,
                orientation: hingeOrientation
            )
            let pin2 = boxB.pins.set(
                named: "boxB_to_boxA_hinge",
                position: boxB.position(relativeTo: boxA),
                orientation: hingeOrientation
            )

            // Join the pins together as a joint
            let simpleJoint1 = PhysicsRevoluteJoint(pin0: pin1, pin1: pin2)

            // Add the joint to the simulation
            Task {
                try simpleJoint1.addToSimulation()
            }

        }
        .modifier(DragGestureImproved())
    }

    func makeSampleBox(color: UIColor) -> ModelEntity {
        let collision = CollisionComponent(shapes: [.generateBox(size: .init(repeating: 0.1))])
        let inputTarget = InputTargetComponent()
        var physicsBody = PhysicsBodyComponent()
        physicsBody.isAffectedByGravity = false

        let box = ModelEntity(
            mesh: .generateBox(size: 0.1),
            materials: [SimpleMaterial(color: color, isMetallic: false)])
        box.components.set([collision, inputTarget, physicsBody])

        return box
    }
}

#Preview {
    Example064()
}
