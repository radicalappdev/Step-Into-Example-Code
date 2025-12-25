//  Step Into Vision - Example Code
//
//  Title: Example138
//
//  Subtitle: RealityKit Basics: Entity Observation
//
//  Description: Starting in visionOS 26, we can observe changes to component data on entities.
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
    @State var observedPosition: SIMD3<Float> = .zero
    @State var observedWaypoint: String = "Not Set"

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

            // This scene uses a timeline to animate the subject around the scene.
            // We'll use this collision to update the custom component so we can observe changes from it
            collisionSubjectBegan = content
                .subscribe(to: CollisionEvents.Began.self, on: subject)  { collisionEvent in
                    subject.components[WaypointTracker.self]?.waypoint = collisionEvent.entityB.name
                    print("Waypoint Collision: \(subject.components[WaypointTracker.self]!.waypoint)")
                }
        }
        // Listen for changes, peform side effects, and apply the data to state
        .onChange(of: subject.observable.position) { _, newValue in
            // Apply any side effects here
            self.observedPosition = newValue
        }
        .onChange(of: subject.observable.components[WaypointTracker.self]?.waypoint) { _, newValue in
            if let newValue = newValue {
                // Apply any side effects here
                print("Observed Waypoint: \(newValue), applying side effects...")
                self.observedWaypoint = newValue
            }
        }
        .ornament(attachmentAnchor: .scene(.bottomFront), ornament: {
            VStack(alignment: .leading, spacing: 10) {
                // Example 1: Direct usage of the observed data in SwiftUI views
                Vector3Display(title: "Direct Usage", vector: subject.observable.position)

                HStack(spacing: 10) {
                    WaypointMap(waypoint: .constant(subject.observable.components[WaypointTracker.self]?.waypoint ?? "Not Found"))
                    Spacer(minLength: 0)
                }

                Divider()
                    .padding(.vertical, 2)

                // Example 2: Observing state that is updated using onChange
                Vector3Display(title: "onChange Examples", vector: observedPosition)

                HStack(spacing: 10) {
                    WaypointMap(waypoint: $observedWaypoint)
                    Spacer(minLength: 0)
                }
            }
            .padding()
            .background(.black)
            .clipShape(.rect(cornerRadius: 12))

        })
        .onDisappear {
            collisionSubjectBegan?.cancel()
            collisionSubjectBegan = nil
        }
    }
}

fileprivate struct WaypointMap: View {

    @Binding var waypoint: String

    private var symbolName: String {
        switch waypoint.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "left":
            return "circle.grid.cross.left.filled"
        case "right":
            return "circle.grid.cross.right.filled"
        case "front":
            return "circle.grid.cross.down.filled"
        case "back":
            return "circle.grid.cross.up.filled"
        default:
            return "questionmark.circle"
        }
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: symbolName)
                .font(.system(size: 22, weight: .semibold))
                .contentTransition(.symbolEffect(.replace))
                .animation(.easeInOut(duration: 0.25), value: symbolName)

            Text(waypoint)
                .font(.system(size: 14, weight: .medium, design: .rounded))
        }
    }
}

fileprivate struct WaypointTracker: Component, Codable {
    public var waypoint: String = "not set"
    public init() {}
}

#Preview {
    Example138()
}

