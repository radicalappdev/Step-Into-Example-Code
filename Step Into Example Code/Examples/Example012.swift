//  Step Into Vision - Example Code
//
//  Title: Example012
//
//  Subtitle: Rotate Gesture 3D Improved
//
//  Description: Expanding on the RotateGesture3D basics example to fix the "snapping" bug when the gesture first starts. Capture the initial orientation when the gesture starts and add it to the rotation from the gesture
//
//  Type: Volume
//
//  Created by Joseph Simpson on 11/13/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example012: View {
    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bundle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4
            }
        }
        .gesture(rotateGesture)
    }

    var rotateGesture: some Gesture {
        RotateGesture3D(constrainedToAxis: .y)
            .targetedToAnyEntity()
            .onChanged { value in

                let rotation = value.rotation
                let rotationTransform = Transform(AffineTransform3D(rotation: rotation))
                value.entity.transform.rotation = rotationTransform.rotation

            }
    }
}

#Preview {
    Example012()
}
