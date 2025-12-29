//  Step Into Vision - Example Code
//
//  Title: Example054
//
//  Subtitle: Spatial SwiftUI: Volumetric pickers with attachments
//
//  Description: As of visionOS 2, we can not use the SwiftUI presentations API with RealityView attachments.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 3/4/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example054: View {

    @State private var showPicker: Bool = false
    @State private var date = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

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

            if let alert = attachments.entity(for: "PickerContent") {
                alert.move(to: transformAlert, relativeTo: scene)
                alert.isEnabled = showPicker
                content.add(alert)
            }


        } update: { content, attachments in

            if let panel = attachments.entity(for: "AttachmentContent") {
                panel
                    .move(
                        to: showPicker ? transformMainAlertShowing : transformMain,
                        relativeTo: panel.parent,
                        duration: 0.25,
                        timingFunction: .easeOut
                    )
            }

            if let alert = attachments.entity(for: "PickerContent") {
                alert.isEnabled = showPicker
            }

        } attachments: {
            Attachment(id: "AttachmentContent") {
                VStack() {

                    Text("Volumetric Date Picker")
                        .font(.extraLargeTitle2)

                    Text("Click the button to show a volumetric picker. We'll use another attachment to show the date picker with the `.graphical` style. We will also move this attachment back a bit on the z axis when the picker is shown.")

                    Button(dateFormatter.string(from: date), action: {
                        withAnimation {
                            showPicker.toggle()
                        }
                    })

                    Spacer()
                }
                .opacity(showPicker ? 0 : 1)
                .padding()
                .frame(width: 460, height: 500)
                .glassBackgroundEffect()
            }

            Attachment(id: "PickerContent") {
                DatePicker("Select a date", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                    .frame(width: 460, height: 500)
                    .glassBackgroundEffect()
                    .opacity(showPicker ? 1 : 0)
                    .onChange(of: date) {
                        showPicker = false
                    }

            }

        }
    }
}

#Preview {
    Example054()
}

