//  Step Into Vision - Example Code
//
//  Title: Example079
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/28/25.

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct Example079: View {
    @State var session = ARKitSession()
    @State var worldTracking = WorldTrackingProvider()

    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(named: "WorldTracking", in: realityKitContentBundle) else { return }
            content.add(scene)

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .modifier(DragGestureWithWorldAnchor(worldTracking: self.$worldTracking))
        .task {
            try! await setupAndRunWorldTracking()
        }
    }

    func setupAndRunWorldTracking() async throws {

        if WorldTrackingProvider.isSupported {
            do {
                try await session.run([worldTracking])
            } catch {
                print("ARKit session error \(error)")
            }
        }

    }
}

fileprivate struct DragGestureWithWorldAnchor: ViewModifier {

    @State var isDragging: Bool = false
    @State var initialPosition: SIMD3<Float> = .zero
    @Binding var worldTracking: WorldTrackingProvider

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
                    }
                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isDragging = false
                        initialPosition = .zero
                        Task {
                            let anchor = WorldAnchor(originFromAnchorTransform: value.entity.transformMatrix(relativeTo: nil ))
                            try await worldTracking.addAnchor(anchor)
                        }

                    }
            )

    }
}

#Preview {
    Example079()
}
