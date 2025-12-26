//  Step Into Vision - Example Code
//
//  Title: Example140
//
//  Subtitle: RealityKit Basics: Import Spatial
//
//  Description: Spatial is a collection of types for working with 3D mathematical primitives.
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/26/25.

import SwiftUI
import RealityKit
import RealityKitContent
//import Spatial

struct Example140: View {

    @State private var target: ModelEntity = {
        let material = SimpleMaterial(color: .orange, isMetallic: false)
        let entity = ModelEntity(
            mesh: .generateSphere(radius: 0.03),
            materials: [material]
        )
        entity.position = [0.25, 0.1, -0.2]
        ManipulationComponent.configureEntity(entity)
        return entity
    }()

    @State private var subject: Entity = {

        let entity = createStepDemoBox()
        entity.position = [-0.25, 0.1, -0.2]
        entity.scale = .init(repeating: 0.5)

        return entity
    }()

    var body: some View {
        RealityView { content in
            content.add(subject)
            content.add(target)
            faceSubjectTowardTarget()

            _ = content.subscribe(to: ManipulationEvents.DidUpdateTransform.self) { event in
                faceSubjectTowardTarget()
            }
        }
        .debugBorder3D(.white)
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                VStack {
                    HStack {
                        Button(action: {
                            let p = randomPointInVolume(0.4)
                            subject.position = SIMD3<Float>(p)
                            faceSubjectTowardTarget()
                        }, label: {
                            Text("Move Subject")
                        })

                        Button(action: {
                            let p = randomPointInVolume(0.45)
                            target.position = SIMD3<Float>(p)
                            faceSubjectTowardTarget()
                        }, label: {
                            Text("Move Target")
                        })

                        Button(action: {
                            faceSubjectTowardTarget()
                        }, label: {
                            Text("Face Target")
                        })
                    }
                }
                .controlSize(.small)
            }
        }
    }

    // These helper functions are **intentionally contrived** to show off the Math features of Spaital.

    // There are easier ways to do these things
    private func randomPointInVolume(_ range: Double = 0.5) -> Point3D {
        // Build a random direction vector using angles, then normalize it (Spatial math).
        let yaw = Angle2D.radians(Double.random(in: 0 ... (2 * .pi)))
        let pitch = Angle2D.radians(Double.random(in: (-.pi / 6) ... (.pi / 6))) // mostly horizontal

        let cy = cos(yaw.radians)
        let sy = sin(yaw.radians)
        let cp = cos(pitch.radians)
        let sp = sin(pitch.radians)

        // Forward-biased direction (negative Z is "forward" in RealityKit by convention)
        var dir = Vector3D(x: sy * cp, y: sp, z: -cy * cp)
        let len = dir.length
        guard len > 0.000001 else { return .zero }
        dir /= len

        // Pick a distance from the origin
        let distance = Double.random(in: 0.15 ... range)

        // Convert vector -> point and keep it inside a simple cube bound.
        var p = Point3D(x: dir.x * distance, y: dir.y * distance, z: dir.z * distance)
        p.x = max(-range, min(range, p.x))
        p.y = max(-range, min(range, p.y))
        p.z = max(-range, min(range, p.z))

        return p
    }

    // Building a helper function that will update cause the subject to face the target
    private func faceSubjectTowardTarget() {
        // Read positions from RealityKit
        let s = subject.position
        let t = target.position

        // Do the math in Spatial (Double-based)
        let subjectPos = Vector3D(x: Double(s.x), y: Double(s.y), z: Double(s.z))
        let targetPos  = Vector3D(x: Double(t.x), y: Double(t.y), z: Double(t.z))

        // Direction from subject -> target
        var dir = targetPos - subjectPos
        let dirLen = dir.length
        guard dirLen > 0.0001 else { return }
        dir /= dirLen

        // RealityKit's "forward" is typically -Z in local space
        let forward = Vector3D(x: 0, y: 0, z: -1)

        // Rotation that takes `forward` to `dir`
        let d = max(-1.0, min(1.0, forward.dot(dir)))
        var axis = forward.cross(dir)

        // If forward and dir are (anti)parallel, cross is near-zero.
        if axis.length < 0.000001 {
            // If pointing the same way, no rotation. If opposite, rotate 180° around Y.
            if d > 0.999999 { return }
            axis = Vector3D(x: 0, y: 1, z: 0)
        } else {
            axis /= axis.length
        }

        let angleRadians = acos(d)

        // Convert back to RealityKit
        let axisF = SIMD3<Float>(Float(axis.x), Float(axis.y), Float(axis.z))
        subject.orientation = simd_quatf(angle: Float(angleRadians), axis: axisF)
    }
}

#Preview {
    Example140()
}
