//  Step Into Vision - Example Code
//
//  Title: Example077
//
//  Subtitle: RealityKit Basics: moving entities
//
//  Description: We can use `move(to:)` and its variants to move entities to new locations.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 4/24/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example077: View {

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

                // Example 1: Move the subject to the transform of box one
                subject.move(to: value.entity.transform, relativeTo: value.entity.parent)

            }
    }

    var tapBox2: some Gesture {
        TapGesture()
            .targetedToEntity(box2)
            .onEnded { value in

                // Example 2: Move the subject to the transform of box two. Move over time with an ease out animation
                subject
                    .move(
                        to: value.entity.transform,
                        relativeTo: value.entity.parent,
                        duration: 1,
                        timingFunction: .easeOut
                    )

            }
    }

    var tapBox3: some Gesture {
        TapGesture()
            .targetedToEntity(box3)
            .onEnded { value in
                
                // Example 3: move to the position of box 3, but use the scale and orientation from the subject
                let boxTransform = value.entity.transform

                var newTransform = Transform()
                newTransform.translation = boxTransform.translation
                newTransform.scale = subject.transform.scale
                newTransform.rotation = subject.transform.rotation

                subject.move(to: newTransform, relativeTo: value.entity.parent, duration: 1)
            }
    }
}

#Preview("Volume", windowStyle: .volumetric) {
    Example077()
}
