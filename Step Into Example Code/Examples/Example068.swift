//  Step Into Vision - Example Code
//
//  Title: Example068
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 4/14/25.

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct Example068: View {
    @State var session = ARKitSession()


    var body: some View {
        RealityView { content in

        } update: { content in

        }
        .task {
            try! await setupAndRunPlaneDetection()
        }
    }

    func setupAndRunPlaneDetection() async throws {

        let planeData = PlaneDetectionProvider(alignments: [.horizontal, .vertical])
        if PlaneDetectionProvider.isSupported {
            do {
                try await session.run([planeData])
                for await update in planeData.anchorUpdates {
                    // Update app state.
                    print(update)
                }
            } catch {
                print("ARKit session error \(error)")
            }
        }
    }
}

#Preview {
    Example068()
}
