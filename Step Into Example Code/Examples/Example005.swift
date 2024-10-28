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

    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bindle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4

                if let toyRocket = scene.findEntity(named: "ToyRocket") {
                    toyRocket.components.set(HoverEffectComponent())
                    rocket = toyRocket
                }
                
            }

            if let scene = try? await Entity(named: "GestureLabsHelpers", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4

                if let place1 = scene.findEntity(named: "Place1") {
                    place1.components.set(HoverEffectComponent())
                }
                if let place2 = scene.findEntity(named: "Place2") {
                    place2.components.set(HoverEffectComponent())
                }
                if let place3 = scene.findEntity(named: "Place3") {
                    place3.components.set(HoverEffectComponent())
                }

            }
        }
//        .gesture(tapExample)
        .gesture(spatialTapExample)
    }

    var tapExample: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                if let rocket = rocket {
                    rocket.position = value.entity.position
                }
                print("tapped: \(value)")

            }
    }
    var spatialTapExample: some Gesture {
        SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                print("spatial tapped: \(value.location3D)")

                if let rocket = rocket {

                    let tappedPosition = value.convert(value.location3D, from: .global, to: .scene)
                    print("spatial tapped: \(tappedPosition)")

                    rocket.position = tappedPosition
//                    rocket.setPosition(tappedPosition, relativeTo: rocket.parent)
                }


            }
    }
}

#Preview {
    Example005()
}
