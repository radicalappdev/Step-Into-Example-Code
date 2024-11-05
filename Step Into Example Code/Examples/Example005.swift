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

    @State var rocket: Entity?
    @State var indicator: Entity?

    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bindle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                let indicatorModel = ModelEntity(
                    mesh: .generateSphere(radius: 0.01),
                    materials: [SimpleMaterial(color: .black, isMetallic: false)])

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4

                // Get the rocket and save it for later
                if let toyRocket = scene.findEntity(named: "ToyRocket") {
                    toyRocket.scale = .init(repeating: 2.5)
                    toyRocket.components.set(HoverEffectComponent())
                    toyRocket.addChild(indicatorModel)
                    rocket = toyRocket
                    indicator = indicatorModel


                }


                // Remove the items we don't need
                if let toyCar = scene.findEntity(named: "ToyCar"), let toyBiplane = scene.findEntity(named: "ToyBiplane") {
                    toyCar.removeFromParent()
                    toyBiplane.removeFromParent()
                }

            }

        }
        .gesture(spatialTapExample)
    }

    var spatialTapExample: some Gesture {
        SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                print("spatial tapped: \(value.location3D)")


                if let rocket = rocket, let indicator = indicator {
                    let tappedPosition = value.convert(value.location3D, from: .local, to: rocket)
                    print("spatial tapped position: \(tappedPosition)")
                    indicator.position = tappedPosition
                }

            }
    }
}

#Preview {
    Example005()
}
