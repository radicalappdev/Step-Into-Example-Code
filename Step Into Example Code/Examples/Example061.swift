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

                wetFloorSign.addChild(front)
                front.setScale([200, 200, 200], relativeTo: wetFloorSign)
                front.transform.rotation = simd_quatf(Rotation3D(angle: Angle2D(degrees: 11), axis: RotationAxis3D(x: -1, y: 0, z: 0)))
                front.setPosition([0, 30, 6.7], relativeTo: wetFloorSign)

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
