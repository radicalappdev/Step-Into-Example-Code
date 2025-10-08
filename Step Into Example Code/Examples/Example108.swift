//  Step Into Vision - Example Code
//
//  Title: Example108
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/8/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example108: View {

    @State private var location: UnitPoint3D?

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "ToyRocket", in: realityKitContentBundle) else { return }
            content.add(scene)

        } update: { content in


            if let location = location, let rocket = content.entities.first {
                
            }


        }
        .debugBorder3D(.white)
        .ornament(attachmentAnchor: .scene(.bottomLeadingFront), contentAlignment: .bottomLeadingFront, ornament: {
            Button(action: {
                location = .bottomLeadingFront
                print("bottomLeadingFront activated")
            }, label: {
                Image(systemName: "target")
            })
            .rotation3DEffect(.degrees(90), axis: .x)
        })


    }
}

#Preview {
    Example108()
}
