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
                 isFeatured: false,
                 subtitle: "Long Press Gesture",
                 description: "Using the LongPressGesture with a RealityKit Entity")

        ,Example(title: "Example 007",
                 type: .VOLUME,
                 date: Date("11/8/2024"),
                 isFeatured: false,
                 subtitle: "Drag Gesture Basics",
                 description: """
Using the DragGesture to move entities.

**Issue:** This lab doesn't take into account the difference between the position of the entity and the starting position of th gesture **on that entity**. Depending on where you tap, you may see the entity "snap" to a new position when starting this gesture. 

We will fix this in another example.
""")

        ,Example(title: "Example 008",
                 type: .VOLUME,
                 date: Date("11/10/2024"),
                 isFeatured: false,
                 subtitle: "Magnify Gesture Basics",
                 description: """
Using the MagnifyGesture to scale entities.

**Issue:** This lab doesn't take into account the initial scale of the entity. If the entity starts at a scale of anything other than 1, you will see it "snap" to the starting scale of the gesture. 

We will fix this in another example.
""")

        ,Example(title: "Example 009",
                 type: .VOLUME,
                 date: Date("11/10/2024"),
                 isFeatured: false,
                 subtitle: "Rotate Gesture 3D Basics",
                 description: """
                 Using the RotateGesture3D to rotate entities around an axis.
                 
                 **Issue:** This lab doesn't take into account the initial orientation of the entity. If the entity has a rotation value on the Y axis is anything other than 0, you will see the entity "snap" to the starting value of the gesture. 
                 
                 We will fix this in another example.
                 """)

        ,Example(title: "Example 010",
                 type: .VOLUME,
                 date: Date("11/11/2024"),
                 isFeatured: false,
                 subtitle: "Drag Gesture Improved",
                 description: """
Expanding on Drag Gesture Basics to fix the "snapping" bug when the gesture first starts.

Capture the initial position of the entity when the gesture starts. Add the movement + initial position to get the new position.
""")

        ,Example(title: "Example 011",
                 type: .VOLUME,
                 date: Date("11/12/2024"),
                 isFeatured: false,
                 subtitle: "Magnify Gesture Improved",
                 description: """
Expanding on Magnify Gesture Basics to fix the "snapping" bug when the gesture first starts.

Capture the initial scale of the entity when the gesture starts. Multiply the magnification by the initial scale to get the new scale.
""")

        ,Example(title: "Example 012",
                 type: .VOLUME,
                 date: Date("11/13/2024"),
                 isFeatured: false,
                 subtitle: "Rotate Gesture 3D Improved",
                 description: """
                 Expanding on the RotateGesture3D basics example to fix the "snapping" bug when the gesture first starts.
                 
                 Capture the initial orientation when the gesture starts and add it to the rotation from the gesture.
                 """)

        ,Example(title: "Example 013",
                 type: .VOLUME,
                 date: Date("11/14/2024"),
                 isFeatured: true,
                 subtitle: "Combine gestures in a Sequence",
                 description: "An example of using SequenceGesture to create a Long Press + Drag gesture.")

        ,Example(title: "Example 014",
                 type: .VOLUME,
                 date: Date("11/15/2024"),
                 isFeatured: true,
                 subtitle: "Simultaneously combine gestures",
                 description: "An example of using SimultaneousGesture to create a Magnify + Rotate gesture.")

        ,Example(title: "Example 015",
                 type: .SPACE,
                 date: Date("12/11/2024"),
                 isFeatured: true,
                 subtitle: "Exploring SpatialEventGesture",
                 description: "What can we do with SpatialEventGesture?")

        ,Example(title: "Example 016",
                 type: .SPACE,
                 date: Date("12/04/2024"),
                 isFeatured: true,
                 subtitle: "We can hide the system hand menu in Immersive Spaces",
                 description: "SwiftUI has a modifier called `persistentSystemOverlays` that allows us to hide the system hand menu in Immersive Spaces.")

        ,Example(title: "Example 017",
                 type: .SPACE,
                 date: Date("12/10/2024"),
                 isFeatured: true,
                 subtitle: "Getting started with Hand Tracking",
                 description: "Explring two ways to anchor entities to our hands")

        ,Example(title: "Example 018",
                 type: .SPACE,
                 date: Date("12/12/2024"),
                 isFeatured: true,
                 subtitle: "Hand tracking with handAnchors(at:)",
                 description: "Explring a way to get the predicted post of hand anchors")

        ,Example(title: "Example 019",
                 type: .SPACE,
                 date: Date("12/15/2024"),
                 isFeatured: true,
                 subtitle: "AnchorEntity Hands",
                 description: "Using AnchorEntity in RealityKit without ARKit.")

    ]

}
