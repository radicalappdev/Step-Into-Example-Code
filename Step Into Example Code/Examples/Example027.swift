//  Step Into Vision - Example Code
//
//  Title: Example027
//
//  Subtitle: Using SwiftUI Shadows to convey depth
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 12/30/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example027: View {

    @State private var redActive = false
    @State private var greenActive = false
    @State private var blueActive = false

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.stepBackgroundSecondary)
            HStack(spacing: 10) {
                Rectangle()
                    .foregroundStyle(.stepRed)
                    .cornerRadius(24)
                    .shadow(radius: redActive ? 12 : 0)
                    .offset(z: redActive ? 24 : 0)
                    .onTapGesture {
                        redActive.toggle()
                    }

                Rectangle()
                    .foregroundStyle(.stepGreen)
                    .cornerRadius(24)
                    .shadow(radius: greenActive ? 12 : 0)
                    .offset(z: greenActive ? 24 : 0)
                    .onTapGesture {
                        greenActive.toggle()
                    }

                Rectangle()
                    .foregroundStyle(.stepBlue)
                    .cornerRadius(24)
                    .shadow(radius: blueActive ? 12 : 0)
                    .offset(z: blueActive ? 24 : 0)
                    .onTapGesture {
                        blueActive.toggle()
                    }

            }
            .padding(60)
        }
    }
}

#Preview {
    Example027()
}
