//  Step Into Vision - Example Code
//
//  Title: Example006
//
//  Subtitle:
//
//  Description:
//
//  Type:
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

                let transform = Transform(
                    scale: SIMD3<Float>(repeating: 2),
                    rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 0, 0)),
                    translation: SIMD3<Float>(value.entity.position.x, 0.3, value.entity.position.z)
                )

                value.entity
                    .move(
                        to: transform,
                        relativeTo: value.entity.parent!,
                        duration: 1.0,
                        timingFunction: .easeInOut
                    )

            }
    }

    var tapExample: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in

                print("GESTURE tapped")
                let transform = Transform(
                    scale: SIMD3<Float>(repeating: 1),
                    rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 0, 0)),
                    translation: SIMD3<Float>(value.entity.position.x, 0, value.entity.position.z)
                )

                value.entity
                    .move(
                        to: transform,
                        relativeTo: value.entity.parent!,
                        duration: 0.2,
                        timingFunction: .easeInOut
                    )


            }
    }
}

#Preview {
    Example006()
}
