//  Step Into Vision - Example Code
//
//  Title: Example028
//
//  Subtitle: Using Anchoring Component with Spatial Tracking Session
//
//  Description: We can add a Spatial Tracking Session if we need to use hand tracking features such as physics, collisions, and accessing transforms.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 1/1/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example028: View {

    @State var session: SpatialTrackingSession?
    @State var leftHandTransform: Transform?
    @State var leftHandIndexEntity: Entity?

    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "HandAnchoringLabs", in: realityKitContentBundle) {
                content.add(scene)

                // 1. Set up a Spatial Tracking Session with hand tracking.
                // This will add ARKit features to our Anchor Entities, enabling collisions.
                let configuration = SpatialTrackingSession.Configuration(
                    tracking: [.hand])
                let session = SpatialTrackingSession()
                await session.run(configuration)

                // Left Hand: An entity in Reality Composer Pro with an Anchoring Component.
                if let subject = scene.findEntity(named: "CollisionSubject"), let leftHandIndex = scene.findEntity(named: "LeftHandIndex"), let panel = attachments.entity(for: "AttachmentContent") {

                    var leftHandIndexAnchor = AnchoringComponent(
                        .hand(.left, location: .indexFingerTip)
                    )
                    // Disable the default physics simulation on the anchor to use collisions and physics
                    leftHandIndexAnchor.physicsSimulation = .none
                    leftHandIndex.components.set(leftHandIndexAnchor)
                    leftHandIndexEntity = leftHandIndex

                    _ = content.subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
                        print("Collision subject \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                        collisionEvent.entityA.components[ParticleEmitterComponent.self]?.burst()
                    }

                    // Also anchor the panel to the subject
                    subject.addChild(panel)
                    panel.setPosition([0, 0.2 ,0], relativeTo: subject)
                    panel.components[BillboardComponent.self] = .init()
                    

                }


                // Right Hand: Create an entity for each joint
                if let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {
                    // Create an array of all joints to iterate over.
                    let joints: [AnchoringComponent.Target.HandLocation.HandJoint] = [
                        .thumbTip,
                        .indexFingerTip,
                        .middleFingerTip,
                        .ringFingerTip,
                        .littleFingerTip
                    ]

                    for joint in joints {
                        let entity = rightHandSphere.clone(recursive: true)
                        var anchor = AnchoringComponent(
                            .hand(.right, location: .joint(for: joint)),
                            trackingMode: .continuous
                        )
                        // Disable the default physics simulation on the anchor to use collisions and physics
                        anchor.physicsSimulation = .none
                        entity.components.set(anchor)
                        content.add(entity)
                    }
                }

            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                VStack(alignment: .leading, spacing: 12) {
                    if let transform = leftHandTransform {
                        VectorDisplay(title: "Translation", vector: transform.translation)
                        VectorDisplay(title: "Scale", vector: transform.scale)
                        VStack(alignment: .leading) {
                            Text("Rotation \(transform.rotation.angle)")
                                .fontWeight(.bold)
                            VectorDisplay(title: "", vector: transform.rotation.axis)
                        }
                    } else {
                        Text("Hand not tracked")
                    }
                }
                .monospaced()
                .padding()
                .glassBackgroundEffect()
            }
        }

        .persistentSystemOverlays(.hidden)
        .upperLimbVisibility(.hidden)
        .task {
            while true {
                // 3. Periodically check the anchor transform and stash it in SwiftUi state.
                // This will update our attachment
                if let anchor = leftHandIndexEntity {
                    // anchor.transform does not work. This seems to be the anchored entity's transform relative to the anchor itself, which we are never changing.
                    // leftHandTransform = anchor.transform
                    // Instead we can access the anchors global transform
                    leftHandTransform = Transform(matrix: anchor.transformMatrix(relativeTo: nil))
                }
                try? await Task.sleep(for: .seconds(1/30))
            }

        }
    }
}

fileprivate struct VectorDisplay: View {
    let title: String
    let vector: SIMD3<Float>

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.bold)
            HStack {
                ForEach(["X", "Y", "Z"], id: \.self) { axis in
                    Text("\(axis): \(String(format: "%8.3f", axis == "X" ? vector.x : axis == "Y" ? vector.y : vector.z))")
                        .frame(width: 120, alignment: .leading)
                }
            }
        }
    }
}

#Preview {
    Example028()
}
