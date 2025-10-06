//  Step Into Vision - Example Code
//
//  Title: Example106
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/6/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example106: View {

    @State private var subjectToggle = false

    // See "Better together: SwiftUI and RealityKit" WWDC 2025
    var animatedIsOffset: Binding<Bool> {
        $subjectToggle
            .animation(.easeInOut(duration: 2))
    }

    @State private var willBegin: EventSubscription?
    @State private var willRelease: EventSubscription?

    var body: some View {
        GeometryReader3D { proxy in


            RealityView { content in

                _ = content.subscribe(to: ComponentEvents.DidAdd.self) { event in
                    print("added component \(event.componentType)")
                }
                // Add two entities
                let subjectA = createStepDemoBox()
                content.add(subjectA)

                let subjectB = createStepDemoBox()
                subjectB.name = "subjectB"
                ManipulationComponent.configureEntity(subjectB, collisionShapes: [.generateBox(size: .init(repeating: 0.25))])
                content.add(subjectB)


                print(content.entities) // includes both entities
                content.remove(subjectA)
                print(content.entities) // includes only subjectB


                willBegin = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                    print("picked up \(event.entity.name)")
                }

                willRelease = content.subscribe(to: ManipulationEvents.WillRelease.self) { event in
                    print("released up \(event.entity.name)")
                }


            } update: { content in
                if let subjectB = content.entities.first?.findEntity(named: "subjectB") {

                    //                content.animate {
                    //                    let scaler: Float = subjectToggle ? 2.0 : 1.0
                    //                    subjectB.scale = .init(repeating: scaler)
                    //                }

                    content.animate(body: {
                        let scaler: Float = subjectToggle ? 2.0 : 1.0
                        subjectB.scale = .init(repeating: scaler)
                    }, completion: {
                        print("animation done")
                    })
                }

                let newFrame = content.convert(proxy.frame(in: .global), from: .global, to: .scene)
                print("volume bounds in scene: \(newFrame.min.x), \(newFrame.min.y), \(newFrame.min.z) - \(newFrame.max.x), \(newFrame.max.y), \(newFrame.max.z)")

            }
        }
        .onDisappear() {
            willBegin?.cancel()
            willRelease?.cancel()
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                Toggle(isOn: animatedIsOffset, label: {
                    Text("Toggle Subject")
                })
            })
        }
    }
}

#Preview {
    Example106()
}


