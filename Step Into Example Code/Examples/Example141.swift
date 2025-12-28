//  Step Into Vision - Example Code
//
//  Title: Example141
//
//  Subtitle: Loading an Entity from Data
//
//  Description:
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/28/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example141: View {

    private let remoteURL = URL(string: "https://stepinto.vision/wp-content/uploads/2025/10/Earth.usdz")!
    
    var body: some View {
        RealityView { content in

            if let (data, response) = try? await URLSession.shared.data(from: remoteURL) {

                if let entity = try? await Entity(from: data) {
                    content.add(entity)
                }
            }
        }
        .realityViewLayoutBehavior(.centered)
    }
}

#Preview {
    Example141()
}
