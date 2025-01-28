//  Step Into Vision - Example Code
//
//  Title: Example043
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

struct Example043: View {
    var body: some View {
        RealityView { content in

            // Load a scene from the bundle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {

                content.add(scene)
                scene.position.y = -0.4

            }

        }
        .ornament(attachmentAnchor: .scene(.bottom)) {
            Example043Label()
        }
        .ornament(attachmentAnchor: .scene(.bottomBack)) {
            Example043Label()
        }
        .ornament(attachmentAnchor: .scene(.bottomFront)) {
            Example043Label()
        }
    }
}

struct Example043Label: View {
    var title = "⚫️"
    var body: some View {
        Text(title)
            .font(.system(size: 36))
    }
}

#Preview {
    Example043()
}
