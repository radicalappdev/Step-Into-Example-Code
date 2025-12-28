//  Step Into Vision - Example Code
//
//  Title: Example142
//
//  Subtitle: RealityKit Basics: Loading Entities on Device
//
//  Description: We can load entities from our app bundle if we're not working with Reality Composer Pro.
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/28/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example142: View {
    var body: some View {

        TabView {
            // Loading a file from the main app bundle
            LoadingExample(fileName: "EarthFull")
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Standalone Example")
                }

            // Loading a file from an `.rkassets` folder in the main app bundle
            LoadingExample(fileName: "EarthRK")
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("RK Assets Example")
                }
            
        }

    }
}

fileprivate struct LoadingExample: View {

    @State private var loadDuration: Duration?
    private let fileName: String
    private let clock = ContinuousClock()

    init(fileName: String) {
        self.fileName = fileName
    }

    var body: some View {
        RealityView { content in

            // If RealityView re-runs, don't re-time/reload.
            guard loadDuration == nil else { return }

            let start = clock.now

            // From a standalone file in the app's main bundle
            let entity = try! await Entity(named: fileName)
            content.add(entity)

            // Capture elapsed time just after adding to the scene
            let elapsed = start.duration(to: clock.now)
            await MainActor.run {
                loadDuration = elapsed
            }

        }
        .realityViewLayoutBehavior(.fixedSize)
        .ornament(attachmentAnchor: .scene(.bottomFront), ornament: {
            VStack {
                if let loadDuration {
                    Text("Load: \(format(loadDuration))")
                } else {
                    Text("Loading…")
                }
            }
            .padding()
            .glassBackgroundEffect()
        })
    }
}

fileprivate func format(_ duration: Duration) -> String {
    let ms = Double(duration.components.seconds) * 1_000 + Double(duration.components.attoseconds) / 1_000_000_000_000_000

    if ms < 1_000 {
        return String(format: "%.0f ms", ms)
    } else {
        return String(format: "%.2f s", ms / 1_000)
    }
}

#Preview {
    Example142()
}
