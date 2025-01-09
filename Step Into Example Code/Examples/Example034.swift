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

    @State var floor: AnchorEntity?

    var body: some View {
        RealityView { content, attachments in

            // Based on the setup in *RealityKitDrawingApp*
            let session = SpatialTrackingSession()
            let configuration = SpatialTrackingSession.Configuration(tracking: [.plane])
            _ = await session.run(configuration)
            self.trackingSession = session

            let floorAnchor = AnchorEntity(.plane(.horizontal, classification: .floor, minimumBounds: SIMD2(x: 0.1, y: 0.1)))
            floorAnchor.anchoring.physicsSimulation = .none
            floorAnchor.name = "FloorAnchorEntity"
            floorAnchor.components.set(InputTargetComponent())
            floorAnchor.components.set(CollisionComponent(shapes: .init()))
            content.add(floorAnchor)
            self.floor = floorAnchor

            if let scene = try? await Entity(named: "AnchorLabsFloor", in: realityKitContentBundle) {
                content.add(scene)

                if let subject = scene.findEntity(named: "StepSphereRed") {
                    self.subject = subject
                }


                // We can listen for anchor state changes
                _ = content.subscribe(to: SceneEvents.AnchoredStateChanged.self)  { event in
                    event.anchor.parent?.generateCollisionShapes(recursive: true)
                    event.anchor.generateCollisionShapes(recursive: true)
                    print("**anchor changed** \(event)")
                    print("**anchor changed** \(event.anchor.name)")
                    print("**anchor changed** \(event.anchor)")
                }

                // place the panel
                if let panel = attachments.entity(for: "Panel") {
                    panel.position = [0, 1, -0.5]
                    content.add(panel)
                }
            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "Panel", {
                Button(action: {
                    print("**button pressed**")
                    if let subject = self.subject {
                        subject.position = [-0.5, 1.5, -1.5]
                        // Remove the physics body and assign a new one - hack to remove momentum
                        if let physics = subject.components[PhysicsBodyComponent.self] {
                            subject.components.remove(PhysicsBodyComponent.self)
                            subject.components.set(physics)
                        }


                    }
                }, label: {
                    Text("Spawn Sphere")
                })
            })
        }
        .onDisappear {
            Task {
                await trackingSession.stop()
            }
        }
        .modifier(DragGestureImproved()) // just here to let me grap the sphere if it gets too far away

    }

}

#Preview {
    Example034()
}
