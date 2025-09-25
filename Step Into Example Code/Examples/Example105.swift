//  Step Into Vision - Example Code
//
//  Title: Example105
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 9/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example105: View {

    let frameSize: CGFloat = 100

    var body: some View {
        VStackLayout().depthAlignment(.center) {
            HStackLayout().depthAlignment(.center) {

                VStack {
                    Text("manipulable()")
                        .font(.title)
                    Text("Default implementation")
                        .font(.caption)
                }
                .padding()
                .background(.black)
                .cornerRadius(24)
                .shadow(radius: 20)
                .frame(width: 220, height: 160)
                .manipulable()

                ModelViewSimple(name: "ToyCar", bundle: realityKitContentBundle)
                    .frame(width: frameSize, height: frameSize)
                    .manipulable()

                ModelViewSimple(name: "ToyRocket", bundle: realityKitContentBundle)
                    .frame(width: frameSize, height: frameSize)
                    .manipulable()

                ModelViewSimple(name: "ToyBiplane", bundle: realityKitContentBundle)
                    .frame(width: frameSize, height: frameSize)
                    .manipulable()

            }

            HStackLayout().depthAlignment(.center) {
                ModelViewSimple(name: "ToyCar", bundle: realityKitContentBundle)
                    .frame(width: frameSize, height: frameSize)
                    .manipulable()

                ModelViewSimple(name: "ToyRocket", bundle: realityKitContentBundle)
                    .frame(width: frameSize, height: frameSize)
                    .manipulable()

                ModelViewSimple(name: "ToyBiplane", bundle: realityKitContentBundle)
                    .frame(width: frameSize, height: frameSize)
                    .manipulable()

            }
            
        }
    }
}

#Preview {
    Example105()
}
