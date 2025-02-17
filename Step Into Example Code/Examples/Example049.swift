//  Step Into Vision - Example Code
//
//  Title: Example049
//
//  Subtitle: RealityKit Basics: update closure
//
//  Description: The update closure will run when any referenced state changes. We can reach into our RealityView content to modify entities or components.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 2/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example049: View {

    @State var showMoon = true
    @State var showEarth = true

    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "RKBasicsLoading", in: realityKitContentBundle) {
                content.add(scene)
                scene.position.y = -0.4
            }
        } update: { content in

            // 3. Find the Earth and Moon entities and update their visibility based on our state
            if let earth = content.entities.first?.findEntity(named: "Earth"), let moon = content.entities.first?.findEntity(named: "Moon") {

                earth.isEnabled = showEarth
                moon.isEnabled = showMoon
            }
        }
        // 2. SwiftUI toolbar and toggles to modify our state
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    Toggle("Show Earth", isOn: $showEarth)
                        .toggleStyle(.button)
                    Toggle("Show Moon", isOn: $showMoon)
                        .toggleStyle(.button)
                }
            })
        }
    }
}

#Preview {
    Example049()
}



