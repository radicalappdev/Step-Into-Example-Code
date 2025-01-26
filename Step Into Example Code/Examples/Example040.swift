//
//  Example040.swift
//  Step Into Example Code
//
//  Created by Joseph Simpson on 1/26/25.
//

import SwiftUI
import RealityKit

struct Example040: View {

    @State var istTransparent = false

    var body: some View {
        RealityView { content, attachments in

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

            

        } update: { content, attachments in

            if let subject = content.entities.first(where: { $0.name == "Subject" }) {

                subject.components.set(OpacityComponent(opacity: istTransparent ? 0.5 : 1.0 ))


            }

        } placeholder: {

            ProgressView()

        } attachments: {

        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                Toggle(isOn: $istTransparent, label: {
                    Text("Opacity")
                })
                .toggleStyle(.button)
            })

        }
    }
}

#Preview {
    Example040()
}
