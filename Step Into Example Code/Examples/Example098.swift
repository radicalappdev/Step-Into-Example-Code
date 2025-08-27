//  Step Into Vision - Example Code
//
//  Title: Example098
//
//  Subtitle: Spatial SwiftUI: Breakthrough Effect
//
//  Description: We can use this new modifier to keep content visible even when it is blocked other views or content.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 8/27/25.

import SwiftUI
import RealityKit
import RealityKitContent


struct Example098: View {

    @State private var effect: BreakthroughEffect = .none

    var body: some View {
        VStack {
            Spacer()
            SpatialContainer {
                ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
                    .frame(width: 400, height: 400)
                    .manipulable()

                VStack {
                    Text("Earth")
                        .font(.title)
                    Text("The only known planet known to serve ice cream.")
                        .font(.caption)
                }
                .padding()
                .background(.black)
                .cornerRadius(24)
                .shadow(radius: 20)
                .frame(width: 220, height: 160)
                .breakthroughEffect(effect)

            }
        }
        // Controls to modify the example
        .ornament(attachmentAnchor: .scene(.bottomTrailing), contentAlignment: .bottomTrailing, ornament: {
            VStack(alignment: .center, spacing: 8) {
                Button(action: {
                    withAnimation {
                        effect = .none
                    }
                }, label: {
                    Text("None")
                })
                Button(action: {
                    withAnimation {
                        effect = .subtle
                    }
                }, label: {
                    Text("Subtle")
                })
                Button(action: {
                    withAnimation {
                        effect = .prominent
                    }
                }, label: {
                    Text("Prominent")
                })

            }
            .padding()
            .controlSize(.extraLarge)
            .glassBackgroundEffect()

        })
    }
}
