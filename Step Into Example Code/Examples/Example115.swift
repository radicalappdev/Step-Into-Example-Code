//  Step Into Vision - Example Code
//
//  Title: Example115
//
//  Subtitle: Model3D: Working with Configruations
//
//  Description: WIP
//
//  Type: Window
//
//  Created by Joseph Simpson on 10/26/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct EarthVariantsView: View {
    @State private var style = "realistic"                // iconic | papercraft | realistic | stylized
    @State private var catalog: Entity.ConfigurationCatalog?
    @State private var loadError: String?

    private let remoteURL = URL(string: "https://stepinto.vision/wp-content/uploads/2025/10/Earth.usdz")!

    var body: some View {
        VStack(spacing: 12) {
            if let catalog {
                Model3D(
                    from: catalog,
                    configurations: ["styles": style],
                    transaction: .init(animation: .snappy)
                ) { phase in
                    if let model = phase.model {
                        model.resizable().scaledToFit3D()
                    } else if let error = phase.error {
                        Text("Model load failed: \(error.localizedDescription)")
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 220, height: 220)
            } else {
                VStack(spacing: 8) {
                    ProgressView()
                    if let loadError { Text(loadError).font(.footnote) }
                }
                .task { await loadEarthCatalogFromRemote() }   // note: now downloads first
            }

            Picker("Style", selection: $style) {
                Text("Iconic").tag("iconic")
                Text("Papercraft").tag("papercraft")
                Text("Realistic").tag("realistic")
                Text("Stylized").tag("stylized")
            }
            .pickerStyle(.segmented)
        }
        .padding()
    }

    /// Download the USDZ to disk, then build the catalog from the **file URL**.
    private func loadEarthCatalogFromRemote() async {
        do {
            let (temp, resp) = try await URLSession.shared.download(from: remoteURL)
            if let http = resp as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                throw NSError(domain: "HTTP", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode)"])
            }
            let fm = FileManager.default
            let caches = try fm.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let local = caches.appendingPathComponent("Earth.usdz")
            _ = try? fm.removeItem(at: local)
            try fm.moveItem(at: temp, to: local)

            catalog = try await Entity.ConfigurationCatalog(from: local)  // <- file URL
            loadError = nil
        } catch {
            catalog = nil
            loadError = "Catalog load failed: \(error.localizedDescription)"
        }
    }
}

struct Example115: View {

    var body: some View {
        HStackLayout(spacing: 12).depthAlignment(.front) {

            // Loading a model from the bundle
            EarthVariantsView() // This never loads


            // Loading a model from a URL
            VStackLayout(spacing: 12).depthAlignment(.front) {
                Model3D(url: URL(string: "https://stepinto.vision/wp-content/uploads/2025/10/Earth.usdz")!) { phase in

                    if let model = phase.model {
                        model
                            .resizable()
                            .scaledToFit3D()
                    } else if phase.error != nil {
                        Text("Failed to load model")
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 150, height: 150)
                Text("Loading from a URL")
                    .font(.caption)
                    .padding()
                    .background(.black)
                    .clipShape(.capsule)
            }
            .offset(y: -50)
        }
    }
}

#Preview {
    Example115()
}
