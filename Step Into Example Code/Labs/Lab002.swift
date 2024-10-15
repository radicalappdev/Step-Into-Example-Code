//  Step Into Vision - Labs
//
//  Title: Lab002
//
//  Subtitle: Example of a 3D Volume
//
//  Description: Testing out the volume
//
//  Type: Volume
//
//  Created by Joseph Simpson on 10/3/24.

import SwiftUI
import RealityKit

struct Lab002: View {
    var body: some View {
        RealityView { content in
            let model = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .black, isMetallic: false)])
            content.add(model)
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                Text("A Volume")
                    .font(.title)
            })
        }
    }
}

#Preview {
    Lab002()
}
