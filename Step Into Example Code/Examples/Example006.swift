//  Step Into Vision - Example Code
//
//  Title: Example006
//
//  Subtitle: Long Press Gesture
//
//  Description: Using the LongPressGesture with a RealityKit Entity
//
//  Type: Space
//
//  Created by Joseph Simpson on 11/7/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example006: View {

    @State var selected: Entity? = nil

    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bundle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4
            }
        }
        .gesture(tapExample)
        .gesture(longPress)
    }

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .targetedToAnyEntity()
            .onEnded { value in

                if selected === value.entity {
                    lowerEntity(value.entity)

                } else {

                    // Lower an existing selected entity
                    if let selected {
                        lowerEntity(selected)
                    }

                    // Raise the long-pressed entity
                    raiseEntity(value.entity)

                    selected = value.entity

                }


            }
    }

    var tapExample: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                lowerEntity(value.entity)
            }
    }

    func raiseEntity(_ entity: Entity) {
        let transform = Transform(
            scale: SIMD3<Float>(repeating: 2),
            rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 0, 0)),
            translation: SIMD3<Float>(entity.position.x, 0.3, entity.position.z)
        )

        entity
            .move(
                to: transform,
                relativeTo: entity.parent!,
                duration: 1.0,
                timingFunction: .easeInOut
            )
    }

    func lowerEntity(_ entity: Entity) {
        let transform = Transform(
            scale: SIMD3<Float>(repeating: 1),
            rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 0, 0)),
            translation: SIMD3<Float>(entity.position.x, 0, entity.position.z)
        )

        entity
            .move(
                to: transform,
                relativeTo: entity.parent!,
                duration: 0.2,
                timingFunction: .easeInOut
            )
    }
}

#Preview {
    Example006()
}
