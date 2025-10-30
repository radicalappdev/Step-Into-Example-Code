//  Step Into Vision - Example Code
//
//  Title: Example118
//
//  Subtitle: Targeting an Entity with Gesture Component
//
//  Description: We can use three instance methods to access entities and additional features in our gestures.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 10/30/25.

import SwiftUI
import RealityKit
import RealityKitContent

fileprivate struct InitialTransformComponent: Component, Codable {
    var transform: Transform
}

struct Example118: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)

            // Target a specific entity
            if let subject = scene.findEntity(named: "ToyRocket") {
                let drag = DragGesture(minimumDistance: 0.001)
                    .targetedToEntity(subject)
                    .onChanged { value in
                        let subject = value.entity

                        if !subject.components.has(InitialTransformComponent.self) {
                            subject.components.set(InitialTransformComponent(transform: subject.transform))
                        }

                        guard let initialTransform = subject.components[InitialTransformComponent.self]?.transform else { return }

                        let translation = value.translation3D
                        var newTransform = initialTransform
                        newTransform.translation.y += Float(translation.y)
                        subject.transform = newTransform

                    }
                    .onEnded { value in
                        value.entity.components.remove(InitialTransformComponent.self)
                    }

                subject.components.set(GestureComponent(drag))
            }

            if let subjectB = scene.findEntity(named: "ToyCar"), let subjectC = scene.findEntity(named: "ToyBiplane")  {
                subjectB.components.set(GestureComponent(dragAny))
                subjectC.components.set(GestureComponent(dragAny))
            }

        }
    }

    // Create a gesture to target any entity
    var dragAny: some Gesture {
        DragGesture(minimumDistance: 0.001)
            .targetedToAnyEntity()
            .onChanged { value in
                let subject = value.entity

                if !subject.components.has(InitialTransformComponent.self) {
                    subject.components.set(InitialTransformComponent(transform: subject.transform))
                }

                guard let initialTransform = subject.components[InitialTransformComponent.self]?.transform else { return }

                let translation = value.translation3D
                var newTransform = initialTransform
                newTransform.translation.y += Float(translation.y)
                subject.transform = newTransform

            }
            .onEnded { value in
                value.entity.components.remove(InitialTransformComponent.self)
            }
    }
}


#Preview {
    Example118()
}


