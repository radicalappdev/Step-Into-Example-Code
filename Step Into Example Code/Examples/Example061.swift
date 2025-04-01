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

            if let wetFloorSign = scene.findEntity(named: "wet_floor_sign"), let front = attachments.entity(for: "wet_floor_front") {
                // The wet_floor_sign asset was converted from another format. It was scaled to 0.01 on all axes to fit in this scene.
                // We'll have to scale the attachment to compensate for the scale of the entity

                // Ad the front attachment as a child of the wet floor sign
                wetFloorSign.addChild(front)

                // Adjust the transform to position it just in front of the sign
                let frontTransform = Transform(scale: .init(repeating: 200), rotation: simd_quatf(Rotation3D(angle: Angle2D(degrees: 11), axis: RotationAxis3D(x: -1, y: 0, z: 0))), translation: [0, 30, 6.7])
                front.transform = frontTransform

            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "wet_floor_front") {
                VStack(spacing: 24) {
                    Text("CAUTION")
                        .font(.largeTitle)
                    Image(systemName: "triangle")
                        .font(.extraLargeTitle2)
                    Text("Wet Floor")
                        .font(.title)
                }
                .padding()
                .foregroundStyle(.black)
            }
        }
        .modifier(DragGestureImproved())
    }
}

#Preview {
    Example061()
}
