//  Step Into Vision - Example Code
//
//  Title: Example082
//
//  Subtitle: RealityKit Basics: Using ViewAttachmentComponent
//
//  Description: visionOS 26 brings us a new way to create attachments right along side our entities.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 6/15/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example082: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "Caution", in: realityKitContentBundle) else { return }
            content.add(scene)

            // This lab can only run on version 26 and later
            guard #available(visionOS 26.0, *) else {
                print("WARNING: This lab requires VisionOS 26.0 or later.")
                return
            }

            // Example 01 - add an attachment as a child of an entity
            // Get the sign model from the scene
            if let wetFloorSign = scene.findEntity(named: "wet_floor_sign") {

                // Create an entity and use the new ViewAttachmentComponent
                let wetFloorAttachment = Entity()
                let attachment = ViewAttachmentComponent(rootView: WetFloorSignView())
                wetFloorAttachment.components.set(attachment)


                // Add the attachment entity as a child of the wet floor sign
                wetFloorSign.addChild(wetFloorAttachment)

                // Adjust the transform to position it just in front of the sign
                let transform = Transform(scale: .init(repeating: 200), rotation: simd_quatf(Rotation3D(angle: Angle2D(degrees: 11), axis: RotationAxis3D(x: -1, y: 0, z: 0))), translation: [0, 30, 6.7])
                wetFloorAttachment.transform = transform
            }

            // Example 02 - use an entity to position the attachment. Add the attachment to the scene content
            if let trafficCone = scene.findEntity(named: "traffic_cone_02") {

                // Create an entity and use the new ViewAttachmentComponent
                let traffiConeAttachment = Entity()
                let attachment = ViewAttachmentComponent(rootView: TrafficConeView())
                traffiConeAttachment.components.set(attachment)

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
            let warningSign = Entity()
            let attachment = ViewAttachmentComponent(rootView: WarningSignView())
            warningSign.components.set(attachment)
            warningSign.position = [1, 1.2, -2]
            content.add(warningSign)

        }
    }


}

fileprivate struct WetFloorSignView: View {
    var body: some View {
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
}

fileprivate struct TrafficConeView : View {
    var body: some View {
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
}

fileprivate struct WarningSignView: View {
    var body: some View {
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

#Preview {
    Example082()
}


