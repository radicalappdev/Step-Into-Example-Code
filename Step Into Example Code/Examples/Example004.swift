//  Step Into Vision - Example Code
//
//  Title: Example004
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/15/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example004: View {
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

            }
        }
    }
}

#Preview {
    Example004()
}
