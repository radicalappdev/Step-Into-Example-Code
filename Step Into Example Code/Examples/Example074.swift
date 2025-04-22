//  Step Into Vision - Example Code
//
//  Title: Example074
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/20/25.

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct Example074: View {
    @State var session = ARKitSession()
    @State var frameEntity = Entity()

    @State var portal = Entity()
    @State var wallAnchor: PlaneAnchor?

    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "PortalFrame", in: realityKitContentBundle) else { return }
            content.add(scene)

            guard let frame = scene.findEntity(named: "picture_frame_02") else { return }
            frameEntity = frame
            frameEntity.isEnabled = false
            scene.addChild(frameEntity)


        } update: { content in


        }

        .task {
            try! await setupAndRunPlaneDetection()
        }
    }

    func setupAndRunPlaneDetection() async throws {
        let planeData = PlaneDetectionProvider(alignments: [.vertical])
        if PlaneDetectionProvider.isSupported {
            do {
                try await session.run([planeData])
                for await update in planeData.anchorUpdates {
                    switch update.event {
                    case .added, .updated:
                        let anchor = update.anchor

                        if(anchor.classification == .wall) {
                            if wallAnchor == nil {
                                let anchorMatrix = anchor.originFromAnchorTransform
                                let extentMatrix = anchor.geometry.extent.anchorFromExtentTransform
                                frameEntity.transform = Transform(matrix: matrix_multiply(anchorMatrix, extentMatrix))

                                frameEntity.isEnabled = true
                                wallAnchor = anchor

                            }
                        }


                    case .removed:
                        let anchor = update.anchor
                        if (anchor == wallAnchor) {
                            wallAnchor = nil
                            frameEntity.isEnabled = false
                        }
                    }
                }
            } catch {
                print("ARKit session error \(error)")
            }
        }
    }

}
#Preview {
    Example074()
}
