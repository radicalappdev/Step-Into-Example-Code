//  Step Into Vision - Example Code
//
//  Title: Example015
//
//  Subtitle: Working with SpatialEventGesture
//
//  Description:
//
//  Type: Space
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/11/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example015: View {

    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "SpatialEventLab", in: realityKitContentBundle) else { return }
            scene.position.z = -0.5
            content.add(scene)
        }
        .modifier(SpatialEventGestureExample())
    }
}

#Preview {
    Example015()
}

fileprivate struct SpatialEventGestureExample: ViewModifier {
    @State var isDragging: Bool = false
    @State var targetEntity: Entity?
    @State var lastHandPosition: SIMD3<Float>?
    
    func body(content: Content) -> some View {
        content
            .gesture(
                SpatialEventGesture()
                    .onChanged { events in
                        // If we're dragging but there are no events targeting our entity, end the drag
                        if isDragging && !events.contains(where: { $0.targetedEntity === targetEntity }) {
                            print("Lost target, ending drag")
                            isDragging = false
                            targetEntity = nil
                            lastHandPosition = nil
                            return
                        }
                        
                        for event in events {
                            // Only process active events
                            guard event.phase == .active else { continue }
                            
                            if !isDragging {
                                // Only grab a new entity if we're not already dragging
                                if let entity = event.targetedEntity {
                                    targetEntity = entity
                                    lastHandPosition = SIMD3(
                                        Float(event.location3D.x),
                                        Float(-event.location3D.y),
                                        Float(event.location3D.z)
                                    )
                                    isDragging = true
                                }
                            } else if let entity = targetEntity,
                                      let lastHand = lastHandPosition,
                                      event.targetedEntity === entity {
                                // Continue moving the same entity
                                let currentHandPosition = SIMD3(
                                    Float(event.location3D.x),
                                    Float(-event.location3D.y),
                                    Float(event.location3D.z)
                                )
                                
                                let delta = (currentHandPosition - lastHand) * 0.001
                                entity.position += delta
                                lastHandPosition = currentHandPosition
                            }
                        }
                    }
            )
    }
}
