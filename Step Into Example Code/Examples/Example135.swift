//  Step Into Vision - Example Code
//
//  Title: Example135
//
//  Subtitle: RealityKit Basics: Visual Bounds
//
//  Description:
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/15/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example135: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "VisualBounds", in: realityKitContentBundle) else { return }
            scene.name = "Earth"
            content.add(scene)

            let boxSize = scene.visualBounds(relativeTo: nil).extents


        }
    }
}

#Preview {
    Example135()
}
