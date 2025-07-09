//  Step Into Vision - Example Code
//
//  Title: Example094
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 7/9/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example094: View {

    @State private var alignment: Alignment3D = .center
    @State private var showDebugLines = true
    
    var body: some View {
        HStackLayout().depthAlignment(.center) {

            // A container with a SwiftUI box and a 3D model
            SpatialContainer(alignment: alignment) {
                debugBorder3DView(showDebugLines ? .white : .clear)
                .frame(width: 200, height: 200)
                .frame(depth: 200)

                ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
                    .frame(width: 100, height: 100)
                    .debugBorder3D(showDebugLines ? .blue : .clear)
            }

            // A container with two 3D models
            SpatialContainer(alignment: alignment) {
                ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
                    .opacity(0.22)
                    .frame(width: 200, height: 200)
                    .debugBorder3D(showDebugLines ? .blue : .clear)

                ModelViewSimple(name: "Moon", bundle: realityKitContentBundle)
                    .frame(width: 100, height: 100)
                    .debugBorder3D(showDebugLines ? .green : .clear)
            }
            
        }
        // Controls to modify the example
        .ornament(attachmentAnchor: .scene(.trailing), contentAlignment: .trailing, ornament: {
            VStack(alignment: .center, spacing: 8) {
                Button(action: {
                    withAnimation {
                        alignment = .center
                    }
                }, label: {
                    Text("Demo 1")
                })
                Button(action: {
                    withAnimation {
                        alignment = .top
                    }
                }, label: {
                    Text("Demo 2")
                })
                Button(action: {
                    withAnimation {
                        alignment = .bottomLeadingFront
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
    Example094()
}
