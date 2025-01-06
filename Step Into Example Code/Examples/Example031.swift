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

    @State var anchor: AnchoringComponent.Target.Classification = .table
    @State var session: SpatialTrackingSession?

    var body: some View {
        RealityView {content, attachments in

            let configuration = SpatialTrackingSession.Configuration(
                tracking: [.hand])
            let session = SpatialTrackingSession()
            await session.run(configuration)

            

            if let scene = try? await Entity(named: "AnchorLabs", in: realityKitContentBundle) {
                content.add(scene)

                if let subject = scene.findEntity(named: "ToyRocket") {

                    let anchorComponent = AnchoringComponent(
                        .plane(.any, classification: anchor, minimumBounds: SIMD2(x: 0.1, y: 0.1))
                    )
                    subject.components.set(anchorComponent)

                    _ = content.subscribe(to: SceneEvents.AnchoredStateChanged.self, { event in
                        print("anchor changed")
                        event.anchor.position = [0, 0.1, 0]

                    })
                }

            }

            if let panel = attachments.entity(for: "AttachmentContent") {
                panel.position = [-0.3, 1.2, -1]
                content.add(panel)
            }


        } update: { content, attachments in

            if let subject = content.entities.first?.findEntity(named: "ToyRocket") {

                let anchorComponent = AnchoringComponent(.plane(.any, classification: anchor, minimumBounds: SIMD2(x: 0.1, y: 0.1)))
                subject.setPosition([0,0,0], relativeTo: nil)
                subject.components.set(anchorComponent)


            }



        } attachments: {
            Attachment(id: "AttachmentContent") {
                VStack {
                    Button(action: {
                        anchor = .table
                    }, label: {
                        Text("Table")
                    })
                    Button(action: {
                        anchor = .wall
                    }, label: {
                        Text("Wall")
                    })
                }
                .padding()
                .glassBackgroundEffect()
            }
        }
    }
}
