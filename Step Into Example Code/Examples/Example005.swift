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

    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bindle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4
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
        .gesture(tapExample)
    }

    var tapExample: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in

            }
    }
}

#Preview {
    Example005()
}
