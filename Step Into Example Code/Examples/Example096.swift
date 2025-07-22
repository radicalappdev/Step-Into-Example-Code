//  Step Into Vision - Example Code
//
//  Title: Example096
//
//  Subtitle: Spatial SwiftUI: scaling views
//
//  Description: We can use two convenient modifiers to scale views based on their parent size.
//
//  Type: Window
//
//  Created by Joseph Simpson on 7/22/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example096: View {

    @State private var showDebugLines = true
    @State private var frameDepth: CGFloat = 100.0

    var body: some View {
        HStackLayout(spacing: 24).depthAlignment(.front) {

            SpatialContainer(alignment: .bottomFront) {
                Model3D(named: "Earth", bundle: realityKitContentBundle)
                { phase in
                    if let model = phase.model {
                        model
                    } else if phase.error != nil {
                        Text("🌍")
                    } else {
                        ProgressView()
                    }
                }
                Card(title: "Unscaled")
            }
            .debugBorder3D(showDebugLines ? .white : .clear)
            .frame(width: 200, height: 200)

            SpatialContainer(alignment: .bottomFront) {
                Model3D(named: "Earth", bundle: realityKitContentBundle)
                { phase in
                    if let model = phase.model {
                        model
                            .resizable()
                            .scaledToFill3D()

                    } else if phase.error != nil {
                        Text("🌍")
                    } else {
                        ProgressView()
                    }
                }
                Card(title: "scaledToFill3D")
            }
            .debugBorder3D(showDebugLines ? .white : .clear)
            .frame(width: 200, height: 200)

            SpatialContainer(alignment: .bottomFront) {
                Model3D(named: "Earth", bundle: realityKitContentBundle)
                { phase in
                    if let model = phase.model {
                        model
                            .resizable()
                            .scaledToFit3D()

                    } else if phase.error != nil {
                        Text("🌍")
                    } else {
                        ProgressView()
                    }
                }
                Card(title: "scaledToFit3D")
            }
            .debugBorder3D(showDebugLines ? .white : .clear)
            .frame(width: 200, height: 200)

        }
        .frame(depth: frameDepth) // control the overall depth of the layout
        // Controls to modify the example
        .ornament(attachmentAnchor: .scene(.trailing), contentAlignment: .leading, ornament: {
            VStack(alignment: .center, spacing: 8) {
                Button(action: {
                    withAnimation {
                        frameDepth = 50.0
                    }
                }, label: {
                    Text("Demo 1")
                })
                Button(action: {
                    withAnimation {
                        frameDepth = 100.0
                    }
                }, label: {
                    Text("Demo 2")
                })
                Button(action: {
                    withAnimation {
                        frameDepth = 300.0
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

fileprivate struct Card: View {
    let title: String

    var body: some View {
        VStack {
            Text("\(title)")
                .font(.caption)
        }
        .padding(6)
        .background(.black)
        .cornerRadius(218)
    }
}

#Preview {
    Example096()
}
