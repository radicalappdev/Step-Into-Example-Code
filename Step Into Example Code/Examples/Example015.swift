//  Step Into Vision - Example Code
//
//  Title: Example015
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 12/11/24.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example015: View {

    
    
    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "SpatialEventLab", in: realityKitContentBundle) {
                content.add(scene)

            }


        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
        .modifier(SpatialEventGestureExample())
    }

}

#Preview {
    Example015()
}

struct SpatialEventGestureExample: ViewModifier {
    @State var isDragging: Bool = false
    @State var targetEntity: Entity?
    @State var lastHandPosition: SIMD3<Float>?
    
    func body(content: Content) -> some View {
        content
            .gesture(
                SpatialEventGesture()
                    .onChanged { events in
                        for event in events {
                            switch event.phase {
                            case .active:
                                if !isDragging {
                                    // Just grab the entity and start tracking
                                    if let entity = event.targetedEntity {
                                        targetEntity = entity
                                        lastHandPosition = SIMD3(
                                            Float(event.location3D.x),
                                            Float(event.location3D.y),
                                            Float(event.location3D.z)
                                        )
                                        isDragging = true
                                    }
                                } else {
                                    // Move the entity with a very small fraction of the hand movement
                                    guard let entity = targetEntity,
                                          let lastHand = lastHandPosition else { return }
                                        
                                    let currentHandPosition = SIMD3(
                                        Float(event.location3D.x),
                                        Float(event.location3D.y),
                                        Float(event.location3D.z)
                                    )
                                    
                                    // Calculate a tiny movement delta
                                    let delta = (currentHandPosition - lastHand) * 0.001
                                    
                                    // Apply small incremental change
                                    entity.position += delta
                                    
                                    // Update for next frame
                                    lastHandPosition = currentHandPosition
                                }
                                    
                            case .ended, .cancelled:
                                isDragging = false
                                targetEntity = nil
                                lastHandPosition = nil
                            }
                        }
                    }
            )
    }
}
