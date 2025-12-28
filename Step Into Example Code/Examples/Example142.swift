//  Step Into Vision - Example Code
//
//  Title: Example142
//
//  Subtitle: RealityKit Basics: Loading Entities on Device
//
//  Description:
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
            LoadingExample01()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Standalone Example")
                }

            LoadingExample02()
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("RK Assets Example")
                }
        }

    }
}

fileprivate struct LoadingExample01: View {
    var body: some View {
        RealityView { content in

            // From a standalong file in the app's main bundle
            let entity = try! await Entity(named: "EarthFull")
            content.add(entity)

        }
        .realityViewLayoutBehavior(.fixedSize)
    }
}

fileprivate struct LoadingExample02: View {
    var body: some View {
        RealityView { content in

            // From the file from an .rkassets folder in the app's main bundle
            let entity = try! await Entity(named: "EarthRK")
            content.add(entity)

        }
        .realityViewLayoutBehavior(.fixedSize)
    }
}

#Preview {
    Example142()
}
