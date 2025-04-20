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

    @State var frame = Entity()
    @State var portal = Entity()
    @State var wallAnchor: PlaneAnchor?

    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "PortalFrame", in: realityKitContentBundle) else { return }
            content.add(scene)

            guard let frameEntity = scene.findEntity(named: "picture_frame_02") else { return }
            frame = frameEntity
            frame.isEnabled = false


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
                        print("anchor added or updated")
                        if(anchor.classification == .wall) {
                            print("WALL anchor added or updated")
                            if wallAnchor == nil {
                                wallAnchor = anchor
                                let transform = Transform(matrix: wallAnchor!.originFromAnchorTransform)

                                frame.setTransformMatrix(wallAnchor!.originFromAnchorTransform, relativeTo: nil)

                                frame.isEnabled = true
                                print("WALL added a frame")
                            }
                        }


                    case .removed:
                        let anchor = update.anchor
                        if (anchor == wallAnchor) {
                            wallAnchor = nil
                            frame.isEnabled = false
                            print("WALL removed a frame")
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
