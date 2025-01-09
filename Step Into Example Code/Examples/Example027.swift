//  Step Into Vision - Example Code
//
//  Title: Example027
//
//  Subtitle: Spatial SwiftUI: shadow modifier
//
//  Description: Using shadows on 2D views to convey depth.
//
//  Type: Window
//
//  Created by Joseph Simpson on 12/30/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example027: View {

    @State var shadowRadius: CGFloat = 6.0
    @State var direction: CGFloat = 0.0

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Slider(value: $shadowRadius,
                       in: 0...12,
                       minimumValueLabel: Image(systemName: "square.fill"),
                       maximumValueLabel: Image(systemName: "square.fill.on.square.fill"),
                       label: {
                    Text("Shadow")
                })

                Slider(value: $direction,
                       in: 0...100,
                       minimumValueLabel: Image(systemName: "square.fill"),
                       maximumValueLabel: Image(systemName: "square.fill.on.square.fill"),
                       label: {
                    Text("Direction")
                })


            }

            HStack(spacing: 24) {

                RoundedRectangle(cornerRadius: 12.0)
                    .foregroundStyle(.white)
                    .shadow(radius: shadowRadius, x: direction, y: direction)

                RoundedRectangle(cornerRadius: 12.0)
                    .foregroundStyle(.white)
                    .offset(z: 50)
                    .shadow(radius: shadowRadius, x: direction, y: direction)

                RoundedRectangle(cornerRadius: 12.0)
                    .foregroundStyle(.white)
                    .offset(z: 100)
                    .shadow(radius: shadowRadius, x: direction, y: direction)

            }
            .padding(12)
        }
        .padding(12)

    }
}

#Preview {
    Example027()
}
