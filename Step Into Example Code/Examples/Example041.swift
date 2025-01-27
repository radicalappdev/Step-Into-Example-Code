//  Step Into Vision - Example Code
//
//  Title: Example041
//
//  Subtitle: RealityKit Basics: Loading content from Reality Composer Pro
//
//  Description: Loading scenes and assets RealityView.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 1/27/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example041: View {
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
                    print("Earth entity found")
                }
            }

        }
    }
}

#Preview("Volume", windowStyle: .volumetric) {
    Example041()
}
