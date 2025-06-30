//  Step Into Vision - Example Code
//
//  Title: Example084
//
//  Subtitle: How to read volume snapping state and classification
//
//  Description: We can use the surfaceSnappingInfo environment value to access volume snapping data.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 6/23/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example084: View {
    @Environment(\.surfaceSnappingInfo) private var surfaceSnappingInfo

    @State var shouldLand = false
    @State var showBase = true

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "VolumeSnapping", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

        } update: { content in

            if let toyPlane = content.entities.first?.findEntity(named: "ToyBiplane") {
                Entity.animate(.easeInOut(duration: 0.5), body: {
                    toyPlane.transform.translation.y = shouldLand ? 0 : 0.35
                })
            }

            if let base = content.entities.first?.findEntity(named: "Base") {
                base.isEnabled = showBase
            }

        }
        // Some UI to show the snapping data
        .ornament(attachmentAnchor: .scene(.topBack), ornament: {
            VStack(spacing: 12) {
                Text("Surface Snapping")
                    .font(.extraLargeTitle)
                VStack(spacing: 12) {
                    HStack {
                        Text("Is Snapped:")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text("\(surfaceSnappingInfo.isSnapped ? "Yes" : "No")")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    HStack {
                        Text("Classification:")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text("\(surfaceSnappingInfo.classification?.description ?? "" )")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Spacer()
            }
            .padding()
            .glassBackgroundEffect()
        })

        // Listen for changes to snapping info and update our scene state
        .onChange(of: surfaceSnappingInfo) {
            if (surfaceSnappingInfo.isSnapped && SurfaceSnappingInfo.authorizationStatus == .authorized) {
                // When snapped to a surface
                shouldLand = true
                
                switch surfaceSnappingInfo.classification {
                case .table:
                   // When we snap to a table, hide the base
                    showBase = false
                default:
                    // When we snap to anything else, show the base
                    showBase = true
                }
            } else {
                // When we are not snapped to anything, show the base and let the plane take off
                shouldLand = false
                showBase = true
            }
        }
    }
}

#Preview {
    Example084()
}
