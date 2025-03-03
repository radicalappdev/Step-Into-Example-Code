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
    @State private var someDate = Date()

    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(named: "SwiftUIScienceLab", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            if let panel = attachments.entity(for: "AttachmentContent") {

                panel.position.y = 0.1
                content.add(panel)
            }


        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                VStack() {

                    Text("This will crash when used in an attachment")
                        .font(.extraLargeTitle2)

                    Button("Show Sheet", action: {
                        showingSheet = true
                    })

                    DatePicker("Date",
                               selection: $someDate,
                               displayedComponents: .date
                    )


                    Spacer()
                }
                .sheet(isPresented: $showingSheet) {
                    Text("some view")
                }
                .padding()
                .frame(width: 460, height: 500)
                .glassBackgroundEffect()
            }
        }
    }
}

#Preview {
    Example053()
}
