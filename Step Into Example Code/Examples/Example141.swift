//  Step Into Vision - Example Code
//
//  Title: Example141
//
//  Subtitle: Loading an Entity from Data
//
//  Description: We can load Entities from a block of Data, which we can can retrieve remotely or on device.
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/31/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example141: View {

    var body: some View {

        TabView {
            LoadingExample01()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Minimal Example")
                }

            LoadingExample02()
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Expanded Example")
                }
        }

    }
}

// A minimal example that loads data from a URL. Ignores response data and errors.
fileprivate struct LoadingExample01: View {
    private let remoteURL = URL(string: "https://stepinto.vision/wp-content/uploads/2025/10/Earth.usdz")!
    var body: some View {
        RealityView { content in
            if let (data, _) = try? await URLSession.shared.data(from: remoteURL) {
                if let entity = try? await Entity(from: data) {
                    content.add(entity)
                }
            }
        }
        .realityViewLayoutBehavior(.fixedSize)
    }
}

// A slightly improved example that shows a progress indicator while loading. We can capture an error and display the file name on success.
// In production we would want to expand this to an enum to capture all possible states
fileprivate struct LoadingExample02: View {

    @State private var isLoading = false
    @State private var response : URLResponse?
    @State private var fileName: String = ""
    @State private var errorString: String?

    private let remoteURL = URL(string: "https://stepinto.vision/wp-content/uploads/2025/10/Earth.usdz")!

    var body: some View {
        RealityView { content in
            do {
                isLoading = true
                let (data, response) = try await URLSession.shared.data(from: remoteURL)
                fileName = response.suggestedFilename ?? "unknown"
                let entity = try await Entity(from: data)
                content.add(entity)
                isLoading = false
            } catch {
                isLoading = false
                errorString = error.localizedDescription
            }
        }
        .realityViewLayoutBehavior(.fixedSize)
        .ornament(attachmentAnchor: .scene(.bottomFront), ornament: {
            VStack {
                if(isLoading ) {
                    ProgressView()
                } else {
                    // Show the error string if we have one, else show the file name
                    Text("\(errorString ?? fileName)")
                }
            }
            .frame(width: 300, height: 60)
            .glassBackgroundEffect()
        })
    }
}

#Preview {
    Example141()
}
