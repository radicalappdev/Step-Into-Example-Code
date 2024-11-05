//  Step Into Vision - Example Code
//
//  Title: Example005
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/28/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example005: View {

    @State var subject: Entity?
    @State var indicator: Entity?

    var body: some View {
        RealityView { content in
            // Load the scene from the bundle
            if let scene = try? await Entity(named: "SpatialTapLab", in: realityKitContentBundle) {
                content.add(scene)

                // We will place this indicator at the location of our taps
                let indicatorModel = ModelEntity(
                    mesh: .generateSphere(radius: 0.025),
                    materials: [SimpleMaterial(color: .black, isMetallic: false)])

                // Get the cube from the scene. This has Input and Collision components
                if let cube = scene.findEntity(named: "Cube") {
                    cube.components.set(HoverEffectComponent())
                    cube.addChild(indicatorModel)
                    subject = cube
                    indicator = indicatorModel
                }

            }

        }
        .gesture(spatialTapExample)
    }

    var spatialTapExample: some Gesture {
        SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded { value in

                if let subject = subject, let indicator = indicator {
                    // Convert the location3D value to the coordinate space of the subject
                    // Place the indicator on the surface of the subject
                    let tappedPosition = value.convert(value.location3D, from: .local, to: subject)
                    indicator.position = tappedPosition
                }

            }
    }
}

#Preview {
    Example005()
}
