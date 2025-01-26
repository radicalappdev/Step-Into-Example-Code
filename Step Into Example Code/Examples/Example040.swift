//  Step Into Vision - Example Code
//
//  Title: Example040
//
//  Subtitle: RealityKit Basics: RealityView
//
//  Description: Exploring a SwiftUI view that contains RealityView content.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 1/26/25.

import SwiftUI
import RealityKit

struct Example040: View {

    @State var isTransparent = false

    var body: some View {
        RealityView { content, attachments in

            // wait for 2 seconds so we can see the placeholder view
            try? await Task.sleep(for: .seconds(2))

            let subjectEntity = Entity()
            subjectEntity.name = "Subject"

            var material = PhysicallyBasedMaterial()
            material.baseColor.tint = .stepRed
            material.roughness = 0.5
            material.metallic = 0.0

            let shape = MeshResource.generateSphere(radius: 0.2)
            let model = ModelComponent(mesh: shape, materials: [material])
            subjectEntity.components.set(model)
            subjectEntity.components.set(HoverEffectComponent())
            subjectEntity.components.set(InputTargetComponent())
            subjectEntity.components.set(OpacityComponent(opacity: 1.0))
            subjectEntity.components.set(CollisionComponent(shapes: [ShapeResource.generateSphere(radius: 0.2)]))
            content.add(subjectEntity)

            material.baseColor.tint = .stepBlue
            let sphere = ModelEntity(
                mesh: .generateSphere(radius: 0.03),
                materials: [material])
            sphere.setPosition([-0.25, 0.2, 0.1], relativeTo: subjectEntity)
            subjectEntity.addChild(sphere)

            // Get the subject panel from the attachments
            // Once loaded we can add attachments to the content or add them as children to other entities
            if let subjectPanel = attachments.entity(for: "subjectPanel") {
                subjectPanel.setPosition([0, 0.3, 0], relativeTo: subjectEntity)
                content.add(subjectPanel)
            }

        } update: { content, attachments in
            // This update closure will fire anytime isTransparent is modififed.
            // We'll query the scene graph in content for the entity we want to update
            if let subject = content.entities.first(where: { $0.name == "Subject" }) {
                // We can set a new instance of the OpacityComponent on the entity. This will replace any existing OpacityComponent. We don't need to remove the old one first.
                subject.components.set(OpacityComponent(opacity: isTransparent ? 0.5 : 1.0 ))
            }

        } placeholder: {
            // A SwiftUI view that will display while the RealityView is loading
            VStack {
                Text("Loading")
                    .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                ProgressView()
            }
            .font(.largeTitle)
            .padding()
            .glassBackgroundEffect()

        } attachments: {
            // A collection of attachments that contain SwiftUI Views. RealityKit will convert each of these into entities that we can place in our scene using the make and update closures.
            Attachment(id: "subjectPanel", {
                VStack {
                    HStack {
                        Image(systemName: "circle.fill")
                        Text("Subject")
                    }
                    .font(.largeTitle)
                    Toggle(isOn: $isTransparent, label: {
                        Text("Opacity")
                    })
                    .toggleStyle(.button)
                }
                .padding()
                .glassBackgroundEffect()
            })

        }

    }
}

#Preview {
    Example040()
}
