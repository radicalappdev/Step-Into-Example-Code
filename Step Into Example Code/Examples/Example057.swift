//  Step Into Vision - Example Code
//
//  Title: Example057
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example057: View {
    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(named: "CollisionLabsCustom", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            if let bowl = scene.findEntity(named: "bowl"),
               let pin = scene.findEntity(named: "pin"),
               let sheet = scene.findEntity(named: "sheet")  {

                print(bowl.children)

                // Get the bowl's mesh using ModelComponent
                if let modelComponent = bowl.children.first?.components[ModelComponent.self] {
                    // The mesh is available in modelComponent.mesh
                    let mesh = modelComponent.mesh

                    print("mesh: \(mesh)")

                }
            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Example057()
}
