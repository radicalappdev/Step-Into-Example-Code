//  Step Into Vision - Example Code
//
//  Title: Example042
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/28/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example042: View {

    @State var earth: Entity = Entity()
    @State var earthTransform: Transform = Transform()
    @State var moon: Entity = Entity()
    @State var moonTransform: Transform = Transform()

    var body: some View {
        RealityView { content in

            // Load a scene from the bundle
            if let scene = try? await Entity(named: "RKBasicsLoading", in: realityKitContentBundle) {

                // Make sure to add the scene to the content!
                content.add(scene)

                // Move the entire scene down in the volume
                scene.position.y = -0.4

                // search the scene for an entity with a name
                if let earth = scene.findEntity(named: "Earth") {
                    self.earth = earth
                    self.earthTransform = earth.transform
                }

                if let moon = scene.findEntity(named: "Moon") {
                    self.moon = moon
                    self.moonTransform = moon.transform
                }
            }

        }
        .gesture(TapGesture(count: 2).targetedToEntity(earth)
            .onEnded({ value in
                value.entity.move(to: earthTransform, relativeTo: earth, duration: 0.3)
            })
        )
        .gesture(TapGesture().targetedToEntity(moon)
            .onEnded({ value in
                _ = value.entity.applyTapForBehaviors()
            })
        )
    }
}

#Preview {
    Example042()
}
