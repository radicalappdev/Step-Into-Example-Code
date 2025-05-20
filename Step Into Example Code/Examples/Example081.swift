//  Step Into Vision - Example Code
//
//  Title: Example081
//
//  Subtitle: Spatial SwiftUI: GeometryReader3D
//
//  Description: Reading Size3D and BoundingBox data from a proxy.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 5/20/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example081: View {

    // Set up a subject entity
    @State var subject: Entity = {
        let mat = SimpleMaterial(color: .stepGreen, roughness: 0.2, isMetallic: false)
        let box = ModelEntity(
            mesh: .generateBox(width: 1, height: 1, depth: 1, cornerRadius: 0.06),
            materials: [mat])
        return box
    }()

    var body: some View {

        GeometryReader3D { proxy in
            RealityView { content in
                content.add(subject)
            } update: { content in

                // Update the subject scale anytime the proxy changes
                scaleSubjectWithFrame(content: content, proxy: proxy, subject: subject)

            }
        }
    }

    // Example 1: converting Size3D to a new scale for our entity
    func scaleSubjectWithSize(content: RealityViewContent, proxy: GeometryProxy3D, subject: Entity) {
        let newSize = content.convert(proxy.size, from: .global, to: .scene)
        print("new size requested \(newSize)")
        subject.scale = .init(newSize)
    }

    // Example 2: converting the frame extents to a new scale for our entity
    func scaleSubjectWithFrame(content: RealityViewContent, proxy: GeometryProxy3D, subject: Entity) {
        let newFrame = content.convert(proxy.frame(in: .global), from: .global, to: .scene)
        print("new frame requested \(newFrame.extents)")
        subject.scale = [newFrame.extents.x, newFrame.extents.y, newFrame.extents.z]
    }
}

#Preview {
    Example081()
}

