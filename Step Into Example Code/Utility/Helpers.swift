//
//  Helpers.swift
//  Step Into Example Code
//
//  Created by Joseph Simpson on 10/15/24.
//

import SwiftUI
import RealityKit

extension Date {
    init(_ dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self = dateFormatter.date(from: dateString) ?? Date()
    }
}


// TODO: make a gesture library that I can use in the labs.
struct DragGestureImproved: ViewModifier {

    @State var isDragging: Bool = false
    @State var initialPosition: SIMD3<Float> = .zero

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in

                        // We we start the gesture, cache the entity position
                        if !isDragging {
                            isDragging = true
                            initialPosition = value.entity.position
                        }

                        // Calculate vector by which to move the entity
                        let movement = value.convert(value.gestureValue.translation3D, from: .local, to: .scene)

                        // Add the initial position and the movement to get the new position
                        value.entity.position = initialPosition + movement

                    }
                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isDragging = false
                        initialPosition = .zero
                    }
            )

    }
}


struct MagnifyGestureImproved: ViewModifier {

    @State var isScaling: Bool = false
    @State var initialScale: SIMD3<Float> = .init(repeating: 1.0)

    func body(content: Content) -> some View {
        content
            .gesture(
                MagnifyGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in
                        // Cache the entity's initial scale when the gesture starts
                        if !isScaling {
                            isScaling = true
                            initialScale = value.entity.scale
                        }

                        // Get the magnification from the gesture
                        let magnification = Float(value.magnification)

                        let minScale: Float = 0.25
                        let maxScale: Float = 3

                        // Multiply the magnification by the initial scale to get the new scale
                        // Clamp scale values for each axis independently
                        let newScaleX = min(max(initialScale.x * magnification, minScale), maxScale)
                        let newScaleY = min(max(initialScale.y * magnification, minScale), maxScale)
                        let newScaleZ = min(max(initialScale.z * magnification, minScale), maxScale)

                        // Apply the clamped scale to the entity
                        value.entity.setScale(
                            .init(x: newScaleX, y: newScaleY, z: newScaleZ),
                            relativeTo: value.entity.parent!
                        )
                    }

                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isScaling = false
                        initialScale = .init(repeating: 1.0)
                    }
            )

    }
}

struct RotateGesture3DImproved: ViewModifier {

    @State var isRotating: Bool = false
    @State var initialOrientation:simd_quatf = simd_quatf(
        vector: .init(repeating: 0.0)
    )

    func body(content: Content) -> some View {
        content
            .gesture(
                RotateGesture3D(constrainedToAxis: .y)
                    .targetedToAnyEntity()
                    .onChanged { value in

                        // Cache the entity's initial orientation when the gesture starts
                        if !isRotating {
                            isRotating = true
                            initialOrientation = value.entity.transform.rotation
                        }

                        let rotation = value.rotation
                        let rotationTransform = Transform(AffineTransform3D(rotation: rotation))

                        // Multiply the initial orientation by the gesture rotation
                        value.entity.transform.rotation = initialOrientation * rotationTransform.rotation

                    }
                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isRotating = false
                        initialOrientation = simd_quatf(
                            vector: .init(repeating: 0.0)
                        )
                    }
            )
    }
}


enum IndirectTransformMode {
    case none
    case move
    case rotate
    case scale
}

struct IndirectTransformGesture: ViewModifier {

    @Binding var mode: IndirectTransformMode

    @State var isDragging: Bool = false
    @State var initialPosition: SIMD3<Float> = .zero
    @State var initialScale: SIMD3<Float> = .init(repeating: 1.0)
    @State var initialOrientation:simd_quatf = simd_quatf(
        vector: .init(repeating: 0.0)
    )

    @State var rotation: Angle = .zero

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in

                        // We we start the gesture, cache the entity position
                        if !isDragging {
                            isDragging = true
                            initialPosition = value.entity.position
                            initialScale = value.entity.scale
                            initialOrientation = value.entity.transform.rotation
                        }

                        switch mode {
                        case .move:
                            // Calculate vector by which to move the entity
                            let movement = value.convert(value.gestureValue.translation3D, from: .local, to: .scene)
                            // Add the two vectors and clamp the result to keep the entity in the volume. Ignore the Y axis
                            let newPostion = initialPosition + movement
                            let limit: Float = 0.25
                            let posX = min(max(newPostion.x, -limit), limit)
                            let posZ = min(max(newPostion.z, -limit), limit)
                            value.entity.position.x = posX
                            value.entity.position.z = posZ

                        case .rotate:
                            // Just a hack to rotate by *something* from the drag gesture. I'm sure there is a better way.
                            rotation.degrees += 0.01 * (value.velocity.width)
                            let rotationTransform = Transform(yaw: Float(rotation.radians))

                            value.entity.transform.rotation = initialOrientation * rotationTransform.rotation
                        case .scale:

                            // A hack to get some value from the gesture that we can use to scale
                            let magnification = 0.01 * Float(value.gestureValue.translation3D.x)
                            let scaler = magnification + initialScale.x

                            // Clamp scale values for each axis independently
                            let minScale: Float = 0.25
                            let maxScale: Float = 3
                            let newScaler: Float = min(max(scaler, minScale), maxScale)

                            // Apply the clamped scale to the entity
                            value.entity.setScale(
                                .init(repeating: newScaler),
                                relativeTo: value.entity.parent!
                            )
                        case .none: break
                        }


                    }
                    .onEnded { value in
                        // Clean up when the gesture has ended
                        isDragging = false
                        initialPosition = .zero
                        initialScale = .init(repeating: 1.0)
                        initialOrientation = simd_quatf(
                            vector: .init(repeating: 0.0)
                        )
                    }
            )

    }
}

/// Creates a six-sided box: useful for testing gestures and rotations
/// 0.25 units on all sides with a small corner radius
func createStepDemoBox(_ name: String? = nil, _ withInputs: Bool = false) -> Entity {
let mat1 = SimpleMaterial(color: .green, roughness: 0.2, isMetallic: false)
    let mat2 = SimpleMaterial(color: .yellow, roughness: 0.2, isMetallic: false)
    let mat3 = SimpleMaterial(color: .orange, roughness: 0.2, isMetallic: false)
    let mat4 = SimpleMaterial(color: .red, roughness: 0.2, isMetallic: false)
    let mat5 = SimpleMaterial(color: .purple, roughness: 0.2, isMetallic: false)
    let mat6 = SimpleMaterial(color: .blue, roughness: 0.2, isMetallic: false)

    let stepDemoBox = ModelEntity(
        mesh: .generateBox(width: 0.25, height: 0.25, depth: 0.25, cornerRadius: 0.03, splitFaces: true),
        materials: [mat1, mat2, mat3, mat4, mat5, mat6])
    stepDemoBox.name = name ?? "StepDemoBox"

    if withInputs {
        configureStepDemoBoxInteraction(for: stepDemoBox)
    }

    return stepDemoBox
}

private func configureStepDemoBoxInteraction(for entity: Entity) {

    entity.components.set(CollisionComponent(shapes: [.generateBox(size: .init(repeating: 0.25))]))
    entity.components.set(InputTargetComponent())
    entity.components.set(HoverEffectComponent())

}


/// See WWDC 2025 Session: Meet SwiftUI spatial layout
/// https://developer.apple.com/videos/play/wwdc2025/273
extension View {
    func debugBorder3D(_ color: Color) -> some View {
        spatialOverlay {
            ZStack {
                Color.clear.border(color, width: 4)
                ZStack {
                    Color.clear.border(color, width: 4)
                    Spacer()
                    Color.clear.border(color, width: 4)
                }
                .rotation3DLayout(.degrees(90), axis: .y)
                Color.clear.border(color, width: 4)
            }
        }
    }
}

// As a view instead of a modifier

    func debugBorder3DView(_ color: Color) -> some View {
        ZStack {
            Color.clear.border(color, width: 4)
            ZStack {
                Color.clear.border(color, width: 4)
                Spacer()
                Color.clear.border(color, width: 4)
            }
            .rotation3DLayout(.degrees(90), axis: .y)
            Color.clear.border(color, width: 4)
        }
    }


// Adapted from Example 051 - Spatial SwiftUI: Model3D
struct ModelViewSimple: View {

    @State var name: String = ""
    let bundle: Bundle

    var body: some View {
        Model3D(named: name, bundle: bundle)
        { phase in
            if let model = phase.model {
                model
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if phase.error != nil {
                Text("Could not load model \(name).")
            } else {
                ProgressView()
            }
        }
    }
}
