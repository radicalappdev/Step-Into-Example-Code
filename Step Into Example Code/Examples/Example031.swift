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

                if let floorEntity = scene.findEntity(named: "FloorBox") {
                    if var anchor = floorEntity.components[AnchoringComponent.self] {
                        anchor.physicsSimulation = .none
                        floorEntity.components.set(anchor)
                    }
                    content.add(floorEntity)
                }


                if let leftHandSphere = scene.findEntity(named: "LeftHand") {

                    let leftHand = AnchorEntity(.hand(.left, location: .indexFingerTip),
                                                trackingMode: .continuous)
                    leftHand.addChild(leftHandSphere.clone(recursive: true))
                    leftHandSphere.position = .zero

                    leftHand.anchoring.physicsSimulation = .none
                    content.add(leftHand)

                }

            }

        }
        .task {
            await runTrackingSession()
        }
    }

    func runTrackingSession() async {

        let configuration = SpatialTrackingSession.Configuration(tracking: [.hand, .plane])

        let _ = await trackingSession.run(configuration)
    }


}
