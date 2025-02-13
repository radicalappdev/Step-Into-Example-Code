//  Step Into Vision - Example Code
//
//  Title: Example047
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 2/13/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example047: View {

    @State private var transformMode: IndirectTransformMode = .none

    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bundle
            if let scene = try? await Entity(named: "RKBasicsLoading", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4

            }
        }
        .modifier(IndirectTransformGesture(mode: $transformMode))
        .toolbar {
            // .bottomOrnament seems to be the only placement that works
            ToolbarItemGroup(placement: .bottomOrnament) {

                Button {
                    transformMode = .none
                } label: {
                    Image(systemName: "nosign")

                }
                .background(transformMode == .none ? .stepRed : Color.clear)
                .clipShape(.capsule)

                Spacer()
                Divider()
                Spacer()


                Button {
                    transformMode = .move
                } label: {
                    Image(systemName: "move.3d")
                }
                .background(transformMode == .move ? .stepRed : Color.clear)
                .clipShape(.capsule)
                Button {
                    transformMode = .rotate
                } label: {
                    Image(systemName: "rotate.3d")
                }
                .background(transformMode == .rotate ? .stepRed : Color.clear)
                .clipShape(.capsule)
                Button {
                    transformMode = .scale
                } label: {
                    Image(systemName: "scale.3d")
                }
                .background(transformMode == .scale ? .stepRed : Color.clear)
                .clipShape(.capsule)
            }

        }
    }
}

fileprivate enum IndirectTransformMode {
    case none
    case move
    case rotate
    case scale
}

fileprivate struct IndirectTransformGesture: ViewModifier {

    @Binding var mode: IndirectTransformMode

    @State var isDragging: Bool = false
    @State var initialPosition: SIMD3<Float> = .zero
    @State var initialScale: SIMD3<Float> = .init(repeating: 1.0)
    @State var initialOrientation:simd_quatf = simd_quatf(
        vector: .init(repeating: 0.0)
    )

    @State var rotation: Angle = .zero

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in

                        // We we start the gesture, cache the entity position
                        if !isDragging {
                            isDragging = true
                            initialPosition = value.entity.position
                            initialScale = value.entity.scale
                            initialOrientation = value.entity.transform.rotation
                        }

                        switch mode {
                        case .move:
                            // Calculate vector by which to move the entity
                            let movement = value.convert(value.gestureValue.translation3D, from: .local, to: .scene)
                            // Add the two vectors and clamp the result to keep the entity in the volume. Ignore the Y axis
                            let newPostion = initialPosition + movement
                            let limit: Float = 0.25
                            let posX = min(max(newPostion.x, -limit), limit)
                            let posZ = min(max(newPostion.z, -limit), limit)
                            value.entity.position.x = posX
                            value.entity.position.z = posZ

                        case .rotate:
                            // Just a hack to rotate by *something* from the drag gesture. I'm sure there is a better way.
                            rotation.degrees += 0.01 * (value.velocity.width)
                            let rotationTransform = Transform(yaw: Float(rotation.radians))

                            value.entity.transform.rotation = initialOrientation * rotationTransform.rotation
                        case .scale:

                            // A hack to get some value from the gesture that we can use to scale
                            let magnification = 0.01 * Float(value.gestureValue.translation3D.x)
                            let scaler = magnification + initialScale.x

                            // Clamp scale values for each axis independently
                            let minScale: Float = 0.25
                            let maxScale: Float = 3
                            let newScaler: Float = min(max(scaler, minScale), maxScale)

                            // Apply the clamped scale to the entity
                            value.entity.setScale(
                                .init(repeating: newScaler),
                                relativeTo: value.entity.parent!
                            )
                        case .none: break
                        }


                    }
                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isDragging = false
                        initialPosition = .zero
                        initialScale = .init(repeating: 1.0)
                        initialOrientation = simd_quatf(
                            vector: .init(repeating: 0.0)
                        )
                    }
            )

    }
}

#Preview {
    Example047()
}
