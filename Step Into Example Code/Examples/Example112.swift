//  Step Into Vision - Example Code
//
//  Title: Example112
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/20/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example112: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "EntityActionLab", in: realityKitContentBundle) else { return }
            content.add(scene)

        }
    }
}

#Preview {
    Example112()
}
