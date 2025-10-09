//  Step Into Vision - Example Code
//
//  Title: Example108
//
//  Subtitle: RealityKit Basics: Coordinate Space Conversion
//
//  Description: RealityViewContent provides several ways to work with and convert between coordinate spaces.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 10/8/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example108: View {
    var body: some View {
        GeometryReader3D { proxy in
            RealityView { content in

                guard let scene = try? await Entity(named: "ToyRocket", in: realityKitContentBundle) else { return }
                content.add(scene)

            } update: { content in
                if let rocket = content.entities.first {
                    let newFrame = content.convert(proxy.frame(in: .global), from: .global, to: .scene)
                    rocket.scale = [newFrame.extents.x, newFrame.extents.y, newFrame.extents.z]
                }

            }
            .debugBorder3D(.white)
        }
    }
}

#Preview {
    Example108()
}
