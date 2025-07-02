//  Step Into Vision - Example Code
//
//  Title: Example089
//
//  Subtitle: Using custom sounds with Manipulation Component
//
//  Description: We can silence the provided system sounds and play our own using Manipulation Events.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 7/2/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example089: View {

    // An entity we can manipulate
    @State private var subject = createStepDemoBox()
    
    // Audio resources
    static let drop001Audio = try! AudioFileResource.load(named: "drop_001")
    static let drop002Audio = try! AudioFileResource.load(named: "drop_002")

    var body: some View {
        RealityView { content in

            let audioComponent = AmbientAudioComponent()
            subject.components.set(audioComponent)

            // We'll use configureEntity to set up input and collision on the subject
            ManipulationComponent
                .configureEntity(
                    subject,
                    hoverEffect: .spotlight(.default),
                    collisionShapes: [.generateBox(width: 0.25, height: 0.25, depth: 0.25)]
                )

            // Create the component and add it to the entity
            var mc = ManipulationComponent()
            mc.audioConfiguration = .none // turn off the default sounds

            // Play a sound when we start the gesture
            _ = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                event.entity.playAudio(Example089.drop001Audio)
            }

            // Play a sound when we release the gesture
            _ = content.subscribe(to: ManipulationEvents.WillRelease.self) { event in
                event.entity.playAudio(Example089.drop002Audio)
            }

            // Add the component and
            subject.components.set(mc)
            content.add(subject)

        }
    }
}

#Preview {
    Example089()
}


