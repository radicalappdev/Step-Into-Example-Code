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

    @State var gravity: SIMD3<Float> = [0, 9.8, 0]


    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "PhysicsSimulationBasics", in: realityKitContentBundle) else { return }

            content.add(scene)
            scene.position.y = -0.4

            if let root = scene.findEntity(named: "Root") {
                var simulation = PhysicsSimulationComponent()
                simulation.gravity = gravity
                root.components.set(simulation)

            }


        } update: { content in
            // Update the simulation gravity when the value changes
            var simulation = PhysicsSimulationComponent()
            simulation.gravity = gravity
            content.entities.first?.findEntity(named: "Root")?.components.set(simulation)


        }
        .ornament(attachmentAnchor: .scene(.trailingFront), ornament: {
            VStack {
                Button(action:  {
                    gravity = [0, 9.81, 0]
                }, label: {
                    Label("Up Strong", systemImage: "chevron.up.2")
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                Button(action:  {
                    gravity = [0, 1, 0]
                }, label: {
                    Label("Up Weak", systemImage: "chevron.up")
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                Button(action:  {
                    gravity = [0, -1, 0]
                }, label: {
                    Label("Down Weak", systemImage: "chevron.down")
                        .frame(maxWidth: .infinity, alignment: .leading)
                })

                Button(action:  {
                    gravity = [0, -9.81, 0]
                }, label: {
                    Label("Down Strong", systemImage: "chevron.down.2")
                        .frame(maxWidth: .infinity, alignment: .leading)
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
