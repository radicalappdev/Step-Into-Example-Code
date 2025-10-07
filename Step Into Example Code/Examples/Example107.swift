//  Step Into Vision - Example Code
//
//  Title: Example107
//
//  Subtitle: RealityKit Basics: Working with Events
//
//  Description: Our apps can respond to a number of scene and component events.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 10/7/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example107: View {

    @State private var sceneEventExample: EventSubscription?
    @State private var componentEventExample: EventSubscription?
    @State private var willBegin: EventSubscription?
    @State private var willRelease: EventSubscription?
    @State private var collisionBeganUnfiltered: EventSubscription?

    var body: some View {
        RealityView { content in

            // Scene Event Example
            sceneEventExample = content.subscribe(to: SceneEvents.DidAddEntity.self) { event in
                print("entity added to the scene! \(event.entity.name)")
            }

            // Component Event Example
            componentEventExample = content.subscribe(to: ComponentEvents.DidAdd.self) { event in
                print("component \(event.componentType) added to \(event.entity.name)")
            }

            let subjectA = createStepDemoBox()
            subjectA.name = "subjectA"
            subjectA.position.x = 0.15
            ManipulationComponent.configureEntity(subjectA, collisionShapes: [.generateBox(size: .init(repeating: 0.25))])
            content.add(subjectA)

            let subjectB = subjectA.clone(recursive: true)
            subjectB.name = "subjectB"
            subjectB.position.x = -0.15
            content.add(subjectB)

            // Manipulation Event Examples
            willBegin = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                print("picked up \(event.entity.name)")
            }

            willRelease = content.subscribe(to: ManipulationEvents.WillRelease.self) { event in
                print("released up \(event.entity.name)")
            }

            // Collision Event Example
            collisionBeganUnfiltered = content.subscribe(to: CollisionEvents.Began.self)  { collisionEvent in
                print("Collision between \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
            }


        }
        .onDisappear() {
            sceneEventExample?.cancel()
            sceneEventExample = nil
            componentEventExample?.cancel()
            componentEventExample = nil
            willBegin?.cancel()
            willBegin = nil
            willRelease?.cancel()
            willRelease = nil
            collisionBeganUnfiltered?.cancel()
            collisionBeganUnfiltered = nil
        }
    }
}

#Preview {
    Example107()
}



