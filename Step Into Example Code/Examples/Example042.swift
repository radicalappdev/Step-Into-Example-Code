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
                    print("Earth entity found \(earth)")
                }
            }

        }
    }
}

#Preview {
    Example042()
}
