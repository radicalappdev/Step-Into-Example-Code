//
//  DirectoryModel.swift
//  Step Into Examples
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
    var isFeatured = false
    var date: Date
    var title: String
    var subtitle: String
    var description: String
    var success: Bool = true

    init(title: String, type: ExampleType, date: Date, isFeatured: Bool = false, subtitle: String, description: String, success: Bool = true) {
        self.title = title
        self.type = type
        self.isFeatured = isFeatured
        self.date = date
        self.subtitle = subtitle
        self.description = description
        self.success = success
    }
}


@Observable
class ModelData {
    var exampleData: [Example] = [

        Example(title: "Example 001",
            type: .WINDOW,
            date: Date("10/15/2024"),
            isFeatured: false,
            subtitle: "Open a 2D Window",
            description: "Testing out the window")

        ,Example(title: "Example 002",
             type: .VOLUME,
             date: Date("10/15/2024"),
             isFeatured: false,
             subtitle: "Open a Volume",
             description: "Testing out the volume")

        ,Example(title: "Example 003",
             type: .SPACE,
             date: Date("10/15/2024"),
             isFeatured: false,
             subtitle: "Open Immersive Space",
             description: "Testing out the immersive space")

        ,Example(title: "Example 004",
                 type: .VOLUME,
                 date: Date("10/15/2024"),
                 isFeatured: true,
                 subtitle: "Tap Gesture",
                 description: "Using a tap gesture with RealityKit")

    ]

}
