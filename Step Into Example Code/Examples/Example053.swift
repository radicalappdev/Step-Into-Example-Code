//  Step Into Vision - Example Code
//
//  Title: Example053
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/3/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example053: View {

    @State private var showingSheet: Bool = false

    let transformMain = Transform(
        scale: SIMD3<Float>(repeating: 1),
        rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)),
        translation: SIMD3<Float>(0, 0, 0)
    )

    let transformAlertShowing = Transform(
        scale: SIMD3<Float>(repeating: 1),
        rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)),
        translation: SIMD3<Float>(0, 0, -0.02)
    )

    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(named: "SwiftUIScienceLab", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            if let panel = attachments.entity(for: "AttachmentContent") {
                panel.move(to: transformMain, relativeTo: scene)
                content.add(panel)
            }

            if let alert = attachments.entity(for: "AlertContent") {
                alert.move(to: transformMain, relativeTo: scene)
                alert.isEnabled = showingSheet
                content.add(alert)
            }


        } update: { content, attachments in

            if let panel = attachments.entity(for: "AttachmentContent") {
                panel.move(to: showingSheet ? transformAlertShowing : transformMain, relativeTo: panel.parent, duration: 0.5)
            }

            if let alert = attachments.entity(for: "AlertContent") {
                alert.isEnabled = showingSheet
            }

        } attachments: {
            Attachment(id: "AttachmentContent") {
                VStack() {

                    Text("Click the button to show an alert")
                        .font(.largeTitle)

                    Button("Show Sheet", action: {
                        showingSheet.toggle()
                    })

                    Spacer()
                }
                .padding()
                .frame(width: 460, height: 500)
                .glassBackgroundEffect()
            }

            Attachment(id: "AlertContent") {
                VStack() {

                    Text("Wow, it works")
                        .font(.extraLargeTitle2)

                    Button("Close", action: {
                        showingSheet = false
                    })

                    Spacer()
                }
                .padding()
                .frame(width: 360, height: 200)
                .glassBackgroundEffect()
            }

        }
    }
}

#Preview {
    Example053()
}
