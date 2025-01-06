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

    @State var trackingSession: SpatialTrackingSession = SpatialTrackingSession()

    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "AnchorLabs", in: realityKitContentBundle) {
                content.add(scene)

                if let subject = scene.findEntity(named: "CubeRed") {

                }
            }

        }
        .task {
            await runTrackingSession()
        }
    }

    func runTrackingSession() async {

        let configuration = SpatialTrackingSession.Configuration(tracking: [.plane])


        let _ = await trackingSession.run(configuration)
    }


}
