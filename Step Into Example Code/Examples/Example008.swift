//  Step Into Vision - Example Code
//
//  Title: Example008
//
//  Subtitle: Magnify Gesture Basics
//
//  Description: Using the MagnifyGesture to scale entities.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 11/10/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example008: View {
    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bundle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4
            }
        }
        .gesture(magnifyGesture)
    }

    var magnifyGesture: some Gesture {
        MagnifyGesture()
            .targetedToAnyEntity()
            .onChanged { value in

                // Get the magnification from the gesture
                let scaler = Float(value.magnification)

                // Clamp the value so it can't get too small or too large
                let minScale: Float = 0.25
                let maxScale: Float = 3
                let clampedScale = min(Float(max(Float(scaler), minScale)), maxScale)

                // Apply the new scale
                value.entity
                    .setScale(
                        .init(repeating: clampedScale),
                        relativeTo: value.entity.parent!
                    )

            }
    }
}
#Preview {
    Example008()
}
