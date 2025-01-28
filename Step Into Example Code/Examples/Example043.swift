//  Step Into Vision - Example Code
//
//  Title: Example043
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/28/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example043: View {
    var body: some View {
        RealityView { content in

            // Load a scene from the bundle
            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {

                content.add(scene)
                scene.position.y = -0.4

            }

        }
        .ornament(attachmentAnchor: .scene(.bottom)) {
            Example043Label(title: "Bottom")
        }
        .ornament(attachmentAnchor: .scene(.bottomBack)) {
            Example043Label(title: "BottomBack")
        }
        .ornament(attachmentAnchor: .scene(.bottomFront)) {
            Example043Label(title: "BottomFront")
        }
        .ornament(attachmentAnchor: .scene(.bottomLeading)) {
            Example043Label(title: "BottomLeading")
        }
        .ornament(attachmentAnchor: .scene(.bottomTrailing)) {
            Example043Label(title: "BottomTrailing")
        }
        .ornament(attachmentAnchor: .scene(.bottomFront)) {
            Example043Label(title: "BottomFront")
        }
        .ornament(attachmentAnchor: .scene(.bottomLeadingBack)) {
            Example043Label(title: "BottomLeadingBack")
        }
        .ornament(attachmentAnchor: .scene(.bottomLeadingFront)) {
            Example043Label(title: "BottomLeadingFront")
        }
        .ornament(attachmentAnchor: .scene(.bottomTrailingBack)) {
            Example043Label(title: "BottomTrailingBack")
        }
        .ornament(attachmentAnchor: .scene(.bottomTrailingFront)) {
            Example043Label(title: "BottomTrailingFront")
        }
        .ornament(attachmentAnchor: .scene(.top)) {
            Example043Label(title: "Top")
        }
        .ornament(attachmentAnchor: .scene(.topBack)) {
            Example043Label(title: "TopBack")
        }
        .ornament(attachmentAnchor: .scene(.topFront)) {
            Example043Label(title: "TopFront")
        }
        .ornament(attachmentAnchor: .scene(.topLeading)) {
            Example043Label(title: "TopLeading")
        }
        .ornament(attachmentAnchor: .scene(.topTrailing)) {
            Example043Label(title: "TopTrailing")
        }
        .ornament(attachmentAnchor: .scene(.topFront)) {
            Example043Label(title: "TopFront")
        }
        .ornament(attachmentAnchor: .scene(.topLeadingBack)) {
            Example043Label(title: "TopLeadingBack")
        }
        .ornament(attachmentAnchor: .scene(.topLeadingFront)) {
            Example043Label(title: "TopLeadingFront")
        }
        .ornament(attachmentAnchor: .scene(.topTrailingBack)) {
            Example043Label(title: "TopTrailingBack")
        }
        .ornament(attachmentAnchor: .scene(.topTrailingFront)) {
            Example043Label(title: "TopTrailingFront")
        }
        .ornament(attachmentAnchor: .scene(.center)) {
            Example043Label(title: "Center")
        }
        .ornament(attachmentAnchor: .scene(.front)) {
            Example043Label(title: "Front")
        }
        .ornament(attachmentAnchor: .scene(.back)) {
            Example043Label(title: "Back")
        }
        .ornament(attachmentAnchor: .scene(.leading)) {
            Example043Label(title: "Leading")
        }
        .ornament(attachmentAnchor: .scene(.trailing)) {
            Example043Label(title: "Trailing")
        }
        .ornament(attachmentAnchor: .scene(.leadingBack)) {
            Example043Label(title: "LeadingBack")
        }
        .ornament(attachmentAnchor: .scene(.trailingBack)) {
            Example043Label(title: "TrailingBack")
        }
        .ornament(attachmentAnchor: .scene(.leadingFront)) {
            Example043Label(title: "LeadingFront")
        }
        .ornament(attachmentAnchor: .scene(.trailingFront)) {
            Example043Label(title: "TrailingFront")
        }
    }
}

fileprivate struct Example043Label: View {
    var title = ""
    var body: some View {
        Text(title)
            .font(.title)
            .padding()
            .glassBackgroundEffect()
    }
}

#Preview {
    Example043()
}
