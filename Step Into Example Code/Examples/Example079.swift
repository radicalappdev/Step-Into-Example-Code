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
    @State var subject = Entity()
    @State var anchorID: UUID?

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "WorldTracking", in: realityKitContentBundle) else { return }
            content.add(scene)

            if let subjectEntity = scene.findEntity(named: "ToyRocket") {
                subject = subjectEntity
            }

        }
        .modifier(DragGestureWithWorldAnchor() {
            Task {
                let anchor = WorldAnchor(originFromAnchorTransform: subject.transformMatrix(relativeTo: nil))
                try await worldTracking.addAnchor(anchor)
                
            }
        })
        .task {
            try! await setupAndRunWorldTracking()
        }
    }



    func setupAndRunWorldTracking() async throws {

        if WorldTrackingProvider.isSupported {
            do {
                try await session.run([worldTracking])

                for await update in worldTracking.anchorUpdates {
                    switch update.event {
                    case .added, .updated:
                        // Update the app's understanding of this world anchor.
                        print("Anchor position updated. \(update.anchor.id)")
                        subject.transform = Transform(matrix: update.anchor.originFromAnchorTransform)
                    case .removed:
                        // Remove content related to this anchor.
                        print("Anchor position now unknown.")
                    }
                }
            } catch {
                print("ARKit session error \(error)")
            }
        }

    }
}

fileprivate struct DragGestureWithWorldAnchor: ViewModifier {

    @State var isDragging: Bool = false
    @State var initialPosition: SIMD3<Float> = .zero

    let updateAnchor: (() -> Void)?

    init(updateAnchor: (() -> Void)? = nil) {
        self.updateAnchor = updateAnchor
    }

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
                        if let updateAnchor = updateAnchor {
                            updateAnchor()
                        }
                    }
            )
    }
}

#Preview {
    Example079()
}
