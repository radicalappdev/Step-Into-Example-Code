//
//  ContentView.swift
//  Step Into Examples
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Directory: View {

    var body: some View {
        NavigationStack {
            ExampleList()
        }
        .padding(EdgeInsets(top: 36, leading: 0, bottom: 0, trailing: 0))
        .ornament(attachmentAnchor: .scene(.top)) {
            HStack {
                Image(systemName: "arrow.down.to.line")
                Text("Step Into Examples")
            }
            .font(.largeTitle)
            .padding(20)
            .background(.thickMaterial)
            .glassBackgroundEffect()
            .cornerRadius(20)

        }
        .ornament(attachmentAnchor: .scene(.bottom)) {
            HStack {
                Text("https://stepinto.vision/category/examples/")
            }
            .padding(20)
            .background(.thickMaterial)
            .glassBackgroundEffect()
            .cornerRadius(20)

        }


    }
}

#Preview(windowStyle: .automatic) {
    let modelData = ModelData()
    return Directory()
        .environment(modelData)
}
