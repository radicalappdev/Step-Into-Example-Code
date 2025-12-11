//  Step Into Vision - Example Code
//
//  Title: Example134
//
//  Subtitle: TBD
//
//  Description:
//
//  Type: Volume
//
//  Featured: True
//
//  Created by Joseph Simpson on 12/11/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example134: View {

    /// We'll need to use a converter from physicalMetrics
    @Environment(\.physicalMetrics) var physicalMetrics

    /// This will store the size of the volume
    @State private var volumeSize: Size3D = .zero

    /// A top level entity that will be scaled with the volume. Only the root view will be added to this
    @State private var volumeRootEntity = Entity()

    // A place to store the bounds of our 3D content
    @State private var baseExtents: SIMD3<Float> = .zero

    // A place to store the Point3D for the volume position in world space
    @State private var volumePosition: Point3D = .zero

    var body: some View {
        RealityView { content in

            content.add(volumeRootEntity)

            guard let baseRoot = try? await Entity(named: "ToyBiplane", in: realityKitContentBundle) else { return }
            volumeRootEntity.addChild(baseRoot, preservingWorldTransform: true)

            // Capture the base extents from visual bounds
            baseExtents = baseRoot.visualBounds(relativeTo: nil).extents / baseRoot.scale
            baseRoot.position.y = -baseExtents.y / 2 // Align the scene on the y axis

            // Call our new function once for the initial size
            scaleContent(by: volumeSize)

        }
        .ornament(attachmentAnchor: .scene(.back), ornament: {
            VStack(alignment: .leading, spacing: 12) {
                Text("X: \(volumePosition.x)")
                Text("Y: \(volumePosition.y)")
                Text("Z: \(volumePosition.z)")
            }

            .font(.largeTitle)
            .padding(24)
            .glassBackgroundEffect()
        })
        .debugBorder3D(.white)
        // Anytime the volume changes in size we'll scale the RealityView content
        .onGeometryChange3D(for: Rect3D.self) { proxy in
            return proxy.frame(in: .global)
        } action: { new in
            volumeSize = new.size
            scaleContent(by: volumeSize)
        }
        // Anytime the position of the volume changes
        .onGeometryChange3D(for: Point3D.self) { proxy in try! proxy
                .coordinateSpace3D()
                .convert(value: Point3D.zero, to: .worldReference)
        } action: { _, new in
            volumePosition = new
        }
    }

    /// Scale the 3D content based on the size of the Volume
    func scaleContent(by volumeSize: Size3D) {
        let scale = Float(physicalMetrics.convert(volumeSize.width, to: .meters)) / baseExtents.x
        volumeRootEntity.setScale(.init(repeating: scale), relativeTo: nil)
    }

    /// Rotate the 3D content to face world origin
    func faceWorldOrigin(from volumePosition: Point3D) {
        // using the current volumePosition value, rotate the content to face world origin

    }
}

#Preview {
    Example134()
}
