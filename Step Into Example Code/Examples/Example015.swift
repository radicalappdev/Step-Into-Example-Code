//  Step Into Vision - Example Code
//
//  Title: Example015
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 12/11/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example015: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "SpatialEventLab", in: realityKitContentBundle) {
                content.add(scene)

            }


        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .modifier(SpatialEventGestureExample())
    }

}

#Preview {
    Example015()
}

struct SpatialEventGestureExample: ViewModifier {

    @State var isDragging: Bool = false
    @State var initialPosition: SIMD3<Float> = .zero

    func body(content: Content) -> some View {
        content
            .gesture(
                SpatialEventGesture ()
                    .onChanged { events in
                        for event in events {
                            if event.phase == .active {
                                if (event.chirality == .left) {
                                    // move up and down
                                }
                                if (event.chirality == .right) {
                                    // move side to side
                                }

                            }
                        }
                    }

            )

    }
}
