//  Step Into Vision - Example Code
//
//  Title: Example067
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/10/25.

import SwiftUI
import Foundation
import RealityKit
import RealityKitContent

struct Example067: View {

    init() {
        BreathComponent.registerComponent()
        BreathSystem.registerSystem()
    }

    @State var subjectEntity = Entity()


    var body: some View {
        RealityView { content in


            var material = PhysicallyBasedMaterial()
            material.baseColor.tint = .stepRed
            material.roughness = 0.5
            material.metallic = 0.0

            let shape = MeshResource.generateSphere(radius: 0.2)

            let model = ModelComponent(mesh: shape, materials: [material])

            subjectEntity.components.set(model)
            subjectEntity.name = "Subject"
            content.add(subjectEntity)

        } update: { content in

        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    ColorButton(color: .stepRed, subjectEntity: $subjectEntity)
                    ColorButton(color: .stepGreen, subjectEntity: $subjectEntity)
                    ColorButton(color: .stepBlue, subjectEntity: $subjectEntity)

                    Divider()
                        .padding(.horizontal, 12)

                    Button(action: {
                        subjectEntity.components.set(OpacityComponent(opacity: 0.25))
                    }, label: {
                        Image(systemName: "circle.dotted")
                    })

                    Button(action: {
                        subjectEntity.components.remove(OpacityComponent.self)
                    }, label: {
                        Image(systemName: "circle.fill")
                    })

                    Divider()
                        .padding(.horizontal, 12)

                    Button(action: {
                        subjectEntity.components.remove(BreathComponent.self)
                    }, label: {
                        Image(systemName: "stop.circle")
                    })

                    Button(action: {
                        var breath = BreathComponent()
                        breath.duration = 2.0
                        subjectEntity.components.set(breath)
                    }, label: {
                        Image(systemName: "2.circle.fill")
                    })

                    Button(action: {
                        var breath = BreathComponent()
                        breath.duration = 4.0
                        subjectEntity.components.set(breath)
                    }, label: {
                        Image(systemName: "4.circle.fill")
                    })
                }
            })
        }
    }
}


fileprivate struct ColorButton: View {

    @State var color: Color
    @Binding var subjectEntity: Entity

    var body: some View {
        Button(action: {
            if var material = subjectEntity.components[ModelComponent.self]?.materials.first as? PhysicallyBasedMaterial {
                material.baseColor.tint = UIColor(color)
                subjectEntity.components[ModelComponent.self]?.materials[0] = material
            }

        }, label: {
            color
                .frame(width: 44, height: 44)
                .clipShape(.circle)
        })
        .buttonStyle(.plain)
    }
}

fileprivate struct BreathComponent: Component, Codable {

    /// The time it will take for a full cycle of the breath animation
    public var duration: Float = 4.0

    /// Store accumation time used for the breath animation
    public var accumulatedTime: Float = 0

    public init() {

    }
}


// This was used by Lab 010 to learn my way around components and systems
fileprivate class BreathSystem: System {

    // Define a query to return all entities with a BreathComponent.
    private static let query = EntityQuery(where: .has(BreathComponent.self))

    // init is required even when not used
    required public init(scene: RealityFoundation.Scene) {
        // Perform required initialization or setup.
    }

    public func update(context: SceneUpdateContext) {
        for entity in context.entities(
            matching: Self.query,
            updatingSystemWhen: .rendering
        ) {

            // Get the component
            guard var breath = entity.components[BreathComponent.self] else { continue }

            let duration = breath.duration

            // Accumulate time for this entity and set the new value on the component
            breath.accumulatedTime += Float(context.deltaTime)

            // Calculate the phase of the sine wave (0 to 2π), wrapping by duration
            let phase = (breath.accumulatedTime / duration) * 2.0 * .pi

            // Compute the scale
            let scale = 1 + 0.5 * sin(phase)

            // Apply the scale to the entity
            entity.transform.scale = .init(repeating: scale)

            // Reset accumulated time if a full cycle has passed
            if breath.accumulatedTime >= duration {
                breath.accumulatedTime = 0.0
            }

            entity.components[BreathComponent.self] = breath

        }
    }

}

#Preview {
    Example067()
}
