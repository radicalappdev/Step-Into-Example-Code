//  Step Into Vision - Example Code
//
//  Title: Example103
//
//  Subtitle: Spatial SwiftUI: glassBackgroundEffect
//
//  Description: We can use this to add a glass background to any view.
//
//  Type: Window
//
//  Created by Joseph Simpson on 9/16/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example103: View {

    @State private var parentBackgroundFeathered: Bool = false
    @State private var parentBackgroundMode: GlassBackgroundDisplayMode = .always
    @State private var childrenBackgroundMode: GlassBackgroundDisplayMode = .implicit

    var alignment: DepthAlignment = .back

    var body: some View {

        /// Feathered Example
//        Text("Feathered Glass Background Effect")
//            .font(.extraLargeTitle)
//            .glassBackgroundEffect(.feathered(padding: 36, softEdgeRadius: 3), displayMode: .always)

        /// Clip Shape Example
//        Text("Moon")
//            .font(.extraLargeTitle)
//            .padding(48)
//            .glassBackgroundEffect(.plate, in: .circle, displayMode: .always)

        /// Layout Example
        VStackLayout().depthAlignment(alignment) {

            HStackLayout().depthAlignment(alignment) {

                earthCard

                ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
                    .frame(width: 150, height: 150)
                    .padding(6)
                    .glassBackgroundEffect(.automatic, displayMode: .implicit)

            }
            .padding()
            .glassBackgroundEffect(.automatic, displayMode: childrenBackgroundMode)

            HStackLayout().depthAlignment(alignment) {

                ModelViewSimple(name: "Moon", bundle: realityKitContentBundle)
                    .frame(width: 60, height: 60)
                    .padding(6)
                    .glassBackgroundEffect(.automatic, displayMode: .implicit)

                moonCard
            }
            .padding()
            .glassBackgroundEffect(.automatic, displayMode: childrenBackgroundMode)

        }
        .glassBackgroundEffect(.automatic, displayMode: parentBackgroundMode)

        // Controls to modify the example
        .ornament(attachmentAnchor: .scene(.trailing), contentAlignment: .trailing, ornament: {
            VStack(alignment: .center, spacing: 8) {
                Text("VStack")
                Button(action: {
                    parentBackgroundMode = .always
                }, label: {
                    Text("Always")
                })
                Button(action: {
                    parentBackgroundMode = .never
                }, label: {
                    Text("Never")
                })
                Text("HStacks")
                Button(action: {
                    childrenBackgroundMode = .implicit
                }, label: {
                    Text("Implicit")
                })

                Button(action: {
                    childrenBackgroundMode = .never
                }, label: {
                    Text("Never")
                })
            }
            .padding()
            .controlSize(.small)
            .glassBackgroundEffect()

        })

    }

    var earthCard: some View {
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
    }

    var moonCard: some View {
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

#Preview {
    Example103()
}
