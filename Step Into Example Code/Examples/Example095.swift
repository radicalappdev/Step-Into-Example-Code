//  Step Into Vision - Example Code
//
//  Title: Example095
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 7/10/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example095: View {
    @State private var showDebugLines = true
    @State private var option: RealityViewLayoutOption = .fixedSize
    var body: some View {
        VStack {
            Spacer()
            RealityView { content in
                guard let scene = try? await Entity(named: "SwiftUIScienceLab", in: realityKitContentBundle) else { return }
                content.add(scene)

            }
            .realityViewLayoutBehavior(option)
            .debugBorder3D(showDebugLines ? .green : .clear)
        }
        .padding()
        .debugBorder3D(showDebugLines ? .white : .clear)

        // Controls to modify the example
        .ornament(attachmentAnchor: .scene(.trailing), contentAlignment: .leading, ornament: {
            VStack(alignment: .center, spacing: 8) {
                Button(action: {
                    withAnimation {
                        option = .flexible

                    }
                }, label: {
                    Text("Demo 1")
                })
                Button(action: {
                    withAnimation {
                        option = .centered

                    }
                }, label: {
                    Text("Demo 2")
                })
                Button(action: {
                    withAnimation {
                        option = .fixedSize


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
    Example095()
}
