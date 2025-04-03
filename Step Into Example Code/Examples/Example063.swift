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

    @State var subjectEntity = Entity()

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "PhysicsMotionBasics", in: realityKitContentBundle) else { return }

            content.add(scene)

            if let subject = scene.findEntity(named: "Subject") {
                subjectEntity = subject
            }


        } update: { content in

        }

        .ornament(attachmentAnchor: .scene(.trailingFront), ornament: {
            VStack {
                Button(action:  {
                    if var motion = subjectEntity.components[PhysicsMotionComponent.self] {
                        let angularVelocity: SIMD3<Float> = SIMD3.random(in: 1...5)
                        motion.angularVelocity += angularVelocity
                        subjectEntity.components.set(motion)
                    }
                }, label: {
                    Label("Add angular velocity", systemImage: "rotate.3d")
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                Button(action:  {
                    if var motion = subjectEntity.components[PhysicsMotionComponent.self] {
                        let linearVelocity: SIMD3<Float> = SIMD3.random(in: 0.5...2.5)
                        motion.linearVelocity += linearVelocity
                        subjectEntity.components.set(motion)
                    }
                }, label: {
                    Label("Add linear velocity", systemImage: "move.3d")
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                Button(action:  {
                    if var motion = subjectEntity.components[PhysicsMotionComponent.self] {
                        // Reset the transform
                        var transformReset = Transform()
                        transformReset.translation = [0, 0.1, 0]
                        subjectEntity.transform = transformReset

                        // Remove any velocity 
                        motion.angularVelocity = .zero
                        motion.linearVelocity = .zero
                        subjectEntity.components.set(motion)


                    }
                }, label: {
                    Label("Reset all velocity", systemImage: "arrow.trianglehead.counterclockwise")
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
