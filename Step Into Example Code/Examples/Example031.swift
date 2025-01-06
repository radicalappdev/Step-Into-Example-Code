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

    @State var session: SpatialTrackingSession?

    var body: some View {
        RealityView {content, attachments in

            let configuration = SpatialTrackingSession.Configuration(
                tracking: [.hand])
            let session = SpatialTrackingSession()
            await session.run(configuration)

            

            if let scene = try? await Entity(named: "AnchorLabs", in: realityKitContentBundle) {
                content.add(scene)

                if let subject = scene.findEntity(named: "CubeRed") {

                    let anchorComponent = AnchoringComponent(
                        .plane(.any, classification: .wall, minimumBounds: SIMD2(x: 1.0, y: 1.0))
                    )
                    subject.components.set(anchorComponent)

                }

            }

        } update: { content, attachments in



        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("Testing")
            }
        }
    }
}
