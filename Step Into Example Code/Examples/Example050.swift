//  Step Into Vision - Example Code
//
//  Title: Example050
//
//  Subtitle: RealityKit Basics: attachments
//
//  Description: We can create 2D SwiftUI attachments and add them to out 3D scenes as entities.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 2/18/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example050: View {
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "RKBasicsLoading", in: realityKitContentBundle) {
                content.add(scene)
                scene.position.y = -0.4

                if let earth = scene.findEntity(named: "Earth"), let moon = scene.findEntity(named: "Moon") {

                    if let earthPanel = attachments.entity(for: "EarthPanel") {
                        // ❌ Don't add an attachment like this unless you want the SwiftUI content to scale with the entity
                        // earth.addChild(earthPanel)
                        // ✅ Instead, use preservingWorldTransform to keep the attachment entity transform/scale
                        earth.addChild(earthPanel, preservingWorldTransform: true)
                        earthPanel.setPosition([0, -0.1, 0.1], relativeTo: earth)
                    }

                    if let moonPanel = attachments.entity(for: "MoonPanel") {
                        moon.addChild(moonPanel, preservingWorldTransform: true)
                        moonPanel.setPosition([0, -0.05, 0.15], relativeTo: moon)
                    }
                }

                if let titlePanel = attachments.entity(for: "TitlePanel") {
                    content.add(titlePanel)
                    titlePanel.setPosition([0, 0.2, -0.2], relativeTo: nil)
                }

                
            }

        } update: { content, attachments in

        } attachments: {

            Attachment(id: "EarthPanel") {
                HStack {
                    Image(systemName: "globe.europe.africa")
                    Text("Earth")
                        .font(.headline)
                }
                .padding()
                .glassBackgroundEffect()
            }

            Attachment(id: "MoonPanel") {
                HStack {
                    Image(systemName: "moon.circle.fill")
                    Text("Moon")
                        .font(.headline)
                }
                .padding()
                .glassBackgroundEffect()
            }

            Attachment(id: "TitlePanel") {
                VStack {
                    Text("Earth & Moon")
                        .font(.largeTitle)
                    Text("Best of friends for 4.53 billion years")
                        .font(.caption)
                }
                .padding()
                .glassBackgroundEffect(in: .rect(cornerRadius: 24))
            }
        }
    }
}

#Preview {
    Example050()
}






