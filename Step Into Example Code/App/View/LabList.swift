//
//  ExampleList.swift
//  Step Into Examples
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI

struct ExampleList: View {
    @Environment(ModelData.self) var modelData

    var featuredExamples: [Example] {
        modelData.exampleData.filter { $0.isFeatured }
    }

    var body: some View {
        List {
            Section(header: Text("Featured Examples")) {
                ForEach(featuredExamples) { example in
                    NavigationLink {
                        ExampleDetail(example: example)
                    } label: {
                        ExampleListRow(example: example)
                    }
                }
            }

            Section(header: Text("All Examples")) {
                ForEach(modelData.exampleData) { example in
                    NavigationLink {
                        ExampleDetail(example: example)
                    } label: {
                        ExampleListRow(example: example)
                    }
                }
            }

        }

    }
}

#Preview {
    let modelData = ModelData()
    return ExampleList()
        .environment(modelData)
}
