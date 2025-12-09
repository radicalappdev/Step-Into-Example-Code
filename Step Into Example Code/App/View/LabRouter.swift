//
//  ExampleRouter.swift
//  Step Into Examples
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI

struct ExampleRouter: View {
    @Binding var route: String?

    @ViewBuilder
    var body: some View {
        if let route, let example = ExampleRegistry.examplesByTitle[route] {
            example.makeView()
        } else {
            VStack {
                Text("No View could be found for " + (route ?? ""))
                    .font(.largeTitle)
                    .padding(12)
            }
            .background(.red)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}
