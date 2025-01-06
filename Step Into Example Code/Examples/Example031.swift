//  Step Into Vision - Example Code
//
//  Title: Example031
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/5/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example031: View {

    @State var anchor: AnchoringComponent.Target.Classification = .wall

    var body: some View {
        RealityView {content, attachments in

            if let scene = try? await Entity(named: "AnchorLabs", in: realityKitContentBundle) {
                content.add(scene)

                if let subject = scene.findEntity(named: "CubeRed") {

                    let anchorComponent = AnchoringComponent(
                        .plane(.any, classification: anchor, minimumBounds: SIMD2(x: 1.0, y: 1.0))
                    )
                    subject.components.set(anchorComponent)

                }

                if let panel = attachments.entity(for: "AttachmentContent") {
                    panel.position = [-0.3, 1.2, -1]
                    content.add(panel)
                }
            }

        } update: { content, attachments in

            if let subject = content.entities.first?.findEntity(named: "CubeRed") {

                let anchorComponent = AnchoringComponent(.plane(.any, classification: anchor, minimumBounds: SIMD2(x: 1.0, y: 1.0)))
                subject.setPosition([0,0,0], relativeTo: nil)
                subject.components.set(anchorComponent)


            }

        } attachments: {
            Attachment(id: "AttachmentContent") {
                VStack {

                    Button(action: {
                        anchor = .ceiling
                    }, label: {
                        Text("Ceiling")
                    })

                    Button(action: {
                        anchor = .wall
                    }, label: {
                        Text("Wall")
                    })

                    Button(action: {
                        anchor = .floor
                    }, label: {
                        Text("Floor")
                    })
                }
                .padding()
                .glassBackgroundEffect()
            }
        }
    }
}
