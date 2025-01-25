//  Step Into Vision - Example Code
//
//  Title: Example039
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example039: View {
    var body: some View {
        RealityView { content in

            // 1. Create a subject entity for our scene
            let subjectEntity = Entity()
            subjectEntity.name = "Subject"

            // Let's start with a material
            var material = PhysicallyBasedMaterial()
            material.baseColor.tint = .stepRed
            material.roughness = 0.5
            material.metallic = 0.0

            // Then we will create a shape for our model
            let shape = MeshResource.generateSphere(radius: 0.2)

            // We can create a model component using a mesh (shape) and one or more materials
            let model = ModelComponent(mesh: shape, materials: [material])

            // Add the model component to the entity
            subjectEntity.components.set(model)

            // Let's add some more components
            // visionOS will apply a hover effect component when we look at this entity
            subjectEntity.components.set(HoverEffectComponent())
            // InputTargetComponent will allow us to use system gestures such as tag and drag
            subjectEntity.components.set(InputTargetComponent())
            // Our entity must also have a CollisionComponent for gestures to work. There are a lot of other uses for collisions that we will cover later
            subjectEntity.components.set(CollisionComponent(shapes: [ShapeResource.generateSphere(radius: 0.2)]))

            // 2. ModelEntity is a convenient way to create an entity with a model, shapes, and material.
            material.baseColor.tint = .stepBlue // Hack: use the same material and change the color *
            let sphere = ModelEntity(
                mesh: .generateSphere(radius: 0.03),
                materials: [material])
            // Set the position of the sphere relative to the subject
            sphere.setPosition([-0.25, 0.2, 0.1], relativeTo: subjectEntity)

            // 3. Add our entities to the scene
            // Make sure to add our subject to the scene. Any root entities should be added to content like this.
            content.add(subjectEntity)

            // Add the sphere as a child to the subject.
            subjectEntity.addChild(sphere)
            // content.add(sphere) ❌ we don't need to add the sphere to the content since we are adding it as a child to the subject

            // * Note about the material hack above. Once a component is added to an entity, changes to it in code are not reflected on that entity. In the code above, we created a red material and added it to the subject. Then we changed the color to blue and it did not change the color of the subject. This pattern holds true for all components in RealityKit.
        }
    }
}

#Preview {
    Example039()
}
