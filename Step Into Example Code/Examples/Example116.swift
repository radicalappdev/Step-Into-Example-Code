//  Step Into Vision - Example Code
//
//  Title: Example116
//
//  Subtitle: Gesture Component
//
//  Description: Exploring a new way to add gestures directly to entities.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 10/28/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example116: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "TapGestureExample", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)

            if let subject = scene.findEntity(named: "ToyRocket") {
                let tap = TapGesture().onEnded({ [weak subject] _ in
                    if let subject = subject {
                        exampleAction1(entity: subject)
                    }
                })
                let gesture = GestureComponent(tap)
                subject.components.set(gesture)
            }


        }
    }

    // See RealityKit Basics: Perform Entity Actions: https://stepinto.vision/example-code/realitykit-basics-perform-entity-actions/
    func exampleAction1(entity: Entity) {
        Task {
            let action = SpinAction(revolutions: 1,
                                    localAxis: [0, 1, 0],
                                    timingFunction: .easeInOut,
                                    isAdditive: false)

            let animation = try AnimationResource.makeActionAnimation(for: action,
                                                                      duration: 1,
                                                                      bindTarget: .transform)

            entity.playAnimation(animation)
        }
    }
}

#Preview {
    Example116()
}


