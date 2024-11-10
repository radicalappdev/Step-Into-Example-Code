//  Step Into Vision - Example Code
//
//  Title: Example009
//
//  Subtitle: Rotate Gesture 3D Basics
//
//  Description: Using the RotateGesture3D to rotate entities around an axis.
//
//  Type:
//
//  Created by Joseph Simpson on 11/10/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example009: View {
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
    Example009()
}
