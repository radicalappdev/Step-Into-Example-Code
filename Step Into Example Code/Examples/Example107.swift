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

    @State private var willBegin: EventSubscription?
    @State private var willRelease: EventSubscription?
    
    var body: some View {
        RealityView { content in

            let subjectA = createStepDemoBox()
            content.add(subjectA)

            subjectA.name = "subjectA"
            ManipulationComponent.configureEntity(subjectA, collisionShapes: [.generateBox(size: .init(repeating: 0.25))])
            content.add(subjectA)

            willBegin = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                print("picked up \(event.entity.name)")
            }

            willRelease = content.subscribe(to: ManipulationEvents.WillRelease.self) { event in
                print("released up \(event.entity.name)")
            }

        }
        .onDisappear() {
            willBegin?.cancel()
            willRelease?.cancel()
        }
    }
}

#Preview {
    Example107()
}
