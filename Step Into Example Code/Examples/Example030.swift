//  Step Into Vision - Example Code
//
//  Title: Example030
//
//  Subtitle: Spatial SwiftUI: offset
//
//  Description: Using z axis offset to lift our views out of their window.
//
//  Type: Window
//
//  Created by Joseph Simpson on 1/4/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example030: View {

    @State var showOffset = false

    var body: some View {
        VStack(spacing: 24) {

            Toggle("Toggle Offset", isOn: $showOffset.animation())
                .toggleStyle(.button)

            HStack(spacing: 24) {

                RoundedRectangle(cornerRadius: 12.0)
                    .foregroundStyle(.stepRed)
                     // offset(z:) and offset(x:y:) are different modifiers!
                    .offset(z: showOffset ? 12 : 0)
                    .offset(x: showOffset ? 48 : 0)
                RoundedRectangle(cornerRadius: 12.0)
                    .foregroundStyle(.stepBlue)
                    .offset(z: showOffset ? 24 : 0)
                RoundedRectangle(cornerRadius: 12.0)
                    .foregroundStyle(.stepGreen)
                    .offset(z: showOffset ? 36 : 0)
                    .offset(x: showOffset ? -48 : 0)

            }
            .padding(12)
        }
        .padding(12)
    }
}

#Preview {
    Example030()
}
