//
//  DirectoryModel.swift
//  Step Into Labs
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI

enum LabType: String {
    case WINDOW  = "Window Content"
    case WINDOW_ALT  = "Plain Window Content"
    case VOLUME = "Volume Content"
    case SPACE = "Mixed Immersive Space"
    case SPACE_FULL = "Full Immersive Space"
}

struct Lab: Identifiable {
    let id = UUID()
    var type: LabType
    var isFeatured = false
    var date: Date
    var title: String
    var subtitle: String
    var description: String
    var success: Bool = true

    init(title: String, type: LabType, date: Date, isFeatured: Bool = false, subtitle: String, description: String, success: Bool = true) {
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
    var labData: [Lab] = [

        Lab(title: "Lab 001",
            type: .WINDOW,
            date: Date("10/03/2024"),
            isFeatured: false,
            subtitle: "Example of a 2D Window",
            description: "Testing out the window")

        ,Lab(title: "Lab 002",
             type: .VOLUME,
             date: Date("10/03/2024"),
             isFeatured: false,
             subtitle: "Example of a 3D Volume",
             description: "Testing out the volume")

        ,Lab(title: "Lab 003",
             type: .SPACE,
             date: Date("10/03/2024"),
             isFeatured: false,
             subtitle: "Example of anImmersive Space",
             description: "Testing out the immersive space")

    ]

}
