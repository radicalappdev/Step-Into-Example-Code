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
    @State var selected: Entity? = nil

    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bindle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4
            }
        }
        .gesture(tapExample)
    }

    var tapExample: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                if selected === value.entity {
                    // If the same entity is tapped, lower it and deselect.
                    selected?.position.y = 0
                    selected = nil
                } else {
                    // Lower the previously selected entity (if any).
                    selected?.position.y = 0

                    // Raise the new entity and select it.
                    value.entity.position.y = 0.1
                    selected = value.entity
                }
            }
    }
}

#Preview {
    Example005()
}
