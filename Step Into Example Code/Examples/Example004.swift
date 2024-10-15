//  Step Into Vision - Example Code
//
//  Title: Example004
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/15/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example004: View {

    @State var selected: String = ""

    var body: some View {
        RealityView { content in
            // Load the scene from the Reality Kit bindle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position.y = -0.4
            }
        }
        .ornament(attachmentAnchor: .scene(.back), ornament: {
            Text(selected)
                .font(.largeTitle)
                .padding(18)
                .background(.stepGreen)
                .cornerRadius(12)
                .opacity(selected.isEmpty ? 0 : 1)
        })
        .gesture(tapExample)
    }

    var tapExample: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                if(selected == value.entity.name) {
                    selected = ""
                } else {
                    selected = value.entity.name
                }
            }
    }
}

#Preview {
    Example004()
}
