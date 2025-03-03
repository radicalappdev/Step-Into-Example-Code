//  Step Into Vision - Example Code
//
//  Title: Example053
//
//  Subtitle: Spatial SwiftUI: Faking presentation with attachments
//
//  Description: As of visionOS 2, we can not use the SwiftUI presentations API with RealityView attachments.
//
//  Type: Volume
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
        translation: SIMD3<Float>(0, 0, -0.1)
    )

    let transformMainAlertShowing = Transform(
        scale: SIMD3<Float>(repeating: 1),
        rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)),
        translation: SIMD3<Float>(0, 0, -0.12)
    )

    let transformAlert = Transform(
        scale: SIMD3<Float>(repeating: 1),
        rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)),
        translation: SIMD3<Float>(0, 0.4, -0.1)
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
                alert.move(to: transformAlert, relativeTo: scene)
                alert.isEnabled = showingSheet
                content.add(alert)
            }


        } update: { content, attachments in

            if let panel = attachments.entity(for: "AttachmentContent") {
                panel
                    .move(
                        to: showingSheet ? transformMainAlertShowing : transformMain,
                        relativeTo: panel.parent,
                        duration: 0.25,
                        timingFunction: .easeOut
                    )
            }

            if let alert = attachments.entity(for: "AlertContent") {
                alert.isEnabled = showingSheet
            }

        } attachments: {
            Attachment(id: "AttachmentContent") {
                VStack() {

                    Text("Faking an alert")
                        .font(.extraLargeTitle2)

                    Text("Click the button to show a fake alert. We'll use another attachment for the alert content. We will also move this attachment back a bit on the z axis when the alert is shown.")

                    Button("Show Sheet", action: {
                        withAnimation {
                            showingSheet.toggle()
                        }
                    })

                    Spacer()
                }
                .opacity(showingSheet ? 0 : 1)
                .padding()
                .frame(width: 460, height: 500)
                .glassBackgroundEffect()
            }

            Attachment(id: "AlertContent") {
                VStack() {

                    Text("Wow, it works")
                        .font(.extraLargeTitle2)

                    Button("Close", action: {
                        withAnimation {
                            showingSheet = false
                        }
                    })

                    Spacer()
                }
                .padding()
                .frame(width: 360, height: 200)
                .glassBackgroundEffect()
                .opacity(showingSheet ? 1 : 0)
            }

        }
    }
}

#Preview {
    Example053()
}


