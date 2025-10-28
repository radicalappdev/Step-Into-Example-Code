//  Step Into Vision - Example Code
//
//  Title: Example115
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/26/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example115: View {
    var body: some View {
        HStackLayout(spacing: 12).depthAlignment(.front) {

            // Loading a model from the bundle
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

            // Loading a model from a URL
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
        }
    }
}
#Preview {
    Example115()
}
