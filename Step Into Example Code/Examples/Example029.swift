//  Step Into Vision - Example Code
//
//  Title: Example029
//
//  Subtitle: How to show and hide the window bar
//
//  Description: We can use `persistentSystemOverlays(_:)` to control the visibility of the window drag bar.
//
//  Type: Window
//
//  Created by Joseph Simpson on 1/3/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example029: View {

    @State var vis: Visibility = .automatic

    var body: some View {
        HStack(spacing: 24) {
            Button(action: {
                vis = .automatic
            }, label: {
                Image(systemName: vis == .automatic ? "circle.fill" : "circle")
                Text("automatic")
            })

            Button(action: {
                vis = .hidden
            }, label: {
                Image(systemName: vis == .hidden ? "circle.fill" : "circle")
                Text("hidden")
            })

            Button(action: {
                vis = .visible
            }, label: {
                Image(systemName: vis == .visible ? "circle.fill" : "circle")
                Text("visible")
            })
        }
        .persistentSystemOverlays(vis)
    }
}

#Preview {
    Example029()
}
