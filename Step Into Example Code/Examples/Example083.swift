//  Step Into Vision - Example Code
//
//  Title: Example083
//
//  Subtitle: How to read window snapping state and classification
//
//  Description: We can use the surfaceSnappingInfo environment value to access window snapping data.
//
//  Type: Window
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
        .onChange(of: surfaceSnappingInfo) {
            if (!surfaceSnappingInfo.isSnapped && SurfaceSnappingInfo.authorizationStatus == .authorized) {

                switch surfaceSnappingInfo.classification {
                    case .wall:
                    print("Snapped to a wall")
                    
                case .door:
                    print("Snapped to the door")

                default:
                    print("Snapped to something else: \(surfaceSnappingInfo.classification?.description ?? "" )")

                }

            }
        }

    }
}

//#Preview {
//    Example083()
//}


