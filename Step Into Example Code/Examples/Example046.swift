//  Step Into Vision - Example Code
//
//  Title: Example046
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 2/10/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example046: View {
    var body: some View {
        RealityView { content in

            if let scene = try? await Entity(named: "GestureLabs", in: realityKitContentBundle) {
                content.add(scene)

                // Lower the entire scene to the bottom of the volume
                scene.position = [1, 1, -1.5]

            }

        }
        .modifier(DragGestureWithPivot046())
    }
}

fileprivate struct DragGestureWithPivot046: ViewModifier {

    @State var isDragging: Bool = false
    @State var initialPosition: SIMD3<Float> = .zero
    @State var pivotEntity: Entity = Entity()

    // TODO: cache the entities original parent so we can restore it when the gesture ends

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in

                        var pivotTransform = Transform()

                        if let inputDevicePose = value.inputDevicePose3D {

                            pivotTransform.scale = .one
                            pivotTransform.translation = value.convert(inputDevicePose.position, from: .local, to: .scene)
                            pivotTransform.rotation = value.convert(AffineTransform3D(rotation: inputDevicePose.rotation), from: .local, to: .scene).rotation

                        } else {

                            pivotTransform.translation = value.convert(value.location3D, from: .local, to: .scene)
                        }

                        if !isDragging {
                            isDragging = true
                            initialPosition = value.entity.position
                            value.entity.parent?.addChild(pivotEntity)

                            pivotEntity.move(to: pivotTransform, relativeTo: nil)
                            pivotEntity.addChild(value.entity, preservingWorldTransform: true)

                        } else {
                            pivotEntity.move(to: pivotTransform, relativeTo: nil, duration: 0.2)
                        }


                    }
                    .onEnded { value in
                        isDragging = false
                        pivotEntity = Entity()
                        // TODO: remove the value.entity from the pivotEntity and place it back where it started in the hierarchy
                    }
            )

    }
}

#Preview {
    Example046()
}
