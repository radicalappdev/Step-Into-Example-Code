//  Step Into Vision - Example Code
//
//  Title: Example032
//
//  Subtitle: Spatial SwiftUI: rotation3DEffect
//
//  Description: Using rotation3DEffect to rotate views in a window.
//
//  Type: Window
//
//  Created by Joseph Simpson on 1/6/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example032: View {

    @State private var isActive = false
    @State private var showWindow = true

    var body: some View {
        VStack(spacing: 24) {
            Button(action: handleButtonPress) {
                Image(systemName: isActive ? "square.stack.3d.down.right.fill" : "square.fill")
                Text("Toggle Layout")
            }

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
                    .offset(z: isActive ? 40 : 1)

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
        .glassBackgroundEffect(displayMode: showWindow ? .always : .never)
        .persistentSystemOverlays(showWindow ? .visible : .hidden)
    }

    private func handleButtonPress() {
        Task {
            if isActive {
                // If we are showing the rotated layout, animate it back to flat, then show the window
                withAnimation {
                    isActive.toggle()
                }
                try? await Task.sleep(nanoseconds: 500_000_000)
                    showWindow = true
            } else {
                // If we are showing the flat layout, hide the window then animate to the rotated layout
                    showWindow = false

                try? await Task.sleep(nanoseconds: 200_000_000)
                withAnimation {
                    isActive.toggle()
                }
            }
        }
    }
}



#Preview {
    Example032()
}
