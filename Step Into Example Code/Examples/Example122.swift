//  Step Into Vision - Example Code
//
//  Title: Example122
//
//  Subtitle: Working with Entity Actions
//
//  Description: We can use Entity Actions in Timelines to animate changes to our scenes.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 11/12/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example122: View {
    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "SimpleEntityActions", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.setScale(.init(repeating: 0.5), relativeTo: nil)

            guard let earth = scene.findEntity(named: "Earth") else { return }
            let earthGesture = TapGesture()
                .targetedToEntity(earth)
                .onEnded { value in
                    _ = value.entity.applyTapForBehaviors()
                }
            earth.components.set(GestureComponent(earthGesture))

            guard let moon = scene.findEntity(named: "Moon") else { return }
            let moonGesture = TapGesture()
                .targetedToEntity(moon)
                .onEnded { value in
                    _ = value.entity.applyTapForBehaviors()
                }
            moon.components.set(GestureComponent(moonGesture))
        }
    }
}

#Preview {
    Example122()
}
