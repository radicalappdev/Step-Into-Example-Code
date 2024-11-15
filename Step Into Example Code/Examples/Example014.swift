//  Step Into Vision - Example Code
//
//  Title: Example014
//
//  Subtitle: Simultaneously combine gestures
//
//  Description: An example of using SimultaneousGesture to create a Magnify + Rotate gesture.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 11/15/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example014: View {
    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bundle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4
            }
        }
        .modifier(ScaleAndRotateGesture())
    }
}

fileprivate struct ScaleAndRotateGesture: ViewModifier {

    @State var isActive: Bool = false
    @State var initialScale: SIMD3<Float> = .init(repeating: 1.0)
    @State var initialOrientation:simd_quatf = simd_quatf(
        vector: .init(repeating: 0.0)
    )

    func body(content: Content) -> some View {
        content
            .gesture(
                RotateGesture3D(constrainedToAxis: .y)
                    .simultaneously(with: MagnifyGesture())
                    .targetedToAnyEntity()
                    .onChanged { value in

                        // Cache the entity's initial scale and orientation when the gesture starts
                        if !isActive {
                            isActive = true
                            initialScale = value.entity.scale
                            initialOrientation = value.entity.transform.rotation
                        }

                        // Get the rotationa and magnification values
                        if let rotation = value.first?.rotation, let magnification = value.second?.magnification {


                            // Handle rotation (see exaple 012)
                            let rotationTransform = Transform(AffineTransform3D(rotation: rotation))
                            value.entity.transform.rotation = initialOrientation * rotationTransform.rotation

                            // Handle scale (see example 011)
                            let magnificationF = Float(magnification) // convert from CGFloat to Float...
                            let minScale: Float = 0.25
                            let maxScale: Float = 3
                            let newScaleX = min(max(initialScale.x * magnificationF, minScale), maxScale)
                            let newScaleY = min(max(initialScale.y * magnificationF, minScale), maxScale)
                            let newScaleZ = min(max(initialScale.z * magnificationF, minScale), maxScale)
                            value.entity.setScale(
                                .init(x: newScaleX, y: newScaleY, z: newScaleZ),
                                relativeTo: value.entity.parent!
                            )
                        }

                    }
                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isActive = false
                        initialScale = .init(repeating: 1.0)
                        initialOrientation = simd_quatf(
                            vector: .init(repeating: 0.0)
                        )

                    }
                )
    }

}


#Preview {
    Example014()
}
