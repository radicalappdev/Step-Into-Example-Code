//
//  ExampleListRow.swift
//  Step Into Examples
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI

struct ExampleListRow: View {
    var example: Example

    var body: some View {
        HStack {
            Text("\(example.title) - \(example.subtitle)")
            Spacer()
            if(example.success == false) {
                Image(systemName: "x.circle.fill")
                    .foregroundColor(.red)
                    .padding(4)
            }
            switch example.type {
            case .WINDOW, .WINDOW_ALT:
                Image(systemName: "macwindow")
            case .VOLUME:
                Image(systemName: "cube.transparent")
            case .SPACE:
                Image(systemName: "visionpro.fill")
            case .SPACE_FULL:
                Image(systemName: "visionpro.fill")
            }

        }
    }
}

#Preview {
    let modelData = ModelData()
    let length = modelData.exampleData.count
    return ExampleListRow(example: modelData.exampleData[length - 1])
}
