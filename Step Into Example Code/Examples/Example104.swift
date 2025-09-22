//  Step Into Vision - Example Code
//
//  Title: Example104
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 9/22/25.

import SwiftUI
import RealityKit
import RealityKitContent
import GameController

struct Example104: View {

    init() {

        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.GCControllerDidConnect,
            object: nil,
            queue: nil) { notification in
                if let controller = notification.object as? GCController {
                    switch controller.productCategory {
                    case GCProductCategorySpatialController:
                        // A spatial controller connected.
                        print("controller connected as spatial")
                    default:
                        // A standard controller connected.
                        print("something else connected")
                    }
                }
            }
    }


    var body: some View {
        RealityView { content in

        }
    }
}

#Preview {
    Example104()
}
