//  Step Into Vision - Example Code
//
//  Title: Example080
//
//  Subtitle: Spatial SwiftUI: Physical Metrics
//
//  Description: Scaling entities to exact real world metrics.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 5/19/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example080: View {

    // Get the converter from the environment
    @Environment(\.physicalMetrics) var physicalMetrics

    // Set a variable that will calculate the points needed to represent one foot
    @PhysicalMetric(from: .feet) var oneFoot: Float = 1

    // Set up a subject entity
    @State var subject: Entity = {
        let mat = SimpleMaterial(color: .stepGreen, roughness: 0.2, isMetallic: false)
        let box = ModelEntity(
            mesh: .generateBox(width: 1, height: 1, depth: 1),
            materials: [mat])
        return box
    }()

    var body: some View {

            RealityView { content in
                content.add(subject)

                // We can print the number of points to represent one foot
                print("one foot in points is: \(oneFoot)")

                // We'll convert from points to a size in meters and scale the subject
                let sizeInPhysicalMetric = physicalMetrics.convert(oneFoot, to: .meters)
                subject.scale = .init(repeating: sizeInPhysicalMetric)

                print("box has scale: \(sizeInPhysicalMetric) in meters")

            }

    }
}

#Preview {
    Example080()
}
