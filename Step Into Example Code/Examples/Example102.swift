//  Step Into Vision - Example Code
//
//  Title: Example102
//
//  Subtitle: Spatial SwiftUI: onWorldRecenter
//
//  Description: We can use this modifier to execute code after the user has recentered their view.
//
//  Type: Window
//
//  Created by Joseph Simpson on 9/9/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example102: View {

    @State private var scale: CGFloat = 1.0

    fileprivate func bounceTheWorld() {
        withAnimation(.easeOut(duration: 0.2)) { scale = 1.4 }
        withAnimation(.easeIn(duration: 0.3).delay(0.2)) { scale = 1.0 }
    }

    var body: some View {
        VStack {
            ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
                .frame(width: 200, height: 200)
                .scaleEffect(scale)
        }
        .onWorldRecenter {
            bounceTheWorld()
        }
    }
}

#Preview {
    Example102()
}
