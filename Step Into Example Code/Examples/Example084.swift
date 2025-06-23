//  Step Into Vision - Example Code
//
//  Title: Example084
//
//  Subtitle:
//
//  Description:
//
//  Type:
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
            scene.position.y = -0.35

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

        .onChange(of: surfaceSnappingInfo) {
            if (!surfaceSnappingInfo.isSnapped && SurfaceSnappingInfo.authorizationStatus == .authorized) {

                switch surfaceSnappingInfo.classification {
                case .table:
                    print("Snapped to floor")
                    shouldLand = true
                    showBase = false
                default:
                    print("Snapped to something else: \(surfaceSnappingInfo.classification?.description ?? "" )")
                    shouldLand = true
                    showBase = true
                }

            } else {
                shouldLand = false
                showBase = true
            }
        }
    }
}

#Preview {
    Example084()
}
