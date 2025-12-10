//  Step Into Vision - Example Code
//
//  Title: Example133
//
//  Subtitle: RealityKit Basics: using realityKitScene Environment Variable
//
//  Description: We can access the RealityKit Scene of the nearest RealityView
//
//  Type: Volume
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/10/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example133: View {

    @Environment(\.realityKitScene) var realityKitScene
    @State var earthString: String = ""

    var body: some View {

        RealityView { content in
            guard let scene = try? await Entity(named: "Earth", in: realityKitContentBundle) else { return }
            scene.name = "Earth"
            content.add(scene)
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {

                HStack {
                    // Example 01 - find and update an entity
                    Button(action: {
                        if let earth = realityKitScene?.findEntity(named: "Earth") {
                            earth.orientation *= simd_quatf(angle: .pi/2, axis: [0,1,0])
                        }
                    }, label: {
                        Image(systemName: "arrow.left")
                    })

                    Button(action: {
                        if let earth = realityKitScene?.findEntity(named: "Earth") {
                            earth.orientation *= simd_quatf(angle: .pi/2, axis: [0,-1,0])
                        }
                    }, label: {
                        Image(systemName: "arrow.right")
                    })

                    // Example 02 - query the entities in the scene
                    Button(action: {
                        guard let scene = realityKitScene else { return }
                        let query = EntityQuery(where: .has(ModelComponent.self))
                        let enumerated = scene.performQuery(query).enumerated()
                        print("Entities in scene:", enumerated)
                    }, label: {
                        Text("Print Entities")
                    })

                }

            })
        }
    }
}

#Preview {
    Example133()
}

