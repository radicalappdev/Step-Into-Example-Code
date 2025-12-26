//  Step Into Vision - Example Code
//
//  Title: Example140
//
//  Subtitle: Useful Imports
//
//  Description: Exploring other imports that may be useful when working in 3D.
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/26/25.

import SwiftUI
import RealityKit
import RealityKitContent

import Spatial
import GameplayKit

struct Example140: View {

    @State private var target: ModelEntity = {
        let material = SimpleMaterial(color: .stepGreen, isMetallic: false)
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
                            // Move subject using Spatial
                            let p = Point3D(x: -0.2, y: 0.1, z: -0.35)
                            subject.position = SIMD3<Float>(p)
                        }, label: {
                            Text("Move Subject")
                        })

                        Button(action: {
                            // Move target using plain SIMD
                            target.position = SIMD3<Float>(0.25, 0.18, -0.15)
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

        // Convert ONLY at the boundary back to RealityKit
        let axisF = SIMD3<Float>(Float(axis.x), Float(axis.y), Float(axis.z))
        subject.orientation = simd_quatf(angle: Float(angleRadians), axis: axisF)
    }

}

#Preview {
    Example140()
}
