//  Step Into Vision - Example Code
//
//  Title: Example046
//
//  Subtitle: Drag Gesture with Pivot
//
//  Description: We can use the location3D values of the gesture to improve dragging when the user turns to face another direction.
//
//  Type: Space
//
//  Created by Joseph Simpson on 2/10/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example046: View {
    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position = [1, 1, -1.5]

            }

        }
        .modifier(DragGestureWithPivot046())
    }
}

fileprivate struct DragGestureWithPivot046: ViewModifier {

    @State var isDragging: Bool = false
    @State var initialPosition: SIMD3<Float> = .zero

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
                        }

                        guard let entityParent = value.entity.parent else { return }

                        // The current location: where we are in the gesture
                        let gesturePosition = value.convert(value.location3D, from: .global, to: entityParent)

                        // Minus the start location of the gesture
                        let deltaPosition = gesturePosition - value.convert(value.startLocation3D, from: .global, to: entityParent)

                        // Plus the initial position of the entity
                        let newPos = initialPosition + deltaPosition

                        // Optional: using move(to:) to smooth out the movement
                        let newTransform = Transform(
                            scale: value.entity.scale,
                            rotation: value.entity.orientation,
                            translation: newPos
                        )

                        value.entity.move(to: newTransform, relativeTo: entityParent, duration: 0.1)

                        // Or set the position directly
                        // value.entity.position = newPos
                    }
                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isDragging = false
                        initialPosition = .zero
                    }
            )

    }
}

#Preview {
    Example046()
}
