//  Step Into Vision - Labs
//
//  Title: Lab003
//
//  Subtitle: Example of anImmersive Space
//
//  Description: Testing out the immersive space
//
//  Type: Space
//
//  Created by Joseph Simpson on 10/3/24.

import SwiftUI
import RealityKit

struct Lab003: View {

    let count: Int = 12
    let radius: Float = 160

    var body: some View {
        RealityView { content, attachments in
            let model = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .black, isMetallic: false)])
            model.position = SIMD3(x: 0.8, y: 1, z: -2)
            content.add(model)

            if let attachmentEntity = attachments.entity(for: "SphereLabel") {
                attachmentEntity.position = model.position + [0, 0.16, 0]
                model.addChild(attachmentEntity)
                content.add(attachmentEntity)
            }

        } update: { content, attachments in
            // ...
        } attachments: {
            Attachment(id: "SphereLabel") {
                Text("An Immersive Space")
                    .font(.largeTitle)
                    .padding(18)
                    .background(.black)
                    .cornerRadius(12)
            }
        }
    }
}

#Preview {
    Lab003()
}
