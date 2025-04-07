//  Step Into Vision - Example Code
//
//  Title: Example065
//
//  Subtitle: Collisions & Physics: Physics Mass Properties
//
//  Description: We can adjust mass, inertia, and center of mass for Physics Bodies.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 4/7/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example065: View {
    // We'll use this subject as the parent. We'll clone one of the capsules and add it to the subject to run the simulation.
    @State var subject = Entity()
    @State var capTop = Entity()
    @State var capCenter = Entity()
    @State var capBottom = Entity()


    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "PhysicsMassProperties", in: realityKitContentBundle) else { return }

            // Get the capsules from the scene, disable them, and stash them in state
            guard let capsuleTop = scene.findEntity(named: "Capsule_Top") else { return }
            guard let capsuleCenter = scene.findEntity(named: "Capsule_Center") else { return }
            guard let capsuleBottom = scene.findEntity(named: "Capsule_Bottom") else { return }

            capsuleTop.isEnabled = false
            capsuleCenter.isEnabled = false
            capsuleBottom.isEnabled = false

            capTop = capsuleTop
            capCenter = capsuleCenter
            capBottom = capsuleBottom

            content.add(scene)
            scene.position.y = -0.4
            scene.addChild(subject)

        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    Button(action: {
                        subject.children.removeAll()
                        let clone = capTop.clone(recursive: true)
                        subject.addChild(clone)
                        clone.isEnabled = true
                    }, label: {
                        Text("Top Heavy")
                    })
                    Button(action: {
                        subject.children.removeAll()
                        let clone = capCenter.clone(recursive: true)
                        subject.addChild(clone)
                        clone.isEnabled = true
                    }, label: {
                        Text("Centered")
                    })
                    Button(action: {
                        subject.children.removeAll()
                        let clone = capBottom.clone(recursive: true)
                        subject.addChild(clone)
                        clone.isEnabled = true
                    }, label: {
                        Text("Bottom Heavy")
                    })
                }
            })
        }
    }
}

#Preview {
    Example065()
}
