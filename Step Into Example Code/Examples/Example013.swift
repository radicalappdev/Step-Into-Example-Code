//  Step Into Vision - Example Code
//
//  Title: Example013
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 11/14/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example013: View {
    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bundle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4
            }
        }
        .modifier(LongPressDragGesture())
    }
}

fileprivate struct LongPressDragGesture: ViewModifier {

    @State var isDragging: Bool = false
    @State var initialPosition: SIMD3<Float> = .zero

    func body(content: Content) -> some View {
        content
            .gesture(
                longPress
                    .sequenced(before: dragGesture))

    }

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1.0)
    }

    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in

                // We we start the gesture, cache the entity position
                if !isDragging {
                    isDragging = true
                    initialPosition = value.entity.position
                }

                // Calculate vector by which to move the entity
                let movement = value.convert(value.gestureValue.translation3D, from: .local, to: .scene)

                // Add the initial position and the movement to get the new position
                value.entity.position = initialPosition + movement

            }
            .onEnded { value in
                // Clean up when the gesture has ended
                isDragging = false
                initialPosition = .zero
            }

    }
}

#Preview {
    Example013()
}
