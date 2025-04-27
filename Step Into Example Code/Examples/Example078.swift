//  Step Into Vision - Example Code
//
//  Title: Example078
//
//  Subtitle: RealityKit Basics: pointing entities
//
//  Description: We can use `look(at:)` and its variants to orient entities to new directions.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 4/27/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example078: View {

    @State var subject = Entity()
    @State var box1 = Entity()
    @State var box2 = Entity()
    @State var box3 = Entity()

    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "MoveToExamples", in: realityKitContentBundle) else { return }
            content.add(scene)

            guard let subjectEntity = scene.findEntity(named: "Subject") else { return }
            subject = subjectEntity

            guard let box1Entity = scene.findEntity(named: "Box_1") else { return }
            box1 = box1Entity

            guard let box2Entity = scene.findEntity(named: "Box_2") else { return }
            box2 = box2Entity

            guard let box3Entity = scene.findEntity(named: "Box_3") else { return }
            box3 = box3Entity

        } update: { content in

        }
        .gesture(tapSubect)
        .gesture(tapBox1)
        .gesture(tapBox2)
        .gesture(tapBox3)

    }

    var tapSubect: some Gesture {
        TapGesture()
            .targetedToEntity(subject)
            .onEnded { value in
                // Reset the subject transform to default
                let newTransform = Transform()
                subject.move(to: newTransform, relativeTo: value.entity.parent)
            }
    }

    var tapBox1: some Gesture {
        TapGesture()
            .targetedToEntity(box1)
            .onEnded { value in

                // Example 1: Point the subject at the red sphere without moving it
                subject.look(at: value.entity.position, from: subject.position, relativeTo: subject)

            }
    }

    var tapBox2: some Gesture {
        TapGesture()
            .targetedToEntity(box2)
            .onEnded { value in

                // Example 2: Point the subject at the entity, but specify the upVector so it doesn't end up rotated off axis
                subject.look(at: value.entity.position, from: subject.position, upVector: [0, 1, 0], relativeTo: subject)

            }
    }

    var tapBox3: some Gesture {
        TapGesture()
            .targetedToEntity(box3)
            .onEnded { value in

                // Example 3: Point the subject away from the entity by flipping the forward direction
                subject.look(at: value.entity.position, from: subject.position, upVector: [0, 1, 0], relativeTo: subject, forward: .positiveZ)
            }
    }
}

#Preview {
    Example078()
}
