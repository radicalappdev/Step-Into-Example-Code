//  Step Into Vision - Example Code
//
//  Title: Example015
//
//  Subtitle: Working with SpatialEventGesture
//
//  Description:
//
//  Type: Space
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/11/24.

import SwiftUI
import RealityKit

struct Example015: View {

    var body: some View {
        RealityView { content in
            // Target entity we will manipulate with the gizmo.
            let target = ModelEntity(
                mesh: .generateBox(size: 0.12, cornerRadius: 0.01),
                materials: [SimpleMaterial(color: .stepBackgroundSecondary, isMetallic: false)]
            )
            target.name = "Target"
            target.position = SIMD3(0, 1, -0.6)
            target.components.set(InputTargetComponent())
            target.generateCollisionShapes(recursive: false)

            // Attach a simple 3-axis translation gizmo as a child of the target.
            let gizmo = GizmoFactory.makeTranslationGizmo()
            target.addChild(gizmo)

            content.add(target)
        }
        .modifier(SpatialEventGestureGizmo())
    }
}

#Preview {
    Example015()
}

fileprivate struct SpatialEventGestureGizmo: ViewModifier {
    private enum Axis: String { case x, y, z }

    @State private var activeAxis: Axis? = nil
    @State private var lastLocation: SIMD3<Float>? = nil
    @State private var activeHandleEntity: Entity? = nil

    /// SpatialEventGesture.location3D deltas can be much larger than you expect.
    /// Scale them down so a small hand motion results in a small translation.
    private let sensitivity: Float = 0.0025

    /// Safety clamp per update (meters). Prevents single-frame spikes from launching the entity.
    private let maxStepPerUpdate: Float = 0.01

    func body(content: Content) -> some View {
        content
            .gesture(
                SpatialEventGesture()
                    .onChanged { events in
                        // Look for an active event. SpatialEventGesture can deliver multiple events
                        // (multi-touch / multiple pointers). We'll “pick” the first active handle.
                        if let axis = activeAxis {
                            // Continue only if we still have an active event targeting the SAME handle.
                            guard let activeHandleEntity else {
                                endDrag()
                                return
                            }

                            guard let event = events.first(where: { $0.phase == .active && $0.targetedEntity === activeHandleEntity }) else {
                                // No longer touching the handle we started on => end the drag and restore tint.
                                endDrag()
                                return
                            }

                            continueDrag(using: event, axis: axis)
                        } else {
                            // Start drag only if the user is touching one of our handles.
                            guard let event = events.first(where: { $0.phase == .active }) else { return }
                            guard let handle = event.targetedEntity else { return }
                            guard let axis = axisForHandle(handle) else { return }

                            activeAxis = axis
                            lastLocation = toSIMD3(event.location3D)
                            activeHandleEntity = handle

                            // Visual feedback: tint the active handle.
                            tintHandle(handle, isActive: true)
                        }
                    }
                    .onEnded { _ in
                        endDrag()
                    }
            )
    }

    private func continueDrag(using event: SpatialEventCollection.Event, axis: Axis) {
        guard let handle = event.targetedEntity else {
            endDrag()
            return
        }
        guard axisForHandle(handle) == axis else {
            // If the pointer moved to a different entity, end this drag.
            endDrag()
            return
        }

        guard let last = lastLocation else {
            lastLocation = toSIMD3(event.location3D)
            return
        }

        let current = toSIMD3(event.location3D)
        let delta = current - last
        lastLocation = current

        // Project delta onto the selected axis.
        let axisVector = axisUnitVector(axis)
        var amount = dot(delta, axisVector) * sensitivity
        amount = min(max(amount, -maxStepPerUpdate), maxStepPerUpdate)

        // Our handles live under the target: handle.parent (AxisRoot) -> gizmo -> target.
        // Move the target in its local space along the chosen axis.
        if let target = findTarget(from: handle) {
            target.position += axisVector * amount
        }
    }

    private func endDrag() {
        if let handle = activeHandleEntity {
            tintHandle(handle, isActive: false)
        }
        activeAxis = nil
        lastLocation = nil
        activeHandleEntity = nil
    }

    private func findTarget(from entity: Entity) -> Entity? {
        // Walk up until we find the entity named "Target".
        var current: Entity? = entity
        while let c = current {
            if c.name == "Target" { return c }
            current = c.parent
        }
        return nil
    }

    private func axisForHandle(_ entity: Entity) -> Axis? {
        // Handles are named: Handle_X / Handle_Y / Handle_Z
        switch entity.name {
        case "Handle_X": return .x
        case "Handle_Y": return .y
        case "Handle_Z": return .z
        default: return nil
        }
    }

    private func axisUnitVector(_ axis: Axis) -> SIMD3<Float> {
        switch axis {
        case .x: return SIMD3(1, 0, 0)
        case .y: return SIMD3(0, 1, 0)
        case .z: return SIMD3(0, 0, 1)
        }
    }

    private func tintHandle(_ entity: Entity, isActive: Bool) {
        guard let model = entity as? ModelEntity else { return }
        // We keep it simple: active = bright yellow, inactive = original material.
        // In this example, handles are created with SimpleMaterial; we can just swap.
        if isActive {
            model.model?.materials = [SimpleMaterial(color: .stepBackgroundPrimary, isMetallic: false)]
        } else {
            // Best-effort: restore based on handle name.
            if entity.name == "Handle_X" {
                model.model?.materials = [SimpleMaterial(color: .stepRed, isMetallic: false)]
            } else if entity.name == "Handle_Y" {
                model.model?.materials = [SimpleMaterial(color: .stepGreen, isMetallic: false)]
            } else if entity.name == "Handle_Z" {
                model.model?.materials = [SimpleMaterial(color: .stepBlue, isMetallic: false)]
            }
        }
    }

    private func toSIMD3(_ p: Point3D) -> SIMD3<Float> {
        // SpatialEventGesture gives a Point3D. Convert to a SIMD3 in the same coordinate space.
        // Negate Y so “hand up => +Y” and “hand down => -Y” for this gizmo mapping.
        SIMD3(Float(p.x), Float(-p.y), Float(p.z))
    }
}

fileprivate enum GizmoFactory {
    static func makeTranslationGizmo() -> Entity {
        let gizmo = Entity()
        gizmo.name = "Gizmo"

        let xRoot = Entity(); xRoot.name = "AxisRoot_X"
        let yRoot = Entity(); yRoot.name = "AxisRoot_Y"
        let zRoot = Entity(); zRoot.name = "AxisRoot_Z"

        gizmo.addChild(xRoot)
        gizmo.addChild(yRoot)
        gizmo.addChild(zRoot)

        // Handle geometry: small boxes positioned just outside the target cube.
        let handleSize = SIMD3<Float>(0.03, 0.03, 0.03)
        let offset: Float = 0.11

        let xHandle = ModelEntity(
            mesh: .generateBox(size: handleSize),
            materials: [SimpleMaterial(color: .stepRed, isMetallic: false)]
        )
        xHandle.name = "Handle_X"
        xHandle.position = SIMD3(offset, 0, 0)
        prepareForSpatialEvents(xHandle)

        let yHandle = ModelEntity(
            mesh: .generateBox(size: handleSize),
            materials: [SimpleMaterial(color: .stepGreen, isMetallic: false)]
        )
        yHandle.name = "Handle_Y"
        yHandle.position = SIMD3(0, offset, 0)
        prepareForSpatialEvents(yHandle)

        let zHandle = ModelEntity(
            mesh: .generateBox(size: handleSize),
            materials: [SimpleMaterial(color: .stepBlue, isMetallic: false)]
        )
        zHandle.name = "Handle_Z"
        zHandle.position = SIMD3(0, 0, offset)
        prepareForSpatialEvents(zHandle)

        xRoot.addChild(xHandle)
        yRoot.addChild(yHandle)
        zRoot.addChild(zHandle)

        return gizmo
    }

    private static func prepareForSpatialEvents(_ entity: ModelEntity) {
        entity.components.set(InputTargetComponent())
        entity.generateCollisionShapes(recursive: false)
    }
}
