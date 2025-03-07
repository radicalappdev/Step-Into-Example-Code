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
        .modifier(RotateGesture3DImproved())
    }
}

//fileprivate struct RotateGesture3DImproved: ViewModifier {
//
//    @State var isRotating: Bool = false
//    @State var initialOrientation:simd_quatf = simd_quatf(
//        vector: .init(repeating: 0.0)
//    )
//
//    func body(content: Content) -> some View {
//        content
//            .gesture(
//                RotateGesture3D(constrainedToAxis: .y)
//                    .targetedToAnyEntity()
//                    .onChanged { value in
//
//                        // Cache the entity's initial orientation when the gesture starts
//                        if !isRotating {
//                            isRotating = true
//                            initialOrientation = value.entity.transform.rotation
//                        }
//
//                        let rotation = value.rotation
//                        let rotationTransform = Transform(AffineTransform3D(rotation: rotation))
//
//                        // Multiply the initial orientation by the gesture rotation
//                        value.entity.transform.rotation = initialOrientation * rotationTransform.rotation
//
//                    }
//                    .onEnded { value in
//                        // Clean up when the gesture has ended
//                        isRotating = false
//                        initialOrientation = simd_quatf(
//                            vector: .init(repeating: 0.0)
//                        )
//                    }
//            )
//    }
//}

#Preview {
    Example012()
}
