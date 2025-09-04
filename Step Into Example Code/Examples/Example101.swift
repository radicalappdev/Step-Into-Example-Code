//  Step Into Vision - Example Code
//
//  Title: Example101
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 9/4/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example101: View {

    @State private var alignmentSign: Alignment3D = .init(horizontal: .center, vertical: .center, depth: .front)

    var body: some View {
        VStack {

            Spacer()

            ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
                .frame(width: 600, height: 600)
                .debugBorder3D(.white)

            // Add an overlay view to the Earth model
                .spatialOverlay(alignment: alignmentSign) {
                    VStack {
                        Text("Earth & Luna")
                            .font(.headline)
                    }
                    .padding()
                    .background(.black)
                    .cornerRadius(24)
                    .breakthroughEffect(.prominent)
                }
        }
        .ornament(attachmentAnchor: .scene(.trailing), ornament: {
            VStack {
                Button(action: {
                    withAnimation {
                        alignmentSign = .init(horizontal: .center, vertical: .center, depth: .front)
                    }
                }, label: {
                    Text("Center Front")
                })

                Button(action: {
                    withAnimation {
                        alignmentSign = .init(horizontal: .leading, vertical: .top, depth: .front)
                    }
                }, label: {
                    Text("Top Left Front")
                })

//                Button(action: {
//                    alignmentSign = .init(horizontal: .combineExplicit(.center, .trailing), vertical: .top, depth: .front)
//                }, label: {
//                    Text("Custom Front")
//                })

            }
            .frame(width: 200)
            .padding()
            .glassBackgroundEffect()
        })
    }
}

#Preview {
    Example101()
}
