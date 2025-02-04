//  Step Into Vision - Example Code
//
//  Title: Example045
//
//  Subtitle: Spatial SwiftUI: Window TabViews
//
//  Description: SwiftUI TabViews are presented as Ornaments at the left side of the window.
//
//  Type: Window
//
//  Created by Joseph Simpson on 2/4/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example045: View {
    var body: some View {
        TabView {
            Circle()
                .fill(.stepRed)
                .frame(width: 200, height: 200)
                .tabItem {
                    Image(systemName: "circle.fill")
                    Text("Circle")
                }

            Rectangle()
                .fill(.stepGreen)
                .frame(width: 300, height: 200)
                .tabItem {
                    Image(systemName: "rectangle.fill")
                    Text("Rectangle")
                }

            Capsule()
                .fill(.stepBlue)
                .frame(width: 300, height: 200)
                .tabItem {
                    Image(systemName: "capsule.fill")
                    Text("Capsule")
                }
        }
    }
}

#Preview {
    Example045()
}


