//  Step Into Vision - Example Code
//
//  Title: Example060
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/31/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example060: View {
    var body: some View {
        RealityView { content, attachments in

            // Load the scene and position it in the volume
            guard let scene = try? await Entity(named: "PhysicsBodyBasics", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.setScale(.init(repeating: 0.8), relativeTo: nil)
            scene.position.y = -0.4

            let collision = CollisionComponent(shapes: [.generateBox(size: .init(x: 0.1, y: 0.1, z: 0.1))])
            let input = InputTargetComponent()

            // kinematic example
            let redBox = ModelEntity(
                mesh: .generateBox(size: 0.1),
                materials: [SimpleMaterial(color: .stepRed, isMetallic: false)])
            redBox.setPosition([-0.15, 0.2, 0.2], relativeTo: scene)
            let redPhysics = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .kinematic)
            redBox.components.set([collision, input, redPhysics])
            content.add(redBox)

            // static example
            let greenBox = ModelEntity(
                mesh: .generateBox(size: 0.1),
                materials: [SimpleMaterial(color: .stepGreen, isMetallic: false)])
            greenBox.setPosition([-0, 0.1, 0.2], relativeTo: scene)
            let greenPhysics = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
            greenBox.components.set([collision, greenPhysics])
            content.add(greenBox)

            // dynamic example
            let blueBox = ModelEntity(
                mesh: .generateBox(size: 0.1),
                materials: [SimpleMaterial(color: .stepBlue, isMetallic: false)])
            blueBox.setPosition([0.15, 0.2, 0.2], relativeTo: scene)
            let bluePhysics = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .dynamic)
            blueBox.components.set([collision, input, bluePhysics])
            content.add(blueBox)



        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .modifier(DragGestureImproved())
    }
}

#Preview {
    Example060()
}
