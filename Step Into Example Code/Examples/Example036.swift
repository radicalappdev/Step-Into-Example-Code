//  Step Into Vision - Example Code
//
//  Title: Example036
//
//  Subtitle: Spatial SwiftUI: ZStack and frame(depth:)
//
//  Description: Three simple methods to stack and space views.
//
//  Type: Window
//
//  Created by Joseph Simpson on 1/12/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example036: View {

    @State var spacing: CGFloat = 0.0
    var body: some View {
        VStack(spacing: 24) {
            Slider(value: $spacing,
                   in: 0...100,
                   minimumValueLabel: Image(systemName: "square.fill"),
                   maximumValueLabel: Image(systemName: "square.stack.3d.down.forward.fill"),
                   label: {
                Text("Spacing")
            })
            .frame(width: 300)

            HStack {

                // 1. Space views evenly in the ZStack. Spacing is controlled by the parent ZStack
                ZStack(spacing: spacing / 3) {
                    RoundedRectangle(cornerRadius: 12.0)
                        .foregroundStyle(.stepRed)
                        .frame(width: 200, height: 200)

                    RoundedRectangle(cornerRadius: 12.0)
                        .foregroundStyle(.stepGreen)
                        .frame(width: 150, height: 150)

                    RoundedRectangle(cornerRadius: 12.0)
                        .foregroundStyle(.stepBlue)
                        .frame(width: 100, height: 100)
                }
                .frame(depth: spacing)

                // 2. Use Spacers to fill all available space in the ZStack
                ZStack() {
                    RoundedRectangle(cornerRadius: 12.0)
                        .foregroundStyle(.stepRed)
                        .frame(width: 200, height: 200)

                    Spacer() // this spaces pushes the first view all the way to the back

                    RoundedRectangle(cornerRadius: 12.0)
                        .foregroundStyle(.stepGreen)
                        .frame(width: 150, height: 150)

                    Spacer() // this spacer pushes the last view all the way to the front

                    RoundedRectangle(cornerRadius: 12.0)
                        .foregroundStyle(.stepBlue)
                        .frame(width: 100, height: 100)
                }
                .frame(depth: spacing)

                // 3. Each child view has a depth value that takes up 1/3 of the ZStack depth
                ZStack() {
                    RoundedRectangle(cornerRadius: 12.0)
                        .foregroundStyle(.stepRed)
                        .frame(width: 200, height: 200)
                        .frame(depth: spacing / 3)

                    RoundedRectangle(cornerRadius: 12.0)
                        .foregroundStyle(.stepGreen)
                        .frame(width: 150, height: 150)
                        .frame(depth: spacing / 3)

                    RoundedRectangle(cornerRadius: 12.0)
                        .foregroundStyle(.stepBlue)
                        .frame(width: 100, height: 100)
                        .frame(depth: spacing / 3)
                }
                .frame(depth: spacing)

            }
            .padding()
        }
    }
}

#Preview {
    Example036()
}

