//  Step Into Vision - Example Code
//
//  Title: Example031
//
//  Subtitle: How to set up Spatial Tracking Session
//
//  Description: Configure and run a Spatial Tracking Session in RealityKit.
//
//  Type: Space
//
//  Created by Joseph Simpson on 1/5/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example031: View {

    // 1. Create a session
    @State var trackingSession: SpatialTrackingSession = SpatialTrackingSession()

    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "AnchorLabs", in: realityKitContentBundle) {
                content.add(scene)

                // 3. FloorEntity has an anchoring component defined in Reality Composer Pro
                if let floorEntity = scene.findEntity(named: "FloorEntity") {
                    if var anchor = floorEntity.components[AnchoringComponent.self] {
                        // We need to clear the default physics simulation to let our sphere collide with this anchor
                        anchor.physicsSimulation = .none
                        floorEntity.components.set(anchor)
                    }
                }


                // 4. The hand anchor is created here, with the left hand sphere added as a child
                if let leftHandSphere = scene.findEntity(named: "LeftHand") {

                    let leftHand = AnchorEntity(.hand(.left, location: .indexFingerTip),
                                                trackingMode: .continuous)
                    leftHand.name = "LeftHandAnchor"
                    leftHand.addChild(leftHandSphere.clone(recursive: true))
                    leftHandSphere.position = .zero

                    leftHand.anchoring.physicsSimulation = .none
                    content.add(leftHand)

                }

                // 5. We can listen for anchor state changes
                _ = content.subscribe(to: SceneEvents.AnchoredStateChanged.self)  { event in
                    print("**anchor changed** \(event)")
                }
            }

        }
        .modifier(DragGestureImproved()) // just here to let me grap the sphere if it gets too far away
        .task {
            await runTrackingSession()
        }
    }

    // 2. Configure and run the session
    func runTrackingSession() async {
        // We are using hand and plane anchors
        let configuration = SpatialTrackingSession.Configuration(tracking: [.hand, .plane])

        await trackingSession.run(configuration)
    }

}
