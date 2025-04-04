//  Step Into Vision - Example Code
//
//  Title: Example064
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/4/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example064: View {
    var body: some View {
        RealityView { content in

            let jointsSimulation = Entity()
            jointsSimulation.components.set([PhysicsSimulationComponent(), PhysicsJointsComponent()])
            content.add(jointsSimulation)

            let collision = CollisionComponent(shapes: [.generateBox(size: .init(repeating: 0.1))])
            var physicsBody = PhysicsBodyComponent()
            physicsBody.isAffectedByGravity = false
            let inputTarget = InputTargetComponent()




            let boxA = ModelEntity(
                mesh: .generateBox(size: 0.1),
                materials: [SimpleMaterial(color: .stepRed, isMetallic: false)])
            boxA.setPosition([-0.15, -0.2, 0], relativeTo: nil)
            boxA.components
                .set([collision, inputTarget, physicsBody])
            jointsSimulation.addChild(boxA)

            let boxB = ModelEntity(
                mesh: .generateBox(size: 0.1),
                materials: [SimpleMaterial(color: .stepGreen, isMetallic: false)])
            boxB.setPosition([0, -0.2, 0], relativeTo: nil)
            boxB.components
                .set([collision, inputTarget, physicsBody])
            jointsSimulation.addChild(boxB)

            let boxC = ModelEntity(
                mesh: .generateBox(size: 0.1),
                materials: [SimpleMaterial(color: .stepBlue, isMetallic: false)])
            boxC.setPosition([0.15, -0.2, 0], relativeTo: nil)
            boxC.components
                .set([collision, inputTarget, physicsBody])
            jointsSimulation.addChild(boxC)


            let hingeOrientation = simd_quatf(from: [1, 0, 0], to: [0, 0, 1])

            // Create a pin for each ball
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

            // Join the pins together
            let simpleJoint = PhysicsRevoluteJoint(pin0: pin1, pin1: pin2)

            // Add the join to the simulation
            Task {
                try simpleJoint.addToSimulation()
            }

        }
        .modifier(DragGestureImproved())
    }
}

#Preview {
    Example064()
}
