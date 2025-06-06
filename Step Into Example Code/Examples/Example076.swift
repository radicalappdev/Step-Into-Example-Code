//  Step Into Vision - Example Code
//
//  Title: Example076
//
//  Subtitle: Placing an entity on a wall using Anchoring Component
//
//  Description: We can use Anchoring Component to describe anchors that RealityKit should track.
//
//  Type: Space
//
//  Created by Joseph Simpson on 4/23/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example076: View {
    var body: some View {
        RealityView { content in

            // Load the asset that we'll use to render the portal
            guard let scene = try? await Entity(named: "PortalFrame", in: realityKitContentBundle) else { return }
            content.add(scene)

            // Load the scene that will serve as the content for the portal
            guard let portalContent = try? await Entity(named: "PortalFrameContent", in: realityKitContentBundle) else { return }
            portalContent.components.set(WorldComponent())
            scene.addChild(portalContent)

            // Get the frame entity
            guard let frame = scene.findEntity(named: "picture_frame_02") else { return }

            // Create an anchor target and AnchoringComponent. Add the component to the frame entity
            let anchorTarget = AnchoringComponent.Target.plane(.vertical, classification: .wall, minimumBounds: [1, 1])
            let anchoringComponent = AnchoringComponent(anchorTarget)
            frame.components.set(anchoringComponent)

            // Rotate the frame to align with the wall
            frame.setOrientation(.init(angle: .pi / 2, axis: [-1, 0, 0]), relativeTo: nil)

            // Set up the portal
            guard let portalEntity = scene.findEntity(named: "portal_entity") else { return }
            portalEntity.components[ModelComponent.self]?.materials[0] = PortalMaterial()
            portalEntity.components.set(PortalComponent(target: portalContent))

        }
    }
}

#Preview {
    Example076()
}
