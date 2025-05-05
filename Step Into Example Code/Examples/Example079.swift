//  Step Into Vision - Example Code
//
//  Title: Example079
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/28/25.

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct Example079: View {
    @State var session = ARKitSession()
    @State var worldTracking = WorldTrackingProvider()

    @State var worldAnchorEntities: [UUID: Entity] = [:]

    @State var placement = Entity()

    @State var subject : ModelEntity = {
        let subject = ModelEntity(
            mesh: .generateSphere(radius: 0.06),
            materials: [SimpleMaterial(color: .stepRed, isMetallic: false)])
        subject.setPosition([0, 0, 0], relativeTo: nil)

        let collision = CollisionComponent(shapes: [.generateSphere(radius: 0.06)])
        let input = InputTargetComponent()
        subject.components.set([collision, input])

        return subject
    }()

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "WorldTracking", in: realityKitContentBundle) else { return }
            content.add(scene)

            if let placementEntity = scene.findEntity(named: "PlacementPreview") {
                placement = placementEntity
            }

        } update: { content in
            for (_, entity) in worldAnchorEntities {
                if !content.entities.contains(entity) {
                    content.add(entity)
                }
            }
        }
        .modifier(DragGestureImproved())
        .gesture(tapGesture)
        .task {
            try! await setupAndRunWorldTracking()
        }
    }

    var tapGesture: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in

                if value.entity.name == "PlacementPreview" {
                    // If we tapped the placement preview cube, create an anchor
                    Task {
                        let anchor = WorldAnchor(originFromAnchorTransform: value.entity.transformMatrix(relativeTo: nil))
                        try await worldTracking.addAnchor(anchor)
                    }
                } else {
                    Task {
                        // Get the UUID we stored on the entity
                        let uuid = UUID(uuidString: value.entity.name) ?? UUID()

                        do {
                            try await worldTracking.removeAnchor(forID: uuid)
                        } catch {
                            print("Failed to remove world anchor \(uuid) with error: \(error).")
                        }

                    }
                }
            }
    }

    func setupAndRunWorldTracking() async throws {

        if WorldTrackingProvider.isSupported {
            do {
                try await session.run([worldTracking])

                for await update in worldTracking.anchorUpdates {
                    switch update.event {
                    case .added:

                        let subjectClone = subject.clone(recursive: true)
                        subjectClone.isEnabled = true
                        subjectClone.name = update.anchor.id.uuidString
                        subjectClone.transform = Transform(matrix: update.anchor.originFromAnchorTransform)

                        worldAnchorEntities[update.anchor.id] = subjectClone
                        print("🟢 Anchor added \(update.anchor.id)")

                    case .updated:

                        guard let entity = worldAnchorEntities[update.anchor.id] else {
                            print("No entity found to update for anchor \(update.anchor.id)")
                            return
                        }

                        entity.transform = Transform(matrix: update.anchor.originFromAnchorTransform)

                        print("🔵 Anchor updated \(update.anchor.id)")

                    case .removed:

                        worldAnchorEntities[update.anchor.id]?.removeFromParent()
                        worldAnchorEntities.removeValue(forKey: update.anchor.id)
                        print("🔴 Anchor removed \(update.anchor.id)")

                        if let remainingAnchors = await worldTracking.allAnchors {
                            print("Remaining Anchors: \(remainingAnchors.count)")
                        }
                    }
                }
            } catch {
                print("ARKit session error \(error)")
            }
        }

    }
}



#Preview {
    Example079()
}


