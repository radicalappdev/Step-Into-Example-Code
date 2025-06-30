//  Step Into Vision - Example Code
//
//  Title: Example087
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 6/30/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example087: View {

    @State private var releaseBehavior: ManipulationComponent.ReleaseBehavior = .reset
    @State private var translationBehavior: ManipulationComponent.Dynamics.TranslationBehavior = .unconstrained
    @State private var rotationBehaviorPrimary: ManipulationComponent.Dynamics.RotationBehavior = .unconstrained
    @State private var rotationBehaviorSecondary: ManipulationComponent.Dynamics.RotationBehavior = .unconstrained
    @State private var scalingBehavior: ManipulationComponent.Dynamics.ScalingBehavior = .unconstrained
    @State private var inertia: ManipulationComponent.Dynamics.Inertia = .zero

    // An entity we can manipulate
    @State private var subject = createStepDemoBox()



    var body: some View {
        RealityView { content in

            subject.position.y = -0.2

            // We'll use configureEntity to set up input and collision on the subject
            ManipulationComponent.configureEntity(subject, collisionShapes: [.generateBox(width: 0.25, height: 0.25, depth: 0.25)])

            // Create the component and add it to the entity
            let mc = ManipulationComponent()

            // Add the component and
            subject.components.set(mc)
            content.add(subject)
        }
        .debugBorder3D(.white)
        .ornament(attachmentAnchor: .scene(.topBack), contentAlignment: .top, ornament: {
            VStack(alignment: .leading) {
                
                Button(action: {
                    releaseBehavior = releaseBehavior == .reset ? .stay : .reset
                    if var mc = subject.components[ManipulationComponent.self] {
                        mc.releaseBehavior = releaseBehavior
                        subject.components.set(mc)
                    }
                }, label: {
                    Text("Release Behavior:")
                    Spacer()
                    Text("\(releaseBehavior == .reset ? "Reset" : "Stay")")
                })

                Button(action: {
                    translationBehavior = translationBehavior == .unconstrained ? .none : .unconstrained
                    if var mc = subject.components[ManipulationComponent.self] {
                        mc.dynamics.translationBehavior = translationBehavior
                        subject.components.set(mc)
                    }
                }, label: {
                    Text("Translation Behavior:")
                    Spacer()
                    Text("\(translationBehavior == .unconstrained ? "Unconstrained" : "None")")
                })

                Button(action: {
                    rotationBehaviorPrimary = rotationBehaviorPrimary == .unconstrained ? .none : .unconstrained
                    if var mc = subject.components[ManipulationComponent.self] {
                        mc.dynamics.primaryRotationBehavior = rotationBehaviorPrimary
                        subject.components.set(mc)
                    }
                }, label: {
                    Text("Primary Rotation:")
                    Spacer()
                    Text("\(rotationBehaviorPrimary == .unconstrained ? "Unconstrained" : "None")")
                })

                Button(action: {
                    rotationBehaviorSecondary = rotationBehaviorSecondary == .unconstrained ? .none : .unconstrained
                    if var mc = subject.components[ManipulationComponent.self] {
                        mc.dynamics.primaryRotationBehavior = rotationBehaviorSecondary
                        subject.components.set(mc)
                    }
                }, label: {
                    Text("Secondary Rotation:")
                    Spacer()
                    Text("\(rotationBehaviorSecondary == .unconstrained ? "Unconstrained" : "None")")
                })

                Button(action: {
                    scalingBehavior = scalingBehavior == .unconstrained ? .none : .unconstrained
                    if var mc = subject.components[ManipulationComponent.self] {
                        mc.dynamics.scalingBehavior = scalingBehavior
                        subject.components.set(mc)
                    }
                }, label: {
                    Text("Scaling Behavior:")
                    Spacer()
                    Text("\(scalingBehavior == .unconstrained ? "Unconstrained" : "None")")
                })




            }
            .frame(width: 400)
            .padding()
            .glassBackgroundEffect()


        })

    }
}

#Preview {
    Example087()
}
