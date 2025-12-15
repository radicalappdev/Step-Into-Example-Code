//  Step Into Vision - Example Code
//
//  Title: Example135
//
//  Subtitle: RealityKit Basics: Visual Bounds
//
//  Description:
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/15/25.

import SwiftUI
import RealityKit
import RealityKitContent

fileprivate enum BoundsExamples: String, CaseIterable, Identifiable {
    case earth = "Earth"
    case moon = "Moon"
    case rocket = "ToyRocket"
    case earthCollection = "Earth Collection"

    var id: Self { self }
}

struct Example135: View {

    @State private var showBoundsOn: BoundsExamples = .earth
    @State private var boundingBoxVis = Entity()

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
            content.add(boundingBoxVis)

            guard let earth = scene.findEntity(named: "Earth") else { return }

            let boxSize = earth.visualBounds(recursive: true, relativeTo: scene).extents
            let boundsCenter = earth.visualBounds(recursive: true, relativeTo: scene).center
            boundingBoxVis = ModelEntity(mesh: .generateBox(size: boxSize), materials: [boundsMat])
            boundingBoxVis.position = scene.position + boundsCenter
            content.add(boundingBoxVis)

        }
    }
}

#Preview {
    Example135()
}
