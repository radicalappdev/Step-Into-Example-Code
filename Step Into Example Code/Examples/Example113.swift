//  Step Into Vision - Example Code
//
//  Title: Example113
//
//  Subtitle: Model3D: Getting Started
//
//  Description: Loading models from bundles and URLs. Showing progress views and errors.
//
//  Type: Window
//
//  Created by Joseph Simpson on 10/21/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example113: View {
    var body: some View {
        HStackLayout(spacing: 12).depthAlignment(.front) {

            // Demo 01: simply load a model
            VStackLayout(spacing: 12).depthAlignment(.front) {

                Model3D(named: "Moon", bundle: realityKitContentBundle) { model in
                    model
                        .resizable()
                        .scaledToFit3D()

                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)

                Text("Basic Model3D")
                    .font(.caption)
                    .padding()
                    .background(.black)
                    .clipShape(.capsule)
            }
            .offset(y: -50)

            // Demo 02: Using Model3DPhase to check progress and errors
            VStackLayout(spacing: 12).depthAlignment(.front) {
                Model3D(named: "ToyRocket", bundle: realityKitContentBundle) { phase in
                    if let model = phase.model {
                        model
                            .resizable()
                            .scaledToFit3D()
                    } else if phase.error != nil {
                        Text("Failed to load model")
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 150, height: 150)
                Text("Loading with Phase")
                    .font(.caption)
                    .padding()
                    .background(.black)
                    .clipShape(.capsule)
            }

            // Demo 03: Loading a model from a URL
            VStackLayout(spacing: 12).depthAlignment(.front) {
                Model3D(url: URL(string: "https://stepinto.vision/wp-content/uploads/2025/10/Earth.usdz")!) { phase in

                    if let model = phase.model {
                        model
                            .resizable()
                            .scaledToFit3D()
                    } else if phase.error != nil {
                        Text("Failed to load model")
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 150, height: 150)
                Text("Loading from a URL")
                    .font(.caption)
                    .padding()
                    .background(.black)
                    .clipShape(.capsule)
            }
            .offset(y: -50)

            // Demo 04: Forcing an error
            VStackLayout(spacing: 12).depthAlignment(.front) {
                // force an error by using a name for a model that does not exist
                Model3D(named: "NotFound", bundle: realityKitContentBundle) { phase in
                    if let model = phase.model {
                        model
                            .resizable()
                            .scaledToFit3D()
                    } else if phase.error != nil {
                        Text("Failed to load model")
                            .font(.caption)
                            .padding()
                            .background(.red)
                            .clipShape(.capsule)
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 150, height: 150)
                Text("Error Handling")
                    .font(.caption)
                    .padding()
                    .background(.black)
                    .clipShape(.capsule)
            }
        }
    }
}

#Preview {
    Example113()
}
