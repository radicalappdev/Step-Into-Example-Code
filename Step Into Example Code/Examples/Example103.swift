//  Step Into Vision - Example Code
//
//  Title: Example103
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 9/16/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example103: View {

    @State private var alignment: DepthAlignment = .back
    @State private var showDebugLines = false

    @State private var parentBackgroundMode: GlassBackgroundDisplayMode = .always
    @State private var childrenBackgroundMode: GlassBackgroundDisplayMode = .implicit

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

                // The largest view in this scene, all other content will align to this
                ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
                    .frame(width: 150, height: 150)
                    .debugBorder3D(showDebugLines ? .white : .clear)

            }
            .padding()
            .glassBackgroundEffect(.automatic, displayMode: childrenBackgroundMode)

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
            .padding()
            .glassBackgroundEffect(.automatic, displayMode: childrenBackgroundMode)

        }
        .debugBorder3D(showDebugLines ? .white : .clear)
        .glassBackgroundEffect(.automatic, displayMode: parentBackgroundMode)

        // Controls to modify the example
        .ornament(attachmentAnchor: .scene(.trailing), contentAlignment: .trailing, ornament: {
            VStack(alignment: .center, spacing: 8) {
                Button(action: {
                    withAnimation {
                        alignment = .back
                    }
                }, label: {
                    Text("Back")
                })
                Button(action: {
                    withAnimation {
                        alignment = .center
                    }
                }, label: {
                    Text("Center")
                })
                Button(action: {
                    withAnimation {
                        alignment = .front
                    }
                }, label: {
                    Text("Front")
                })

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
    Example103()
}
