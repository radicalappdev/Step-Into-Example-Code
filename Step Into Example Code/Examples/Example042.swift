//  Step Into Vision - Example Code
//
//  Title: Example042
//
//  Subtitle: RealityKit Basics: Interaction
//
//  Description: Using system gestures to interact with entities in RealityKit.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 1/28/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example042: View {

    @State var earth: Entity = Entity()
    @State var earthTransform: Transform = Transform()
    @State var moon: Entity = Entity()

    var body: some View {
        RealityView { content in

            // Load a scene from the bundle
            if let scene = try? await Entity(named: "RKBasicsLoading", in: realityKitContentBundle) {
                content.add(scene)
                scene.position.y = -0.4 // Move the entire scene down in the volume

                // search the scene for an entity named "Earth"
                if let earth = scene.findEntity(named: "Earth") {
                    self.earth = earth // capture the entity in state, used to target gestures
                    self.earthTransform = earth.transform // capture transform, used to reset
                }

                if let moon = scene.findEntity(named: "Moon") {
                    self.moon = moon // capture the entity in state, used to target gestures
                }
            }

        }
        // Example 2: Double tap the earth to reset transform
        // Note that we need to place this higher in the call chain than the single tap.
        .gesture(TapGesture(count: 2).targetedToEntity(earth)
            .onEnded({ value in
                earth.move(to: earthTransform, relativeTo: earth.parent!, duration: 0.3)
            })
        )
        // Example 1: Tap the earth to scale it up
        .gesture(TapGesture().targetedToEntity(earth)
            .onEnded({ value in
                var newTransform = Transform()
                newTransform.scale = .init(repeating: 1.25)
                earth.move(to: newTransform, relativeTo: earth, duration: 0.3)

            })
        )
        // Example 3: Tap the moon to fire a timeline from Reality Composer Pro
        .gesture(TapGesture().targetedToEntity(moon)
            .onEnded({ value in
                // call applyTapForBehaviors to trigger the behavior on the moon entity
                if value.entity.applyTapForBehaviors() {
                    print("timeline is running")
                }
            })
        )
        // Example 4, part 2
        .modifier(DragToRotate())
    }
}

// Example 4, part 1
// We'll use a drag gesture to rotate the earth around the Y axis
// Adapted from Lab 014 - Building an Indirect Transform System
// https://stepinto.vision/labs/lab-014-building-an-indirect-transform-system/
fileprivate struct DragToRotate: ViewModifier {

    @State var isDragging: Bool = false
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

                        if !isDragging {
                            isDragging = true
                            initialOrientation = value.entity.transform.rotation
                        }
                        rotation.degrees += 0.01 * (value.velocity.width)
                        let rotationTransform = Transform(yaw: Float(rotation.radians))
                        value.entity.transform.rotation = initialOrientation * rotationTransform.rotation
                    }
                    .onEnded { value in
                        isDragging = false
                        initialOrientation = simd_quatf(
                            vector: .init(repeating: 0.0)
                        )
                    }
            )

    }
}

#Preview {
    Example042()
}
