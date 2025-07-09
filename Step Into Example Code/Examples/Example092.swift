//  Step Into Vision - Example Code
//
//  Title: Example092
//
//  Subtitle: Spatial SwiftUI: rotation3DLayout
//
//  Description: A rotation modifier that will impact frame and layout.
//
//  Type: Window
//
//  Created by Joseph Simpson on 7/7/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example092: View {

    @State private var alignment: DepthAlignment = .front
    @State private var showDebugLines = false

    @State private var angle: Angle = .degrees(0)

    var body: some View {
        VStackLayout().depthAlignment(alignment) {

            HStackLayout().depthAlignment(alignment) {

                ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
                    .frame(width: 150, height: 150)
                    .debugBorder3D(showDebugLines ? .blue : .clear)
                    .rotation3DEffect(angle, axis: .y)

                VStack {
                    Text("rotation3DEffect")
                        .font(.title)
                    Text("This will *not* impact the parent frame or layout.")
                        .font(.caption)
                }
                .padding()
                .background(.black)
                .cornerRadius(24)
                .shadow(radius: 20)
                .frame(width: 220, height: 160)

            }
            .debugBorder3D(showDebugLines ? .white : .clear)

            HStackLayout().depthAlignment(alignment) {

                ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
                    .frame(width: 150, height: 150)
                    .debugBorder3D(showDebugLines ? .green : .clear)
                    .rotation3DLayout(angle, axis: .y)

                VStack {
                    Text("rotation3DLayout")
                        .font(.title)
                    Text("This *will* impact the parent frame or layout.")
                        .font(.caption)
                }
                .padding()
                .background(.black)
                .cornerRadius(24)
                .shadow(radius: 20)
                .frame(width: 240, height: 160)

            }
            .debugBorder3D(showDebugLines ? .white : .clear)

            
        }
        .ornament(attachmentAnchor: .scene(.trailing), contentAlignment: .trailing, ornament: {
            VStack(alignment: .center, spacing: 8) {
                Button(action: {
                    withAnimation {
                        angle = .degrees(0)
                    }
                }, label: {
                    Text("Angle: 0")
                })

                Button(action: {
                    withAnimation {
                        angle = .degrees(45)
                    }
                }, label: {
                    Text("Angle: 45")
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
    Example092()
}
