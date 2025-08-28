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
                 isFeatured: false,
                 subtitle: "Combine gestures in a Sequence",
                 description: "An example of using SequenceGesture to create a Long Press + Drag gesture.")

        ,Example(title: "Example 014",
                 type: .VOLUME,
                 date: Date("11/15/2024"),
                 isFeatured: false,
                 subtitle: "Simultaneously combine gestures",
                 description: "An example of using SimultaneousGesture to create a Magnify + Rotate gesture.")

        ,Example(title: "Example 015",
                 type: .SPACE,
                 date: Date("12/11/2024"),
                 isFeatured: false,
                 subtitle: "Exploring SpatialEventGesture",
                 description: "What can we do with SpatialEventGesture?")

        ,Example(title: "Example 016",
                 type: .SPACE,
                 date: Date("12/04/2024"),
                 isFeatured: false,
                 subtitle: "We can hide the system hand menu in Immersive Spaces",
                 description: "SwiftUI has a modifier called `persistentSystemOverlays` that allows us to hide the system hand menu in Immersive Spaces.")

        ,Example(title: "Example 017",
                 type: .SPACE,
                 date: Date("12/10/2024"),
                 isFeatured: false,
                 subtitle: "Getting started with Hand Tracking",
                 description: "Explring two ways to anchor entities to our hands")

        ,Example(title: "Example 018",
                 type: .SPACE,
                 date: Date("12/12/2024"),
                 isFeatured: false,
                 subtitle: "Hand tracking with handAnchors(at:)",
                 description: "Explring a way to get the predicted post of hand anchors")

        ,Example(title: "Example 019",
                 type: .SPACE,
                 date: Date("12/15/2024"),
                 isFeatured: false,
                 subtitle: "AnchorEntity Hands",
                 description: "Using AnchorEntity in RealityKit without ARKit.")

        ,Example(title: "Example 020",
                 type: .SPACE,
                 date: Date("12/18/2024"),
                 isFeatured: false,
                 subtitle: "AnchorEntity Locations and Joints for Hands",
                 description: "Unpacking all the locations and joints that we can track with AnchorEntity in RealityKit.")

        ,Example(title: "Example 021",
                 type: .SPACE,
                 date: Date("12/21/2024"),
                 isFeatured: false,
                 subtitle: "Hand Anchored Collision Triggers",
                 description: "We can add a Spatial Tracking Session if we need to track collision triggers in our scene.")

        ,Example(title: "Example 022",
                 type: .SPACE,
                 date: Date("12/23/2024"),
                 isFeatured: false,
                 subtitle: "Set trackingMode on a hand AnchorEntity",
                 description: "The default tracking mode `.continuous` is very accurate but it can lag slightly behind. We can also use `.predicted`, which can feel much faster but it has a tendency to overshoot during very fast motions.")

        ,Example(title: "Example 023",
                 type: .SPACE,
                 date: Date("12/23/2024"),
                 isFeatured: false,
                 subtitle: "Hand Anchored Physics Interactions",
                 description: "We can add a Spatial Tracking Session if we need our hands to interact with physics bodies.")

        ,Example(title: "Example 024",
                 type: .SPACE,
                 date: Date("12/23/2024"),
                 isFeatured: false,
                 subtitle: "Access Hand Anchor Transforms",
                 description: "We can add a Spatial Tracking Session if we need to access the transforms of hand anchors.")

        ,Example(title: "Example 025",
                 type: .SPACE,
                 date: Date("12/30/2024"),
                 isFeatured: false,
                 subtitle: "How to use Anchoring Component with hands",
                 description: "Creating entities with anchoring components attached instead of using AnchorEntity.")

        ,Example(title: "Example 026",
                 type: .VOLUME,
                 date: Date("12/30/2024"),
                 isFeatured: false,
                 subtitle: "Multiple Taps with Tap Gesture",
                 description: "Using `TapGesture(count:)` to create a double tap.")

        ,Example(title: "Example 027",
                type: .WINDOW,
                date: Date("1/9/2024"),
                isFeatured: false,
                subtitle: "Spatial SwiftUI: shadow modifier",
                description: "Using shadows on 2D views to convey depth.")

        ,Example(title: "Example 028",
                 type: .SPACE,
                 date: Date("1/1/2025"),
                 isFeatured: false,
                 subtitle: "Using Anchoring Component with Spatial Tracking Session",
                 description: "We can add a Spatial Tracking Session if we need to use hand tracking features such as physics, collisions, and accessing transforms.")

        ,Example(title: "Example 029",
                 type: .WINDOW,
                 date: Date("1/3/2025"),
                 isFeatured: false,
                 subtitle: "How to show and hide the window bar",
                 description: "We can use `persistentSystemOverlays(_:)` to control the visibility of the window drag bar.")

        ,Example(title: "Example 030",
                 type: .WINDOW,
                 date: Date("1/4/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: offset",
                 description: "Using z axis offset to lift our views out of their window.")

        ,Example(title: "Example 031",
                 type: .SPACE,
                 date: Date("1/7/2025"),
                 isFeatured: false,
                 subtitle: "How to set up Spatial Tracking Session",
                 description: "Configure and run a Spatial Tracking Session in RealityKit.")

        ,Example(title: "Example 032",
                 type: .WINDOW_ALT,
                 date: Date("1/6/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: rotation3DEffect",
                 description: "Using rotation3DEffect to rotate views in a window.")

        ,Example(title: "Example 033",
                 type: .WINDOW,
                 date: Date("1/8/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: transform3DEffect",
                 description: "Exploring some uses of transform3DEffect.")

        ,Example(title: "Example 034",
                 type: .SPACE,
                 date: Date("1/9/2025"),
                 isFeatured: false,
                 subtitle: "Detecting a floor with Anchor Entity and Spatial Tracking Session",
                 description: "")

        ,Example(title: "Example 035",
                 type: .WINDOW,
                 date: Date("1/10/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: hoverEffect modifier",
                 description: "Taking a look (😜) at the hoverEffect modifier.")

        ,Example(title: "Example 036",
                 type: .WINDOW,
                 date: Date("1/12/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: ZStack and frame(depth:)",
                 description: "Three simple methods to stack and space views.")

        ,Example(title: "Example 037",
                 type: .WINDOW,
                 date: Date("1/20/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: Window Ornaments",
                 description: "Ornaments allow us to decorate our windows with information and controls that may not fit in the main window region.")

        ,Example(title: "Example 038",
                 type: .VOLUME,
                 date: Date("1/24/2025"),
                 isFeatured: false,
                 subtitle: "RealityKit Basics: Create Shapes",
                 description: "Creating primitive shapes in code.")

        ,Example(title: "Example 039",
                 type: .VOLUME,
                 date: Date("1/24/2025"),
                 isFeatured: false,
                 subtitle: "RealityKit Basics: Entities and Components",
                 description: "Taking a deeper look at creating entities with multiple components.")

        ,Example(title: "Example 040",
                 type: .VOLUME,
                 date: Date("1/25/2025"),
                 isFeatured: false,
                 subtitle: "RealityKit Basics: RealityView",
                 description: "Exploring a SwiftUI view that contains RealtiyKit content.")

        ,Example(title: "Example 041",
                 type: .VOLUME,
                 date: Date("1/26/2025"),
                 isFeatured: false,
                 subtitle: "RealityKit Basics: Loading content from Reality Composer Pro",
                 description: "Loading scenes and assets RealityView.")

        ,Example(title: "Example 042",
                 type: .VOLUME,
                 date: Date("1/27/2025"),
                 isFeatured: false,
                 subtitle: "RealityKit Basics: Interaction",
                 description: "Using system gestures to interact with entities in RealityKit.")

        ,Example(title: "Example 043",
                 type: .VOLUME,
                 date: Date("1/28/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: Volume Ornaments",
                 description: "Ornaments on Volumes work much like Ornaments on Windows. Volumes have more anchors and a feature to reorient them when them when a user moves around the volume.")

        ,Example(title: "Example 044",
                 type: .WINDOW_ALT,
                 date: Date("2/3/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: Window Toolbars",
                 description: "SwiftUI Toolbars are presented as Ornaments at the bottom of the window.")

        ,Example(title: "Example 045",
                 type: .WINDOW,
                 date: Date("2/3/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: Window TabViews",
                 description: "SwiftUI TabViews are presented as Ornaments at the left side of the window.")

        ,Example(title: "Example 046",
                 type: .SPACE,
                 date: Date("2/10/2025"),
                 isFeatured: false,
                 subtitle: "Drag Gesture with Pivot",
                 description: "We can use the location3D values of the gesture to improve dragging when the user turns to face another direction.")

        ,Example(title: "Example 047",
                 type: .VOLUME,
                 date: Date("2/13/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: Volume Toolbars",
                 description: "SwiftUI Toolbars are presented as Ornaments at the bottom of the volume.")

        ,Example(title: "Example 048",
                 type: .VOLUME,
                 date: Date("2/14/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: Volume TabViews",
                 description: "SwiftUI TabViews are presented as Ornaments at the front leading anchor of the volume.")

        ,Example(title: "Example 049",
                 type: .VOLUME,
                 date: Date("2/17/2025"),
                 isFeatured: false,
                 subtitle: "RealityKit Basics: update closure",
                 description: "The update closure will run when any referenced state changes. We can reach into our RealityView content to modify entities or components.")

        ,Example(title: "Example 050",
                 type: .VOLUME,
                 date: Date("2/18/2025"),
                 isFeatured: false,
                 subtitle: "RealityKit Basics: attachments",
                 description: "We can create 2D SwiftUI attachments and add them to out 3D scenes as entities.")

        ,Example(title: "Example 051",
                 type: .WINDOW,
                 date: Date("2/25/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: Model3D",
                 description: "Model3D is a simple view that can load a USD or `.reality` file and display it in your SwiftUI view.")

        ,Example(title: "Example 052",
                 type: .VOLUME,
                 date: Date("2/28/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: Background UI for Volumes",
                 description: "We can use the back anchors for ornaments to to display user interfaces and data related to our content.")

        ,Example(title: "Example 053",
                 type: .VOLUME,
                 date: Date("3/03/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: Volumetric presentation with attachments",
                 description: "As of visionOS 2, we can not use the SwiftUI presentations API with RealityView attachments.")

        ,Example(title: "Example 054",
                 type: .VOLUME,
                 date: Date("3/04/2025"),
                 isFeatured: false,
                 subtitle: "Spatfalseial SwiftUI: Volumetric pickers with attachments",
                 description: "As of visionOS 2, we can not use the SwiftUI presentations API with RealityView attachments.")

        ,Example(title: "Example 055",
                 type: .VOLUME,
                 date: Date("3/10/2025"),
                 isFeatured: false,
                 subtitle: "Collisions & Physics: Getting started with Collision Component",
                 description: "This component is vital to user input, collision detection, and physics.")

        ,Example(title: "Example 056",
                 type: .VOLUME,
                 date: Date("3/10/2025"),
                 isFeatured: false,
                 subtitle: "Collisions & Physics: Collision Use Cases",
                 description: "The Collision Component is used input, collision detection, and physics.")

        ,Example(title: "Example 057",
                 type: .VOLUME,
                 date: Date("3/17/2025"),
                 isFeatured: false,
                 subtitle: "Collisions & Physics: Generating Collision Meshes",
                 description: "RealityKit provides a few methods to generate complex collision shapes, with one notable omission.")

        ,Example(title: "Example 058",
                 type: .VOLUME,
                 date: Date("3/24/2025"),
                 isFeatured: false,
                 subtitle: "Collisions & Physics: Collision Modes",
                 description: "Exploring Triggers and Rigid Bodies in RealityKit")

        ,Example(title: "Example 059",
                 type: .VOLUME,
                 date: Date("3/25/2025"),
                 isFeatured: false,
                 subtitle: "Collisions & Physics: Collision Events",
                 description: "A few examples of how to respond to collisions in RealityKit.")

        ,Example(title: "Example 060",
                 type: .VOLUME,
                 date: Date("3/31/2025"),
                 isFeatured: false,
                 subtitle: "Collisions & Physics: Getting Started with Physics Body Component",
                 description: "Adding the component in code and in Reality Composer Pro.")

        ,Example(title: "Example 061",
                 type: .SPACE,
                 date: Date("4/01/2025"),
                 isFeatured: false,
                 subtitle: "RealityKit Basics: Placing attachments in a scene",
                 description: "Three options for how to place place attachments in a scene.")

        ,Example(title: "Example 062",
                 type: .VOLUME,
                 date: Date("4/02/2025"),
                 isFeatured: false,
                 subtitle: "Collisions & Physics: Hello Physics Simulation Component",
                 description: "We can override the default physics by using this component.")

        ,Example(title: "Example 063",
                 type: .VOLUME,
                 date: Date("4/03/2025"),
                 isFeatured: false,
                 subtitle: "Collisions & Physics: Hello Physics Motion Component",
                 description: "We can use this component to read or write angular and linear velocity.")

        ,Example(title: "Example 064",
                 type: .VOLUME,
                 date: Date("4/04/2025"),
                 isFeatured: false,
                 subtitle: "Collisions & Physics: Hello Physics Joints Component",
                 description: "We can create collections of entities that are linked together.")

        ,Example(title: "Example 065",
                 type: .VOLUME,
                 date: Date("4/07/2025"),
                 isFeatured: false,
                 subtitle: "Collisions & Physics: Physics Mass Properties",
                 description: "We can adjust mass, inertia, and center of mass for Physics Bodies.")

        ,Example(title: "Example 066",
                 type: .VOLUME,
                 date: Date("4/08/2025"),
                 isFeatured: false,
                 subtitle: "Collisions & Physics: Physics Material",
                 description: "We can adjust friction and restitution.")

        ,Example(title: "Example 067",
                 type: .VOLUME,
                 date: Date("4/10/2025"),
                 isFeatured: false,
                 subtitle: "RealityKit Basics: Modify Component Values",
                 description: "How do we change the values of our components?")

        ,Example(title: "Example 068",
                 type: .SPACE,
                 date: Date("4/14/2025"),
                 isFeatured: false,
                 subtitle: "ARKit: Set up and use an ARKit Session",
                 description: "Covering the basics to creating and running an ARKitSession with a DataProvider.")

        ,Example(title: "Example 069",
                 type: .SPACE,
                 date: Date("4/15/2025"),
                 isFeatured: false,
                 subtitle: "ARKit PlaneDetectionProvider: visualize detected planes",
                 description: "Converting anchor geometry into a meshes we can render.")

        ,Example(title: "Example 070",
                 type: .SPACE,
                 date: Date("4/16/2025"),
                 isFeatured: false,
                 subtitle: "ARKit PlaneDetectionProvider: adding collisions and physics",
                 description: "Converting anchor geometry into collision shapes.")

        ,Example(title: "Example 071",
                 type: .SPACE,
                 date: Date("4/17/2025"),
                 isFeatured: false,
                 subtitle: "ARKit PlaneDetectionProvider: classification and alignment",
                 description: "We can filter anchors based on classification or alignment values.")

        ,Example(title: "Example 072",
                 type: .SPACE,
                 date: Date("4/18/2025"),
                 isFeatured: false,
                 subtitle: "ARKit PlaneDetectionProvider: creating simple planes from anchors",
                 description: "We can use the extent of the anchor to create simple planes and colliders.")

        ,Example(title: "Example 073",
                 type: .SPACE,
                 date: Date("4/19/2025"),
                 isFeatured: false,
                 subtitle: "ARKit PlaneDetectionProvider: occlusion material",
                 description: "We can use Occlusion material to hide our planes while letting them participate in collisions and physics.")

        ,Example(title: "Example 074",
                 type: .SPACE,
                 date: Date("4/20/2025"),
                 isFeatured: false,
                 subtitle: "ARKit PlaneDetectionProvider: adding an entity to an anchor",
                 description: "Placing virtual content on a plane anchor.")

        ,Example(title: "Example 075",
                 type: .WINDOW,
                 date: Date("4/20/2025"),
                 isFeatured: false,
                 subtitle: "RealityKit Basics: Modify Material Values",
                 description: "Changing material values is similar to changing component values, but with a few considerations.")

        ,Example(title: "Example 076",
                 type: .SPACE,
                 date: Date("4/23/2025"),
                 isFeatured: false,
                 subtitle: "Placing an entity on a wall using Anchoring Component",
                 description: "We can use Anchoring Component to describe anchors that RealityKit should track.")

        ,Example(title: "Example 077",
                 type: .VOLUME,
                 date: Date("4/24/2025"),
                 isFeatured: false,
                 subtitle: "RealityKit Basics: moving entities",
                 description: "We can use `move(to:)` and its variants to move entities to new locations.")

        ,Example(title: "Example 078",
                 type: .VOLUME,
                 date: Date("4/27/2025"),
                 isFeatured: false,
                 subtitle: "RealityKit Basics: pointing entities",
                 description: "We can use `look(at:)` and its variants to orient entities to new directions.")

        ,Example(title: "Example 079",
                 type: .SPACE,
                 date: Date("4/28/2025"),
                 isFeatured: true,
                 subtitle: "ARKit WorldTrackingProvider: ",
                 description: "")

        ,Example(title: "Example 080",
                 type: .VOLUME,
                 date: Date("5/19/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: Physical Metrics",
                 description: "Scaling entities to exact real world metrics.")

        ,Example(title: "Example 081",
                 type: .VOLUME,
                 date: Date("5/20/2025"),
                 isFeatured: false,
                 subtitle: "Spatial SwiftUI: GeometryReader3D",
                 description: "Reading Size3D and BoundingBox data from a proxy.")

        ,Example(title: "Example 082",
                 type: .SPACE,
                 date: Date("6/15/2025"),
                 isFeatured: false,
                 subtitle: "RealityKit Basics: Using ViewAttachmentComponent",
                 description: "visionOS 26 brings us a new way to create attachments right along side our entities.")

        ,Example(title: "Example 083",
                 type: .WINDOW,
                 date: Date("6/22/2025"),
                 isFeatured: false,
                 subtitle: "How to read window snapping state and classification",
                 description: "We can use the surfaceSnappingInfo environment value to access window snapping data.")

        ,Example(title: "Example 084",
                 type: .VOLUME,
                 date: Date("6/23/2025"),
                 isFeatured: false,
                 subtitle: "How to read volume snapping state and classification",
                 description: "We can use the surfaceSnappingInfo environment value to access volume snapping data.")

        ,Example(title: "Example 085",
                 type: .VOLUME,
                 date: Date("6/26/2025"),
                 isFeatured: false,
                 subtitle: "Using presentations in Volumes",
                 description: "The era of \"Presentations are not currently supported in Volumetric contexts.\" is over")

        ,Example(title: "Example 086",
                 type: .VOLUME,
                 date: Date("6/28/2025"),
                 isFeatured: false,
                 subtitle: "Constrain position with Manipulation Component",
                 description: "Using the DidUpdateTransform to constrain the position of a manipulated entity.")

        ,Example(title: "Example 087",
                 type: .VOLUME,
                 date: Date("6/30/2025"),
                 isFeatured: false,
                 subtitle: "Getting started with Manipulation Component",
                 description: "A simple but powerful component to interact with entities in RealityKit.")

        ,Example(title: "Example 088",
                 type: .VOLUME,
                 date: Date("7/01/2025"),
                 isFeatured: false,
                 subtitle: "Using events with Manipulation Component",
                 description: "We can use events to modify the entity during the gesture or save state at the end.")

        ,Example(title: "Example 089",
                 type: .VOLUME,
                 date: Date("7/02/2025"),
                 isFeatured: false,
                 subtitle: "Using custom sounds with Manipulation Component",
                 description: "We can silence the provided system sounds and play our own using Manipulation Events.")

        ,Example(title: "Example 090",
                 type: .VOLUME,
                 date: Date("7/03/2025"),
                 isFeatured: false,
                 subtitle: "Redirect input with Manipulation Component",
                 description: "We can use HitTargetComponent to send manipulation input from one entity to another.")

        ,Example(title: "Example 091",
                 type: .WINDOW,
                 date: Date("7/06/2025"),
                 isFeatured: true,
                 subtitle: "Spatial SwiftUI: Layout Depth Alignment",
                 description: "We can use `.depthAlignment` to align views in a 3D space.")

        ,Example(title: "Example 092",
                 type: .WINDOW,
                 date: Date("7/07/2025"),
                 isFeatured: true,
                 subtitle: "Spatial SwiftUI: rotation3DLayout",
                 description: "A rotation modifier that will impact frame and layout.")

        ,Example(title: "Example 093",
                 type: .WINDOW,
                 date: Date("7/08/2025"),
                 isFeatured: true,
                 subtitle: "Spatial SwiftUI: spatialOverlay",
                 description: "We can add secondary content within the bounds of views.")

        ,Example(title: "Example 094",
                 type: .WINDOW,
                 date: Date("7/09/2025"),
                 isFeatured: true,
                 subtitle: "Spatial SwiftUI: SpatialContainer",
                 description: "A Layout that can align overlapping views, allowing multiple views to exist in one space.")

        ,Example(title: "Example 095",
                 type: .VOLUME,
                 date: Date("7/09/2025"),
                 isFeatured: true,
                 subtitle: "Spatial SwiftUI: realityViewSizingBehavior",
                 description: "A modifier that controls frame and alignment for RealityView.")

        ,Example(title: "Example 096",
                 type: .WINDOW,
                 date: Date("7/22/2025"),
                 isFeatured: true,
                 subtitle: "Spatial SwiftUI: scaling views",
                 description: "We can use two convenient modifiers to scale views based on their parent size.")

        ,Example(title: "Example 097",
                 type: .WINDOW,
                 date: Date("8/20/2025"),
                 isFeatured: true,
                 subtitle: "Spatial SwiftUI: manipulable modifier",
                 description: "")

        ,Example(title: "Example 098",
                 type: .VOLUME,
                 date: Date("8/27/2025"),
                 isFeatured: true,
                 subtitle: "Spatial SwiftUI: Breakthrough Effect",
                 description: "We can use this new modifier to keep content visible even when it is blocked other views or content.")

        ,Example(title: "Example 099",
                 type: .VOLUME,
                 date: Date("8/27/2025"),
                 isFeatured: true,
                 subtitle: "Spatial SwiftUI: Presentation Breakthrough Effect",
                 description: "We can use this new modifier to override the system default breakthrough effect for presentations.")


    ]
        
}
