//  Step Into Vision - Example Code
//
//  Title: Example007
//
//  Subtitle: Drag Gesture
//
//  Description: Using the DragGesture to move entities. **Issue:** This lab doesn't take into account the difference between the position of the entity and the starting position of th gesture **on that entity**. Depending on where you tap, you may see the entity "snap" to a new position when starting this gesture. We will fix this in another example.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 11/8/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example007: View {
    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bundle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4
            }
        }
        .gesture(dragGesture)
    }

    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
            }
    }
}

#Preview {
    Example007()
}
