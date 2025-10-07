//  Step Into Vision - Example Code
//
//  Title: Example107
//
//  Subtitle:
//
//  Description:
//
//  Type:
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
            subjectA.name = "subjectB"
            subjectB.position.x = -0.15
            content.add(subjectB)

            willBegin = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                print("picked up \(event.entity.name)")
            }

            willRelease = content.subscribe(to: ManipulationEvents.WillRelease.self) { event in
                print("released up \(event.entity.name)")
            }



        }
        .onDisappear() {
            willBegin?.cancel()
            willBegin = nil
            willRelease?.cancel()
            willRelease = nil
        }
    }
}

#Preview {
    Example107()
}



