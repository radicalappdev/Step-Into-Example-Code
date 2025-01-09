//  Step Into Vision - Example Code
//
//  Title: Example034
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/9/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example034: View {

    // 1. Create a session
    @State var trackingSession: SpatialTrackingSession = SpatialTrackingSession()

    @State var subject: Entity?

    @State var floor: Entity = {
        let entity = AnchorEntity(.plane(.horizontal, classification: .floor, minimumBounds: SIMD2(x: 0.1, y: 0.1)))
        entity.name = "FloorAnchorEntity"
        entity.components.set(InputTargetComponent())
        return entity
    }()

    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "AnchorLabsFloor", in: realityKitContentBundle) {
                content.add(scene)
                content.add(floor)

                if let subject = scene.findEntity(named: "StepSphereRed") {
                    subject.isEnabled = false

                    self.subject = subject

                }


                // We can listen for anchor state changes
                _ = content.subscribe(to: SceneEvents.AnchoredStateChanged.self)  { event in
                    print("**anchor changed** \(event)")
                    print("**anchor changed** \(event.anchor.name)")
                    print("**anchor changed** \(event.anchor)")
                }

                // place the panel
                if let panel = attachments.entity(for: "Panel") {
                    panel.position = [0, 1, -0.5]
                }
            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "Panel", {
                Button(action: {
                    if let newSubject = subject?.clone(recursive: true) {
                        newSubject.position = [-1, 2, -1]
                        newSubject.isEnabled = true
                    }
                }, label: {
                    Text("Spawn Sphere")
                })
            })
        }
        .modifier(DragGestureImproved()) // just here to let me grap the sphere if it gets too far away
        .task {
            await runTrackingSession()
        }
    }

    // 2. Configure and run the session
    func runTrackingSession() async {
        // We are using hand and plane anchors
        let configuration = SpatialTrackingSession.Configuration(tracking: [.plane])

        await trackingSession.run(configuration)
    }

}

#Preview {
    Example034()
}
