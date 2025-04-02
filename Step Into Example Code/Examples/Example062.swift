//  Step Into Vision - Example Code
//
//  Title: Example062
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/2/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example062: View {

    @State var gravity: Float = 9.8

    @State var rootEntity: Entity?

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "PhysicsSimulationBasics", in: realityKitContentBundle) else { return }

            content.add(scene)
            scene.position.y = -0.4

            if let root = scene.findEntity(named: "Root") {
                rootEntity = root
                var simulation = PhysicsSimulationComponent()
                simulation.gravity = [0, 9.8, 0]
                root.components.set(simulation)
            }


        } update: { content in


            var simulation = PhysicsSimulationComponent()
            simulation.gravity = [0, gravity, 0]
            rootEntity?.components.set(simulation)

        }
        .ornament(attachmentAnchor: .scene(.trailingFront), ornament: {
            VStack {
                Button(action:  {
                    gravity = 9.8
                }, label: {
                    Label("Up Full", systemImage: "arrow.up")
                })
                Button(action:  {
                    gravity = 1.0
                }, label: {
                    Label("Up Weak", systemImage: "arrow.up")
                })
                Button(action:  {
                    gravity = -1.0
                }, label: {
                    Label("Down Weak", systemImage: "arrow.down")
                })

                Button(action:  {
                    gravity = -9.8
                }, label: {
                    Label("Down Full", systemImage: "arrow.down")
                })
            }
            .padding()
            .glassBackgroundEffect()
        })
    }
}

#Preview {
    Example062()
}
