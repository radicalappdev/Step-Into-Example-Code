//  Step Into Vision - Example Code
//
//  Title: Example116
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/28/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example116: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) else { return }
            scene.position.y = -0.4
            content.add(scene)

            if let subjectA = scene.findEntity(named: "ToyCar") {
                let tap = TapGesture().onEnded({ [weak subjectA] _ in
                    if let subjectA = subjectA {
                        let scaler: Float = subjectA.scale.x > 2.0 ? 1 : subjectA.scale.x + 0.25
                        subjectA.scale = .init(repeating: scaler)
                    }
                })
                let gesture = GestureComponent(tap)
                subjectA.components.set(gesture)
            }

            if let subjectB = scene.findEntity(named: "ToyRocket") {
                let drag = DragGesture(minimumDistance: 0.001)
                    .onChanged { _ in
                        print("Drag Gesture onChanged")
                    }
                    .onEnded { _ in
                        print("Drag Gesture onEnd")
                    }
                let gesture = GestureComponent(drag)
                subjectB.components.set(gesture)
            }

        }
    }
}

#Preview {
    Example116()
}
