//  Step Into Vision - Example Code
//
//  Title: Example093
//
//  Subtitle: Spatial SwiftUI: spatialOverlay
//
//  Description: We can add secondary content within the bounds of views.
//
//  Type: Window
//
//  Created by Joseph Simpson on 7/8/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example093: View {

    @State private var alignmentSign: Alignment3D = .bottomFront
    @State private var alignmentMoon: Alignment3D = .topLeading
    @State private var showDebugLines = true

    var body: some View {

        HStackLayout().depthAlignment(.center) {

            ModelView(name: "Earth")
                .frame(width: 260, height: 260)
                .debugBorder3D(showDebugLines ? .white : .clear)
            // Add an overlay view to the Earth model
                .spatialOverlay(alignment: alignmentSign) {
                    VStack {
                        Text("Earth & Luna")
                            .font(.headline)
                    }
                    .padding()
                    .background(.black)
                    .cornerRadius(24)
                }
            // Add some padding after the first overlay to create some space around the first example
                .padding(36)
                .debugBorder3D(showDebugLines ? .white : .clear)
            // Add a second spatial overlay to place the moon model
                .spatialOverlay(alignment: alignmentMoon) {
                    ModelView(name: "Moon")
                        .frame(width: 60, height: 60)
                }

        }
        // Controls to modify the example
        .ornament(attachmentAnchor: .scene(.trailing), contentAlignment: .trailing, ornament: {
            VStack(alignment: .center, spacing: 8) {
                Button(action: {
                    withAnimation {
                        alignmentSign = .topTrailingFront
                        alignmentMoon = .bottomLeading
                    }
                }, label: {
                    Text("Demo 1")
                })
                Button(action: {
                    withAnimation {
                        alignmentSign = .front
                        alignmentMoon = .trailingFront
                    }
                }, label: {
                    Text("Demo 2")
                })
                Button(action: {
                    withAnimation {
                        alignmentSign = .bottomLeadingFront
                        alignmentMoon = .topLeadingBack
                    }
                }, label: {
                    Text("Demo 3")
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
    Example093()
}

// Adapted from Example 051 - Spatial SwiftUI: Model3D
fileprivate struct ModelView: View {

    @State var name: String = ""

    var body: some View {
        Model3D(named: name, bundle: realityKitContentBundle)
        { phase in
            if let model = phase.model {
                model
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if phase.error != nil {
                Text("Could not load model \(name).")
            } else {
                ProgressView()
            }
        }
    }
}


