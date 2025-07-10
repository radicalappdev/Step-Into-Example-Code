//  Step Into Vision - Example Code
//
//  Title: Example095
//
//  Subtitle: Spatial SwiftUI: realityViewSizingBehavior
//
//  Description: A modifier that controls frame and alignment for RealityView.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 7/10/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example095: View {
    @State private var showDebugLines = true
    @State private var option: RealityViewLayoutOption = .flexible
    @State private var viewId = 0 // Counter to force view recreation

    var body: some View {
        VStack {
            Spacer()
            RealityView { content in
                guard let scene = try? await Entity(named: "SwiftUIScienceLab", in: realityKitContentBundle) else { return }
                content.add(scene)
            }
            .realityViewLayoutBehavior(option)
            .debugBorder3D(showDebugLines ? .green : .clear)
            .id(viewId) // Force recreation when viewId changes
        }
        .padding()
        .debugBorder3D(showDebugLines ? .white : .clear)

        // Controls to modify the example
        .ornament(attachmentAnchor: .scene(.trailingFront), contentAlignment: .leading, ornament: {
            VStack(alignment: .center, spacing: 8) {
                Button(action: {
                    withAnimation {
                        option = .flexible
                        viewId += 1
                    }
                }, label: {
                    Text("Flexible")
                })
                Button(action: {
                    withAnimation {
                        option = .centered
                        viewId += 1
                    }
                }, label: {
                    Text("Centered")
                })
                Button(action: {
                    withAnimation {
                        option = .fixedSize
                        viewId += 1
                    }
                }, label: {
                    Text("Fixed Size")
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
    Example095()
}
