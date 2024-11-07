//  Step Into Vision - Example Code
//
//  Title: Example006
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 11/7/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example006: View {

    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bundle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4
            }
        }
        .gesture(longPress)
    }

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 3)
            .targetedToAnyEntity()
            .onEnded { value in

                value.entity.scale = .init(repeating: 2)

            }
    }
}

#Preview {
    Example006()
}
