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
//  Created by Joseph Simpson on 9/24/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example104: View {

//    @State private var left

    @State private var leftKind = ""
    @State private var rightKind = ""
    @State private var otherKind = ""

    var body: some View {
        RealityView { content in

            let subject = createStepDemoBox()

            // We'll use configureEntity to set up input and collision on the subject
            ManipulationComponent
                .configureEntity(
                    subject,
                    hoverEffect: .spotlight(.default),
                    collisionShapes: [.generateBox(width: 0.25, height: 0.25, depth: 0.25)]
                )



            _ = content.subscribe(to: ManipulationEvents.WillBegin.self) { event in
                event.entity.playAudio(Example089.drop001Audio)

                guard let inputDevice = event.inputDeviceSet.first else { return }

                if inputDevice.chirality == .left {
                    leftKind = unpackKind(inputDevice.kind)
                }


                if inputDevice.chirality == .right {
                    rightKind = unpackKind(inputDevice.kind)
                }

            
            }


            _ = content.subscribe(to: ManipulationEvents.WillRelease.self) { event in
                event.entity.playAudio(Example089.drop002Audio)
                leftKind = "none"
                rightKind = "none"
                otherKind = "none"
            }


            content.add(subject)

        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack(spacing: 12) {
                    Text(leftKind)
                    Spacer()
                    Text(otherKind)
                    Spacer()
                    Text(rightKind)
                }
            })

        }
    }

    func unpackKind(_ kind: ManipulationComponent.InputDevice.Kind) -> String {
        switch kind {
        case .pointer:
            return "pointer"
        case .directPinch:
            return "directPinch"
        case .indirectPinch:
            return "indirectPinch"
        default:
            return ""
        }
    }
}

#Preview {
    Example104()
}
