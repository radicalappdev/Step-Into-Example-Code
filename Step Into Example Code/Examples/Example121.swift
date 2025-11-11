//  Step Into Vision - Example Code
//
//  Title: Example121
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 11/11/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example121: View {
    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "SimpleTimelines", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.setScale(.init(repeating: 0.5), relativeTo: nil)
        }
    }
}

#Preview {
    Example121()
}
