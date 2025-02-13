//  Step Into Vision - Example Code
//
//  Title: Example047
//
//  Subtitle: Spatial SwiftUI: Volume Toolbars
//
//  Description: SwiftUI Toolbars are presented as Ornaments at the bottom of the volume.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 2/13/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example047: View {

    @State private var transformMode: IndirectTransformMode = .none
    @State var earth: Entity = Entity()
    @State var earthTransform: Transform = Transform()

    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "RKBasicsLoading", in: realityKitContentBundle) {
                content.add(scene)
                scene.position.y = -0.4

                if let earth = scene.findEntity(named: "Earth") {
                    self.earth = earth
                    self.earthTransform = earth.transform
                }

                if let moon = scene.findEntity(named: "Moon") {
                    moon.removeFromParent() // We don't need the moon for this example

                }

            }
        }
        .modifier(IndirectTransformGesture(mode: $transformMode))
        // Add the toolbar modifier
        .toolbar {
            // Create a ToolbarItemGroup with a placement
            // .bottomOrnament seems to be the only placement that works
            ToolbarItemGroup(placement: .bottomOrnament) {

                Button {
                    earth.move(to: earthTransform, relativeTo: earth.parent!, duration: 0.3)
                } label: {
                    Image(systemName: "arrow.clockwise")

                }

                Spacer()
                Divider()
                Spacer()

                Button {
                    transformMode = .none
                } label: {
                    Image(systemName: "nosign")
                }
                .background(transformMode == .none ? .stepRed : Color.clear)
                .clipShape(.capsule)

                Button {
                    transformMode = .move
                } label: {
                    Image(systemName: "move.3d")
                }
                .background(transformMode == .move ? .stepRed : Color.clear)
                .clipShape(.capsule)

                Button {
                    transformMode = .rotate
                } label: {
                    Image(systemName: "rotate.3d")
                }
                .background(transformMode == .rotate ? .stepRed : Color.clear)
                .clipShape(.capsule)

                Button {
                    transformMode = .scale
                } label: {
                    Image(systemName: "scale.3d")
                }
                .background(transformMode == .scale ? .stepRed : Color.clear)
                .clipShape(.capsule)
            }

        }
    }
}

#Preview {
    Example047()
}
