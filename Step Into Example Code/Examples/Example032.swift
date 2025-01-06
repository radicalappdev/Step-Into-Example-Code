//  Step Into Vision - Example Code
//
//  Title: Example032
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/6/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example032: View {

    @State var isActive = false

    var body: some View {
        VStack(spacing: 24) {

            Toggle("Toggle Offset", isOn: $isActive.animation())
                .toggleStyle(.button)

            HStack(spacing: 24) {

                RoundedRectangle(cornerRadius: 12.0)
                    .foregroundStyle(.stepRed)
                    .offset(x: isActive ? -60 : 0)
                    .offset(z: isActive ? 80 : 1)
                    .rotation3DEffect(
                        Angle(degrees: isActive ? 25 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )

                RoundedRectangle(cornerRadius: 12.0)
                    .foregroundStyle(.stepBlue)
                    .offset(z: isActive ? 20 : 1)

                RoundedRectangle(cornerRadius: 12.0)
                    .foregroundStyle(.stepGreen)
                    .offset(x: isActive ? 60 : 0)
                    .offset(z: isActive ? 80 : 1)
                    .rotation3DEffect(
                        Angle(degrees: isActive ? -25 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )

            }
            .padding(12)
        }
        .padding(12)
        .glassBackgroundEffect(displayMode: isActive ? .never : .always)

    }
}

#Preview {
    Example032()
}
