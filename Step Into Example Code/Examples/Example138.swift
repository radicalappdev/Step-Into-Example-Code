//  Step Into Vision - Example Code
//
//  Title: Example138
//
//  Subtitle: RealityKit Basics: Entity Observation
//
//  Description:
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example138: View {

    @State var collisionSubjectBegan: EventSubscription?
    @State var subject = Entity()

    init() {
        WaypointTracker.registerComponent()
    }

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "EntityObservationDemo", in: realityKitContentBundle) else { return }
            content.add(scene)
            guard let subject = scene.findEntity(named: "Subject") else { return }
            subject.components.set(WaypointTracker())
            self.subject = subject



            collisionSubjectBegan = content
                .subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
                    print("Subject Collision \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                    subject.components[WaypointTracker.self]?.waypoint = collisionEvent.entityB.name
                    print("Waypoint: \(subject.components[WaypointTracker.self]!.waypoint)")
                }


        }
        .ornament(attachmentAnchor: .scene(.bottomFront), ornament: {
            VStack(alignment: .leading) {
                Vector3Display(title: "Position", vector: subject.observable.position)
                Text("Last Waypoint: \(subject.observable.components[WaypointTracker.self]?.waypoint ?? "Not Found")")
            }
            .padding()
            .background(.black)
            .clipShape(.rect(cornerRadius: 12))

        })
        .onDisappear() {
            collisionSubjectBegan?.cancel()
            collisionSubjectBegan = nil
        }
    }
}

#Preview {
    Example138()
}

fileprivate struct WaypointTracker: Component, Codable {

    public var waypoint: String = "not set"

    public init() {

    }
}
