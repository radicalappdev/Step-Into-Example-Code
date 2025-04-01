//  Step Into Vision - Example Code
//
//  Title: Example061
//
//  Subtitle: Spatial SwiftUI: Placing attachments in a scene
//
//  Description: Three options for how to place place attachments in a scene.
//
//  Type: Space
//
//  Created by Joseph Simpson on 4/1/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example061: View {
    var body: some View {
        RealityView { content, attachments in
            guard let scene = try? await Entity(named: "Caution", in: realityKitContentBundle) else { return }
            content.add(scene)

            // Example 01 - add an attachment as a child of an entity
            if let wetFloorSign = scene.findEntity(named: "wet_floor_sign"),
                let wetFloorAttachment = attachments.entity(for: "wet_floor_attachment") {
                // The wet_floor_sign asset was converted from another format. It was scaled to 0.01 on all axes to fit in this scene.
                // We'll have to scale the attachment to compensate for the scale of the entity

                // Add the wetFloorAttachment attachment as a child of the wet floor sign
                wetFloorSign.addChild(wetFloorAttachment)

                // Adjust the transform to position it just in front of the sign
                let transform = Transform(scale: .init(repeating: 200), rotation: simd_quatf(Rotation3D(angle: Angle2D(degrees: 11), axis: RotationAxis3D(x: -1, y: 0, z: 0))), translation: [0, 30, 6.7])
                wetFloorAttachment.transform = transform
            }

            // Example 02 - use an entity to position the attachment. Add the attachment to the scene content
            if let trafficCone = scene.findEntity(named: "traffic_cone_02"),
               let traffiConeAttachment = attachments.entity(for: "traffic_cone_attachment") {

                // For this example, we'll add the attachment directly to the scenc content
                content.add(traffiConeAttachment)

                // Then we'll use the data from the traffic cone entity to determine the transform for the attachment
                let transform = Transform(
                    scale: .init(repeating: 1.0),
                    rotation: simd_quatf(
                        Rotation3D(angle: Angle2D(degrees: -24), axis: RotationAxis3D(x: 0, y: 1, z: 0))
                    ),
                    translation: trafficCone.position + [0, 0.8 , 0]
                )

                traffiConeAttachment.transform = transform
            }

            // Example 03 - Add the attachment as a standalone entity
            if let warningSign = attachments.entity(for: "warning_sign") {
                warningSign.position = [1, 1.2, -2]
                content.add(warningSign)
            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "wet_floor_attachment") {
                VStack(spacing: 24) {
                    Text("CAUTION")
                        .font(.largeTitle)
                    ZStack {
                        Image(systemName: "triangle")
                            .font(.system(size: 96, weight: .semibold))
                        Image(systemName: "figure.fall")
                            .font(.system(size: 42, weight: .heavy))
                            .offset(y:12)
                    }
                    Text("No Floor")
                        .font(.largeTitle)
                }
                .foregroundStyle(.black)
                .textCase(.uppercase)
                .padding()
            }

            Attachment(id: "traffic_cone_attachment") {
                VStack(spacing: 24) {
                    Text("Watch Out")
                        .font(.extraLargeTitle)
                    ZStack {
                        Image(systemName: "triangle")
                            .font(.system(size: 96, weight: .semibold))
                        Image(systemName: "eyes")
                            .font(.system(size: 36, weight: .heavy))
                            .offset(y:12)
                    }
                    Text("for traffic cones")
                        .font(.extraLargeTitle)
                }
                .padding(24)
                .foregroundStyle(.white)
                .textCase(.uppercase)
                .background(.trafficOrange)
                .clipShape(.rect(cornerRadius: 24.0))
            }

            Attachment(id: "warning_sign") {
                VStack(spacing: 24) {
                    Text("This scene contains gratuitous warnings")
                        .font(.system(size: 96, weight: .bold))
                        .textCase(.uppercase)
                        .multilineTextAlignment(.center)
                }
                .padding(24)
                .foregroundStyle(.white)
                .background(.black)
                .clipShape(.rect(cornerRadius: 24.0))
            }
        }
        .modifier(DragGestureImproved())
    }
}

#Preview {
    Example061()
}
