//  Step Into Vision - Example Code
//
//  Title: Example085
//
//  Subtitle: Using presentations in Volumes
//
//  Description:
//
//  Type: Volume
//
//  Created by Joseph Simpson on 6/26/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example085: View {

    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(named: "SwiftUIScienceLab", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4
//            scene.scale = .init(repeating: 0.7)


            if let panel = attachments.entity(for: "AttachmentContent") {
                panel.position = [0, -0.1, 0.1]
                content.add(panel)
            }

        } attachments: {
            Attachment(id: "AttachmentContent") {
                FormView(title: "Attachment Presentations")
            }
        }
        .ornament(attachmentAnchor: .parent(.topBack), ornament: {
            FormView(title: "Ornament Presentations")
        })
    }
}

fileprivate struct FormView: View {

    var title: String = "Volume Presentations!"

    @State private var showingSheet = false
    @State private var showingPopover = false
    @State private var someDate = Date()

    var body: some View {
        Form() {

            Text(title)
                .font(.largeTitle)

            Button("Show Sheet", action: {
                showingSheet.toggle()
            })

            Button("Show Popover", action: {
                showingPopover.toggle()
            })

            DatePicker("Date Picker",
                       selection: $someDate,
                       displayedComponents: .date
            )

        }
        .sheet(isPresented: $showingSheet) {
            VStack {
                Text("Sheets show up somewhere in the volume, relative to the user")
                    .padding()
                Button("Close Sheet", action: {
                    showingSheet = false
                })
            }
        }
        .popover(isPresented: $showingPopover, attachmentAnchor: .point(.trailing), arrowEdge: .leading, content: {
            VStack {
                Text("Popovers")
                    .padding()
                Button("Close Popover", action: {
                    showingPopover = false
                })
            }
        })
        .frame(width: 400, height: 300)
        .glassBackgroundEffect()
    }
}

#Preview {
    Example085()
}
