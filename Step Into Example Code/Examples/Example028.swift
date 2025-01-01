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
    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "HandAnchoringLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Left Hand: Three small spheres were created in Reality Composer Pro. Each one has an Anchoring Component.

                // Right Hand: Create an entity for each joint
                if let rightHandSphere = scene.findEntity(named: "StepSphereGreen") {
                    // Create an array of all joints to iterate over.
                    let joints: [AnchoringComponent.Target.HandLocation.HandJoint] = [
                        .thumbIntermediateBase,
                        .thumbIntermediateTip,
                        .thumbKnuckle,
                        .thumbTip,
                        .indexFingerIntermediateBase,
                        .indexFingerIntermediateTip,
                        .indexFingerKnuckle,
                        .indexFingerMetacarpal,
                        .indexFingerTip,
                        .middleFingerIntermediateBase,
                        .middleFingerIntermediateTip,
                        .middleFingerKnuckle,
                        .middleFingerMetacarpal,
                        .middleFingerTip,
                        .ringFingerIntermediateBase,
                        .ringFingerIntermediateTip,
                        .ringFingerKnuckle,
                        .ringFingerMetacarpal,
                        .ringFingerTip,
                        .littleFingerIntermediateBase,
                        .littleFingerIntermediateTip,
                        .littleFingerKnuckle,
                        .littleFingerMetacarpal,
                        .littleFingerTip,
                    ]

                    for joint in joints {
                        let entity = rightHandSphere.clone(recursive: true)
                        let anchor = AnchoringComponent(
                            .hand(.right, location: .joint(for: joint)),
                            trackingMode: .continuous
                        )
                        entity.components.set(anchor)
                        content.add(entity)
                    }
                }

            }

        }
        .persistentSystemOverlays(.hidden)
        .upperLimbVisibility(.hidden)
    }
}

#Preview {
    Example028()
}
