//  Step Into Vision - Example Code
//
//  Title: Example101
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 9/4/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example101: View {

    @State private var alignmentSign: Alignment3D = .front
    var body: some View {
        ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
            .frame(width: 600, height: 600)
            .debugBorder3D(.white)

        // Add an overlay view to the Earth model
            .spatialOverlay(alignment: alignmentSign) {
                VStack {
                    Text("Earth & Luna")
                        .font(.headline)
                }
                .padding()
                .background(.black)
                .cornerRadius(24)
                .breakthroughEffect(.prominent)
            }
    }
}

#Preview {
    Example101()
}
