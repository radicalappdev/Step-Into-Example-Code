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
    @State var subject = Entity()

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "WorldTracking", in: realityKitContentBundle) else { return }
            content.add(scene)

            if let placementEntity = scene.findEntity(named: "PlacementPreview") {
                placement = placementEntity
            }

            if let subjectEntity = scene.findEntity(named: "SubjectTemplate") {
                subjectEntity.isEnabled = false
                subject = subjectEntity
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
                        let anchor = WorldAnchor(originFromAnchorTransform: subject.transformMatrix(relativeTo: nil))
                        try await worldTracking.addAnchor(anchor)
                    }
                } else {
                    Task {
                        // Get the UUID we stored on the entity
                        let uuid = UUID(uuidString: value.entity.name) ?? UUID()
                        // if the UUID is in the worldAnchorEntities, remove it from the data provider
                        if let _ = worldAnchorEntities[uuid] {
                            try await worldTracking.removeAnchor(forID: uuid)
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
                    case .added, .updated:

                        let subjectClone = subject.clone(recursive: true)
                        subjectClone.isEnabled = true
                        subjectClone.name = update.anchor.id.uuidString
                        subjectClone.transform = Transform(matrix: update.anchor.originFromAnchorTransform)

                        worldAnchorEntities[update.anchor.id] = subjectClone
                        print("Anchor position updated. \(update.anchor.id)")

                    case .removed:

                        print("Anchor removed. \(update.anchor.id)")
                        worldAnchorEntities.removeValue(forKey: update.anchor.id)
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
