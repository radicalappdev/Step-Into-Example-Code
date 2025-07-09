//  Step Into Vision - Example Code
//
//  Title: Example091
//
//  Subtitle: Spatial SwiftUI: Layout Depth Alignment
//
//  Description: We can use `.depthAlignment` to align views in a 3D space.
//
//  Type: Window
//
//  Created by Joseph Simpson on 7/6/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example091: View {

    @State private var alignment: DepthAlignment = .back
    @State private var showDebugLines = false

    var body: some View {
        // We'll use depthAlignment on the VStackLayout to align all child views
        VStackLayout().depthAlignment(alignment) {

            // Using depthAlignment here will align the SwiftUI card with the Earth model
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

            // Using depthAlignment here will align the SwiftUI card with the Moon model
            // The moon is set to a smaller size than the earth. The alighment for this HStackLayout is controled by the parent
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
    Example091()
}



