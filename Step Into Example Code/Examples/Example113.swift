//  Step Into Vision - Example Code
//
//  Title: Example113
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/21/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example113: View {
    var body: some View {
        VStack {
            Model3D(named: "Earth", bundle: realityKitContentBundle)
            { phase in
                if let model = phase.model {
                    model
                        .resizable()
                        .scaledToFit3D()
                } else if phase.error != nil {
                    Text("Could not load model")
                        .font(.title)
                        .padding()
                        .glassBackgroundEffect()
                } else {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    Example113()
}
