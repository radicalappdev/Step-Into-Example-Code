//  Step Into Vision - Example Code
//
//  Title: Example039
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example039: View {
    var body: some View {
        RealityView { content, attachments in

            let sphere = ModelEntity(
                mesh: .generateSphere(radius: 0.2),
                materials: [SimpleMaterial(color: .stepRed, isMetallic: false)])
            sphere.position = SIMD3(x: -0.6, y: 1, z: -2)
            content.add(sphere)

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Example039()
}
