//  Step Into Vision - Example Code
//
//  Title: Example092
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 7/7/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example092: View {

    @State private var alignment: DepthAlignment = .front
    @State private var showDebugLines = true

    @State private var angle: Angle = .degrees(24)

    var body: some View {
        VStackLayout().depthAlignment(alignment) {

            HStackLayout().depthAlignment(alignment) {

                ModelView(name: "Earth")
                    .frame(width: 150, height: 150)
                    .debugBorder3D(showDebugLines ? .blue : .clear)
                    .rotation3DEffect(angle, axis: .y)

                VStack {
                    Text("rotation3DEffect")
                        .font(.title)
                    Text("This will *not* impact the parent frame or layout.")
                        .font(.caption)
                }
                .padding()
                .background(.black)
                .cornerRadius(24)
                .shadow(radius: 20)
                .frame(width: 220, height: 160)

            }
            .debugBorder3D(showDebugLines ? .white : .clear)

            HStackLayout().depthAlignment(alignment) {

                ModelView(name: "Earth")
                    .frame(width: 150, height: 150)
                    .debugBorder3D(showDebugLines ? .green : .clear)
                    .rotation3DLayout(angle, axis: .y)

                VStack {
                    Text("rotation3DLayout")
                        .font(.title)
                    Text("This *will* impact the parent frame or layout.")
                        .font(.caption)
                }
                .padding()
                .background(.black)
                .cornerRadius(24)
                .shadow(radius: 20)
                .frame(width: 240, height: 160)

            }
            .debugBorder3D(showDebugLines ? .white : .clear)

            
        }

    }
}

#Preview {
    Example092()
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
