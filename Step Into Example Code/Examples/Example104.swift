//  Step Into Vision - Example Code
//
//  Title: Example104
//
//  Subtitle: Reading input data from Manipulation Component
//
//  Description: We can use chirality and kind to customize input based on the user's hand or input device.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 9/24/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example104: View {

    @State private var leftKind = ""
    @State private var rightKind = ""

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
                guard let inputDevice = event.inputDeviceSet.first else { return }
                unpackChirality(inputDevice.chirality, value: unpackKind(inputDevice.kind)) // track the kind per hand/device
            }

            _ = content.subscribe(to: ManipulationEvents.DidHandOff.self) { event in
                guard let oldInputDeviceSet = event.oldInputDeviceSet.first else { return }
                unpackChirality(oldInputDeviceSet.chirality, value: "") // track the kind per hand/device
                guard let newInputDeviceSet = event.newInputDeviceSet.first else { return }
                unpackChirality(newInputDeviceSet.chirality, value: unpackKind(newInputDeviceSet.kind)) // track the kind per hand/device
            }

            _ = content.subscribe(to: ManipulationEvents.WillRelease.self) { event in
                guard let inputDevice = event.inputDeviceSet.first else { return }
                unpackChirality(inputDevice.chirality, value: "") // clear the correct value on release
            }

            content.add(subject)

        }
        .ornament(attachmentAnchor: .scene(.topLeading), ornament: {
            Text(leftKind)
                .frame(width: 160)
                .padding()
                .background(leftKind.isEmpty ? .clear : .green)
                .glassBackgroundEffect()
        })

        .ornament(attachmentAnchor: .scene(.topTrailing), ornament: {
            Text(rightKind)
                .frame(width: 160)
                .padding()
                .background(rightKind.isEmpty ? .clear : .green)
                .glassBackgroundEffect()
        })
    }

    func unpackChirality(_ chirality: ManipulationComponent.InputDevice.Chirality?, value: String) {
        switch chirality {
        case .left:
            leftKind = value
        case .right:
            rightKind = value
        case .none:
            return
        @unknown default:
            return
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
