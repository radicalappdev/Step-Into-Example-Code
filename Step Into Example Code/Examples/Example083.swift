//  Step Into Vision - Example Code
//
//  Title: Example083
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 6/22/25.

import SwiftUI
import RealityKit
import RealityKitContent

@available(visionOS 26.0, *)
struct Example083: View {
    @Environment(\.surfaceSnappingInfo) private var surfaceSnappingInfo
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("Surface Snapping")
                .font(.extraLargeTitle)
            HStack(spacing: 12) {
                Spacer()
                Text("Is Snapped:")
                    .font(.largeTitle)
                Spacer()
                Text("\(surfaceSnappingInfo.isSnapped ? "Yes" : "No")")
                    .font(.largeTitle)
                Spacer()
            }

            HStack(spacing: 12) {
                Spacer()
                Text("Classification:")
                    .font(.largeTitle)
                Spacer()
                Text("\(surfaceSnappingInfo.classification?.description ?? "" )")
                    .font(.largeTitle)
                Spacer()
            }
            Spacer()
        }
        .frame(width: .infinity, height: .infinity)
        .background(surfaceSnappingInfo.isSnapped ? .stepGreen : .clear)
        .clipShape(.rect(cornerRadius: 24))
        .glassBackgroundEffect(displayMode: surfaceSnappingInfo.isSnapped ? .never : .always)
        .onChange(of: surfaceSnappingInfo) {
            if (!surfaceSnappingInfo.isSnapped && SurfaceSnappingInfo.authorizationStatus == .authorized) {

                switch surfaceSnappingInfo.classification {
                    case .wall:
                    print("Snapped to a wall")
                    
                case .floor:
                    print("Snapped to the floor")
                    
                default:
                    print("Snapped to something else")

                }

            }
        }

    }
}

//#Preview {
//    Example083()
//}
