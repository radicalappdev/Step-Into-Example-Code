//  Step Into Vision - Example Code
//
//  Title: Example026
//
//  Subtitle: Multiple Taps with Tap Gesture
//
//  Description: Using `TapGesture(count:)` to create a double tap. Based on the Tap Gesture example (004)
//
//  Type: Volume
//
//  Created by Joseph Simpson on 12/30/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example026: View {

    @State var selected: Entity? = nil

    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)
                scene.position.y = -0.4
            }
        }
        .gesture(tapExample)
    }

    var tapExample: some Gesture {
        // Set the count to the number of taps to trigger the gesture
        TapGesture(count: 2)
            .targetedToAnyEntity()
            .onEnded { value in
                if selected === value.entity {
                    selected?.position.y = 0
                    selected = nil
                } else {
                    selected?.position.y = 0
                    value.entity.position.y = 0.1
                    selected = value.entity
                }
            }
    }
}

#Preview {
    Example026()
}
