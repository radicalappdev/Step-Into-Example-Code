//  Step Into Vision - Example Code
//
//  Title: Example135
//
//  Subtitle: RealityKit Basics: Visual Bounds
//
//  Description: We can use visual bounds to get the center, extent, and other properties of a bounding box for a given entity.
//
//  Type: Volume
//
//  Featured: false
//
//  Created by Joseph Simpson on 12/15/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example135: View {

    var boundsMat: PhysicallyBasedMaterial {
        var boundsMat = PhysicallyBasedMaterial()
        boundsMat.baseColor = .init(tint: .stepRed)
        boundsMat.blending = .transparent(opacity: .init(floatLiteral:0.2))
        return boundsMat
    }

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "VisualBounds", in: realityKitContentBundle) else { return }
            content.add(scene)

            // Draw bounds around a single entity
            guard let earth = scene.findEntity(named: "Earth") else { return }
            let earthBounds = earth.visualBounds(relativeTo: nil)
            let earthSize = earthBounds.extents
            let earthCenter = earthBounds.center
            let earthBox = ModelEntity(mesh: .generateBox(size: earthSize), materials: [boundsMat])
            earthBox.position = scene.position + earthCenter
            content.add(earthBox)

            // Draw bounds around all entites in the scene
            let sceneBounds = scene.visualBounds(recursive: true, relativeTo: scene)
            let sceneSize = sceneBounds.extents
            let sceneCenter = sceneBounds.center
            let sceneBox = ModelEntity(mesh: .generateBox(size: sceneSize), materials: [boundsMat])
            sceneBox.position = scene.position + sceneCenter
            content.add(sceneBox)

        }
    }
}

#Preview {
    Example135()
}
