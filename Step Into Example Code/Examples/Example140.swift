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

    @State private var subject: ModelEntity = {
        let material = SimpleMaterial(color: .stepRed, isMetallic: false)
        let entity = ModelEntity(
            mesh: .generateBox(size: 0.1, cornerRadius: 0.01),
            materials: [material]
        )

        // Initial placement using Spatial
        let startPoint = Point3D(x: 0, y: 0.1, z: -0.4)

        entity.transform = Transform(
            translation: SIMD3<Float>(startPoint)
        )

        return entity
    }()

    var body: some View {
        RealityView { content in
            content.add(subject)
        }
        .debugBorder3D(.white)
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                VStack {
                    HStack {
                        Button(action: {
                            let targetPoint = Point3D(x: 0.25, y: 0.15, z: 0)
                            subject.position = SIMD3<Float>(targetPoint)
                        }, label: {
                            Text("Move: Point3D")
                        })

                        Button(action: {
                            let simdPosition = SIMD3<Float>(-0.25, -0.15, 0)
                            subject.position = simdPosition
                        }, label: {
                            Text("Move; SIMD3")
                        })
                    }

                    HStack {
                        Button(action: {
                            // Scale with Size3D
                        }, label: {
                            Text("Scale: Size3D")
                        })

                        Button(action: {
                            // Scale as normal
                        }, label: {
                            Text("Scale; SIMD3")
                        })
                    }

                    HStack {
                        Button(action: {
                            // Rotate with Rotation3D or Pose3D
                        }, label: {
                            Text("Rotate: ")
                        })

                        Button(action: {
                            // Rotate as normal
                        }, label: {
                            Text("Rotate; ")
                        })
                    }


                }
                .controlSize(.small)
            }
        }
    }

}

#Preview {
    Example140()
}
