//  Step Into Vision - Example Code
//
//  Title: Example011
//
//  Subtitle: Magnify Gesture Improved
//
//  Description: Expanding on Magnify Gesture Basics to fix the "snapping" bug when the gesture first starts. Capture the initial scale of the entity when the gesture starts. Multiply the magnification by the initial scale to get the new scale.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 11/12/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example011: View {
    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bundle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4
            }
        }
        .modifier(MagnifyGestureImproved())
    }


}

fileprivate struct MagnifyGestureImproved: ViewModifier {

    @State var isScaling: Bool = false
    @State var initialScale: SIMD3<Float> = .init(repeating: 1.0)

    func body(content: Content) -> some View {
        content
            .gesture(
                MagnifyGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in
                        // Cache the entity's initial scale when the gesture starts
                        if !isScaling {
                            isScaling = true
                            initialScale = value.entity.scale
                        }

                        // Get the magnification from the gesture
                        let magnification = Float(value.magnification)

                        let minScale: Float = 0.25
                        let maxScale: Float = 3

                        // Multiply the magnification by the initial scale to get the new scale
                        // Clamp scale values for each axis independently
                        let newScaleX = min(max(initialScale.x * magnification, minScale), maxScale)
                        let newScaleY = min(max(initialScale.y * magnification, minScale), maxScale)
                        let newScaleZ = min(max(initialScale.z * magnification, minScale), maxScale)

                        // Apply the clamped scale to the entity
                        value.entity.setScale(
                            .init(x: newScaleX, y: newScaleY, z: newScaleZ),
                            relativeTo: value.entity.parent!
                        )
                    }

                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isScaling = false
                        initialScale = .init(repeating: 1.0)
                    }
            )

    }

}

#Preview {
    Example011()
}
