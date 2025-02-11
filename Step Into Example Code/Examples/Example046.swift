//  Step Into Vision - Example Code
//
//  Title: Example046
//
//  Subtitle:
//
//  Description:
//
//  Type:
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
            )

    }
}

#Preview {
    Example046()
}
