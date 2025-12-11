//  Step Into Vision - Example Code
//
//  Title: Example134
//
//  Subtitle: Spatial SwiftUI: onGeometryChange3D
//
//  Description: We can use this modifier to access data from GeometryProxy3D without using GeometryReader3D
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

    @Environment(\.physicalMetrics) var physicalMetrics
    @State private var volumeSize: Size3D = .zero
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
            baseExtents = baseRoot.visualBounds(relativeTo: nil).extents / baseRoot.scale
            baseRoot.position.y = -baseExtents.y / 2
            scaleContent(by: volumeSize)

        }
        .ornament(attachmentAnchor: .scene(.bottomLeadingBack), ornament: {
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

        // Example 01: Anytime the volume changes in size we'll scale the RealityView content
        .onGeometryChange3D(for: Rect3D.self) { proxy in
            return proxy.frame(in: .global)
        } action: { new in
            volumeSize = new.size
            scaleContent(by: volumeSize)
        }

        // Example 02: Capture the position of the volume when it changes
        .onGeometryChange3D(for: Point3D.self) { proxy in try! proxy
                .coordinateSpace3D()
                .convert(value: Point3D.zero, to: .worldReference)
        } action: { _, new in
            volumePosition = new // We'll just show this in an ornament
        }
    }

    /// Scale the 3D content based on the size of the Volume
    /// See this article for details: https://stepinto.vision/example-code/using-ongeometrychange3d-to-scale-realityview-content-when-a-volume-is-resized/
    func scaleContent(by volumeSize: Size3D) {
        let scale = Float(physicalMetrics.convert(volumeSize.width, to: .meters)) / baseExtents.x
        volumeRootEntity.setScale(.init(repeating: scale), relativeTo: nil)
    }

}

#Preview {
    Example134()
}
