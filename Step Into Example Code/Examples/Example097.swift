//  Step Into Vision - Example Code
//
//  Title: Example097
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 8/20/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example097: View {

    @State private var alignment: DepthAlignment = .front
    @State private var showDebugLines = false

    var body: some View {
        VStackLayout().depthAlignment(alignment) {

            HStackLayout().depthAlignment(alignment) {

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
                .manipulable()

                ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
                    .frame(width: 150, height: 150)
                    .debugBorder3D(showDebugLines ? .white : .clear)
                    .manipulable(coordinateSpace: .global)

            }

            HStackLayout().depthAlignment(alignment) {

                ModelViewSimple(name: "Moon", bundle: realityKitContentBundle)
                    .frame(width: 60, height: 60)
                    .debugBorder3D(showDebugLines ? .white : .clear)
                VStack {
                    Text("Luna")
                        .font(.title)
                    Text("Made amost entirely of cheese.")
                        .font(.caption)
                }
                .padding()
                .background(.black)
                .cornerRadius(24)
                .shadow(radius: 20)
                .frame(width: 180, height: 140)
            }

        }
        .debugBorder3D(showDebugLines ? .white : .clear)

        // Controls to modify the example
        .ornament(attachmentAnchor: .scene(.trailing), contentAlignment: .trailing, ornament: {
            VStack(alignment: .center, spacing: 8) {

                Button(action: {
                    showDebugLines.toggle()
                }, label: {
                    Text("Debug")
                })
            }
            .padding()
            .controlSize(.small)
            .glassBackgroundEffect()

        })

    }
}

#Preview {
    Example097()
}
