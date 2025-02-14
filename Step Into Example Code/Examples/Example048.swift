//  Step Into Vision - Example Code
//
//  Title: Example048
//
//  Subtitle: Spatial SwiftUI: Volume TabViews
//
//  Description: SwiftUI TabViews are presented as Ornaments at the front leading anchor of the volume.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 2/14/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example048: View {
    @State private var logEntries: [String] = []
    
    var body: some View {
        TabView {
            RealityView { content in
                let model = ModelEntity(
                    mesh: .generateSphere(radius: 0.1),
                    materials: [SimpleMaterial(color: .stepRed, isMetallic: false)])
                content.add(model)
                logEntries.append("Sphere created \(Date())")
            }

            .tabItem {
                Image(systemName: "circle.fill")
                Text("Sphere")
            }

            RealityView { content in
                let model = ModelEntity(
                    mesh: .generateBox(size: 0.2, cornerRadius: 0.05),
                    materials: [SimpleMaterial(color: .stepBlue, isMetallic: false)])
                content.add(model)
                logEntries.append("Box created \(Date())")
            }

            .tabItem {
                Image(systemName: "rectangle.fill")
                Text("Box")
            }

            RealityView { content in
                let model = ModelEntity(
                    mesh: .generateCylinder(height: 0.2, radius: 0.1),
                    materials: [SimpleMaterial(color: .stepGreen, isMetallic: false)])
                content.add(model)
                logEntries.append("Cylynder created \(Date())")
            }
            .tabItem {
                Image(systemName: "capsule.fill")
                Text("Cylynder")
            }

        }
        .ornament(attachmentAnchor: .scene(.trailing)) {
            List(logEntries, id: \.self) { entry in
                Text(entry)
                    .fontDesign(.monospaced)
            }
            .listStyle(.plain)
            .frame(width: 300, height: 600)
            .glassBackgroundEffect()
        }
    }
}

#Preview {
    Example048()
}


