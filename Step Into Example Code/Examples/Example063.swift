//  Step Into Vision - Example Code
//
//  Title: Example063
//
//  Subtitle: Collisions & Physics: Hello Physics Motion Component
//
//  Description: We can use this component to read or write angular and linear velocity.
//
//  Type:
//
//  Created by Joseph Simpson on 4/3/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example063: View {

//    @State var angularVelocity: SIMD3<Float> = [0, 0, 0]
//    @State var linearVelocity: SIMD3<Float> = [0, 0, 0]

    @State var testAngularVelocity = false
    @State var testLinearVelocity = false

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "PhysicsMotionBasics", in: realityKitContentBundle) else { return }

            content.add(scene)


        } update: { content in

            if let subject = content.entities.first?.findEntity(named: "Subject") {

                if var motion = subject.components[PhysicsMotionComponent.self] {

                    print(motion.angularVelocity)

                    if (testAngularVelocity) {
                        let angularVelocity: SIMD3<Float> = SIMD3.random(in: 1...5)
                        motion.angularVelocity += angularVelocity
                    }

                    if (testLinearVelocity) {
                        let linearVelocity: SIMD3<Float> = SIMD3.random(in: -0.5...0.5)
                        motion.linearVelocity += linearVelocity
                    }

                    subject.components.set(motion)
                }

            }

        }

        .ornament(attachmentAnchor: .scene(.trailingFront), ornament: {
            VStack {
                Button(action:  {
                    testAngularVelocity.toggle()
                }, label: {
                    Label("Add angular velocity", systemImage: "rotate.3d")
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                Button(action:  {
                    testLinearVelocity.toggle()
                }, label: {
                    Label("Add linear velocity", systemImage: "move.3d")
                        .frame(maxWidth: .infinity, alignment: .leading)
                })

            }
            .padding()
            .glassBackgroundEffect()
        })
    }
}

#Preview {
    Example063()
}
