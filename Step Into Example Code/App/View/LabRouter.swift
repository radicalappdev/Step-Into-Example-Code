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
        switch route {
        case "Example 001": Example001()
        case "Example 002": Example002()
        case "Example 003": Example003()
        case "Example 004": Example004()
        case "Example 005": Example005()
        case "Example 006": Example006()
        case "Example 007": Example007()
        case "Example 008": Example008()
        case "Example 009": Example009()
        case "Example 010": Example010()
        case "Example 011": Example011()
        case "Example 012": Example012()
        case "Example 013": Example013()
        case "Example 014": Example014()
        case "Example 015": Example015()
        case "Example 016": Example016()
        case "Example 017": Example017()
        case "Example 018": Example018()
        case "Example 019": Example019()

        case .none, .some:

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
