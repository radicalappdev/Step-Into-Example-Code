//  Step Into Vision - Example Code
//
//  Title: Example038
//
//  Subtitle: RealityKit Basics: Create Shapes
//
//  Description: Creating primitive shapes in code.
//
//  Type: Space
//
//  Created by Joseph Simpson on 1/24/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example038: View {
    var body: some View {
        RealityView { content, attachments in

            // Create an empty entity we can use to group our shapes
            let group = Entity()
            content.add(group)
            // We can move this group down in the volume and scale it to 50%.
            group.position = [0, -0.25, 0]
            group.scale = [0.5, 0.5, 0.5]

            // Create shapes

            // ModelEntity is a convenient way to create an entity with a model, shapes, and material.
            let sphere = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .stepRed, isMetallic: false)])
            // Set the position of the sphere relative to the group
            sphere.setPosition([-0.5, 0, 0], relativeTo: group)
            // Add the sphere as a child to the group
            group.addChild(sphere)

            let box = ModelEntity(
                mesh: .generateBox(size: 0.2),
                materials: [SimpleMaterial(color: .stepGreen, isMetallic: false)])
            box.setPosition([0, -0.1, 0], relativeTo: group)
            group.addChild(box)

            let cylinder = ModelEntity(
                mesh: .generateCylinder(height: 0.2, radius: 0.1),
                materials: [SimpleMaterial(color: .stepBlue, isMetallic: false)])
            cylinder.setPosition([0.5, 0, 0], relativeTo: group)
            group.addChild(cylinder)

            let cone = ModelEntity(
                mesh: .generateCone(height: 0.2, radius: 0.075),
                materials: [SimpleMaterial(color: .stepBlue, isMetallic: false)])
            cone.setPosition([0.4, 0.5, 0], relativeTo: group)
            group.addChild(cone)

            let plane = ModelEntity(
                mesh: .generatePlane(width: 0.2, height: 0.2),
                materials: [SimpleMaterial(color: .stepGreen, isMetallic: false)])
            plane.setPosition([-0.4, 0.5, 0], relativeTo: group)
            group.addChild(plane)

        } update: { content, attachments in
            // More on update later
        } attachments: {
            // More on attachments later
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Example038()
}
