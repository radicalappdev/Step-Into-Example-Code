//
//  Step Into Examples
//  DirectoryModel.swift
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI

enum ExampleType: String {
    case WINDOW  = "Window Content"
    case WINDOW_ALT  = "Plain Window Content"
    case VOLUME = "Volume Content"
    case SPACE = "Mixed Immersive Space"
    case SPACE_FULL = "Full Immersive Space"
}

struct Example: Identifiable {
    let id = UUID()
    var type: ExampleType
    var isFeatured: Bool
    var date: Date
    var title: String
    var subtitle: String
    var description: String
    var success: Bool
    var makeView: () -> AnyView

    init(title: String,
         type: ExampleType,
         date: Date,
         isFeatured: Bool = false,
         subtitle: String,
         description: String,
         success: Bool = true,
         makeView: @escaping () -> AnyView = { AnyView(EmptyView()) }) {
        self.title = title
        self.type = type
        self.isFeatured = isFeatured
        self.date = date
        self.subtitle = subtitle
        self.description = description
        self.success = success
        self.makeView = makeView
    }
}

@Observable
class ModelData {
    var exampleData: [Example] = ExampleRegistry.allExamples

    var exampleByTitle: [String: Example] {
        ExampleRegistry.examplesByTitle
    }
}
