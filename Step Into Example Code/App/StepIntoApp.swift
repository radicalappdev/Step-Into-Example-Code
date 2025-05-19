//
//  Step_Into_Example_CodeApp.swift
//  Step Into Example Code
//
//  Created by Joseph Simpson on 10/15/24.
//

import SwiftUI

@main
struct StepIntoApp: App {
    @State private var appModel = AppModel()
    @State private var modelData = ModelData()
    @State private var exampleImmersionStyle: ImmersionStyle = .full

    var body: some Scene {

        // Main window
        WindowGroup {
            Directory()
                .environment(appModel)
                .environment(modelData)
        }
        .defaultSize(CGSize(width: 700, height: 640))

        // Router scenes

        // 1. Window: Use this window group to open 2D windows with Example Content based on the Router
        WindowGroup(id: "RouterWindow", for: String.self, content: { $route in
            ExampleRouter(route: $route)
        })
        .defaultSize(CGSize(width: 680, height: 400))
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first {
                return WindowPlacement(.trailing(mainWindow))
            }
            return WindowPlacement(.none)
        }

        // 1. Window: Use this window group to open 2D windows with Example Content based on the Router
        WindowGroup(id: "RouterWindowAlt", for: String.self, content: { $route in
            ExampleRouter(route: $route)
        })
        .windowStyle(.plain)
        .defaultSize(CGSize(width: 680, height: 400))
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first {
                return WindowPlacement(.trailing(mainWindow))
            }
            return WindowPlacement(.none)
        }

        // 2. Volume:  Use this window group to open 3D Volumes
        WindowGroup(id: "RouterVolume", for: String.self, content: { $route in
            let initialSize = Size3D(width: 500, height: 500, depth: 500)
            let scaler = 4.0
            ExampleRouter(route: $route)
                .frame(minWidth: initialSize.width, maxWidth: initialSize.width * scaler,
                       minHeight: initialSize.height, maxHeight: initialSize.height * scaler)
                .frame(minDepth: initialSize.depth, maxDepth: initialSize.depth * scaler)

        })
        .windowStyle(.volumetric)
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first {
                return WindowPlacement(.trailing(mainWindow))
            }
            return WindowPlacement(.none)
        }

        .windowResizability(.contentSize)

        // 3. Space:  Use this immersive scene to open a example in a full space
        ImmersiveSpace(id: "RouterSpace", for: String.self, content: { $route in
            ExampleRouter(route: $route)
        })

        // 4. Space Full:  Use this immersive scene to open a example in a full space
        ImmersiveSpace(id: "RouterSpaceFull", for: String.self, content: { $route in
            ExampleRouter(route: $route)
        })
        .immersionStyle(selection: $exampleImmersionStyle, in: .full)

    }

}
