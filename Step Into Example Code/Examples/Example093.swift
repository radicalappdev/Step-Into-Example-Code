//  Step Into Vision - Example Code
//
//  Title: Example093
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 7/8/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example093: View {

    @State private var alignment: Alignment3D = .bottomFront
    @State private var showDebugLines = true

    var body: some View {

        HStackLayout().depthAlignment(.center) {

            ModelView(name: "Earth")
                .frame(width: 300, height: 300)
                .debugBorder3D(showDebugLines ? .white : .clear)
            // Add an overlay view to the Earth model
                .spatialOverlay(alignment: alignment) {
                    VStack {
                        Text("Earth")
                            .font(.headline)
                    }
                    .padding()
                    .background(.black)
                    .cornerRadius(24)
                }

            ModelView(name: "Moon")
                .frame(width: 150, height: 150)
                .debugBorder3D(showDebugLines ? .white : .clear)
            // Add an overlay view to the Moon model
                .spatialOverlay(alignment: alignment) {
                    VStack {
                        Text("Luna")
                            .font(.headline)
                    }
                    .padding()
                    .background(.black)
                    .cornerRadius(24)
                }

        }


    }
}

#Preview {
    Example093()
}

// Adapted from Example 051 - Spatial SwiftUI: Model3D
fileprivate struct ModelView: View {

    @State var name: String = ""

    var body: some View {
        Model3D(named: name, bundle: realityKitContentBundle)
        { phase in
            if let model = phase.model {
                model
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if phase.error != nil {
                Text("Could not load model \(name).")
            } else {
                ProgressView()
            }
        }
    }
}

