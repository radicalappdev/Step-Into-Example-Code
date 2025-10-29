//  Step Into Vision - Example Code
//
//  Title: Example117swift
//
//  Subtitle: Transforming Entities with Gesture Component
//
//  Description: We can capture the entity transform when a gesture starts, then use that value when moving the entity as the user drags
//
//  Type: Volume
//
//  Created by Joseph Simpson on 10/29/25.

import SwiftUI
import RealityKit
import RealityKitContent

// 1) A tiny component to stash the starting transform (local-to-parent).
fileprivate struct InitialTransformComponent: Component, Codable {
    var transform: Transform
}

struct Example117: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "TapGestureExample", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)

            if let subject = scene.findEntity(named: "ToyRocket") {
                let drag = DragGesture(minimumDistance: 0.001)
                    .onChanged { [weak subject] value in
                        guard let subject = subject else { return }

                        // 2) On the first change, capture the starting transform.
                        if !subject.components.has(InitialTransformComponent.self) {
                            subject.components.set(InitialTransformComponent(transform: subject.transform))
                        }

                        // 3) Pull the saved start transform.
                        guard let initialTransform = subject.components[InitialTransformComponent.self]?.transform else { return }

                        // 4) Translate the entity along the Y axis
                        let translation = value.translation3D
                        var newTransform = initialTransform
                        newTransform.translation.y += Float(translation.y)
                        subject.transform = newTransform

                    }
                    .onEnded { [weak subject] _ in
                        // 5) Clean up the stash when the gesture ends.
                        subject?.components.remove(InitialTransformComponent.self)
                    }

                subject.components.set(GestureComponent(drag))
            }

        }
    }
}
