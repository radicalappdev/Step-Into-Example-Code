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
                 isFeatured: false,
                 subtitle: "Tap Gesture",
                 description: "Using a tap gesture with RealityKit")

        ,Example(title: "Example 005",
                 type: .VOLUME,
                 date: Date("10/28/2024"),
                 isFeatured: false,
                 subtitle: "Spatial Tap Gesture",
                 description: "Expanding on the Spatial version of tap gesture with RealityKit")

        ,Example(title: "Example 006",
                 type: .VOLUME,
                 date: Date("11/7/2024"),
                 isFeatured: true,
                 subtitle: "Long Press Gesture",
                 description: "Using the LongPressGesture with a RealityKit Entity")

        ,Example(title: "Example 007",
                 type: .VOLUME,
                 date: Date("11/8/2024"),
                 isFeatured: true,
                 subtitle: "Drag Gesture Basics",
                 description: "Using the DragGesture to move entities.")

        ,Example(title: "Example 008",
                 type: .VOLUME,
                 date: Date("11/10/2024"),
                 isFeatured: true,
                 subtitle: "Magnify Gesture Basics",
                 description: """
Using the MagnifyGesture to scale entities.

Issue: This lab doesn't take into account the initial scale of the entity. If the entity starts at a scale of anything other than 1, you will see it "snap" to the starting scale of the gesture. 

We will fix this in another example.
""")

        ,Example(title: "Example 009",
                 type: .VOLUME,
                 date: Date("11/10/2024"),
                 isFeatured: true,
                 subtitle: "Rotate Gesture 3D Basics",
                 description: """
                 Using the RotateGesture3D to rotate entities around an axis.
                 
                 **Issue:** This lab doesn't take into account the initial orientation of the entity. If the has a rotation value on the Y axis is anything other than 0, you will see the entity "snap" to the starting value of the geture. 
                 
                 We will fix this in another example.
                 """)

    ]

}
