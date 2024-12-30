//  Step Into Vision - Example Code
//
//  Title: Example025
//
//  Subtitle: Using Anchoring Component with Hands
//
//  Description: Creating entities with anchoring components attached instead of using AnchorEntity.
//
//  Type: Space
//
//  Created by Joseph Simpson on 12/30/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example025: View {
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
    Example025()
}
