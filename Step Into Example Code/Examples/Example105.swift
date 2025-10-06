//  Step Into Vision - Example Code
//
//  Title: Example105
//
//  Subtitle: Spatial SwiftUI: Manipulation modifiers
//
//  Description: We can use the SwiftUI equivalent of Manipulation Component as a modifier.
//
//  Type: Window
//
//  Created by Joseph Simpson on 9/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example105: View {

    @State private var manipulationState = Manipulable.GestureState()
    @State private var onChangeVectorExample: SIMD3<Float> = .zero
    @State private var showDebugLines = false
    @State private var manipulationEnabled = true

    let frameSize: CGFloat = 100

    var body: some View {
        VStackLayout().depthAlignment(.center) {

            /// Demo 01: Default implementation of manipulable()
            HStackLayout().depthAlignment(.center) {

                VStack {
                    Text("manipulable()")
                        .font(.title)
                    Text("Default implementation")
                        .font(.caption)
                }
                .padding()
                .background(.black)
                .cornerRadius(24)
                .shadow(radius: 20)
                .frame(width: 220, height: 160)
                .manipulable()
                .hoverEffect()

                ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
                    .frame(width: frameSize, height: frameSize)
                    .manipulable()
                    .hoverEffect()

                ModelViewSimple(name: "ToyRocket", bundle: realityKitContentBundle)
                    .frame(width: frameSize, height: frameSize)
                    .manipulable()
                    .hoverEffect()

            }
            .debugBorder3D(showDebugLines ? .white : .clear)

            /// Demo 02: Redirecting input using manipulable and manipulationGesture
            HStackLayout().depthAlignment(.center) {

                HStackLayout().depthAlignment(.center) {

                    VStack {
                        Text("Redirected")
                            .font(.headline)
                        Text("Input is redirected from Earth to the Moon")
                            .font(.caption)
                    }
                    .padding()
                    .background(.black)
                    .cornerRadius(24)
                    .shadow(radius: 20)
                    .frame(width: 180, height: 120)

                    SpatialContainer(alignment: .topLeadingFront) {
                        ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
                            .frame(width: frameSize, height: frameSize)
                            .padding(24)
                            .manipulationGesture(updating: $manipulationState)
                            .hoverEffect()

                        ModelViewSimple(name: "Moon", bundle: realityKitContentBundle)
                            .frame(width: frameSize * 0.3, height: frameSize * 0.3)
                            .manipulable(using: manipulationState)
                    }

                }
                .debugBorder3D(showDebugLines ? .white : .clear)


                /// Demo 03: Customizing manipulable() using operations and onChanged event
                HStackLayout().depthAlignment(.center) {

                    VStack {
                        VectorDisplay(title: "Position", vector: onChangeVectorExample)
                    }
                    .padding()
                    .background(.black)
                    .cornerRadius(24)
                    .shadow(radius: 20)
                    .frame(width: 180, height: 120)

                    ModelViewSimple(name: "ToyRocket", bundle: realityKitContentBundle)
                        .frame(width: frameSize, height: frameSize)
                        .manipulable(operations: [.translate, .scale], onChanged: { event in
                            let translation = event.value?.transform?.translation ?? .zero
                            onChangeVectorExample = SIMD3<Float>(Float(translation.x), Float(translation.y), Float(translation.z))
                        })

                }
                .debugBorder3D(showDebugLines ? .white : .clear)

            }

        }
        // Controls to modify the example
        .ornament(attachmentAnchor: .scene(.trailing), contentAlignment: .leading, ornament: {
            VStack(alignment: .center, spacing: 8) {
                Button(action: {
                    withAnimation {
                        manipulationEnabled.toggle()
                    }
                }, label: {
                    Text("Enabled")
                })
                Button(action: {
                    showDebugLines.toggle()
                }, label: {
                    Text("Debug")
                })
            }
            .padding()
            .controlSize(.small)
            .glassBackgroundEffect()

        })
    }
}

fileprivate struct VectorDisplay: View {
    let title: String
    let vector: SIMD3<Float>

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.bold)
            VStack {
                ForEach(["X", "Y", "Z"], id: \.self) { axis in
                    Text("\(axis): \(String(format: "%8.3f", axis == "X" ? vector.x : axis == "Y" ? vector.y : vector.z))")
                        .frame(width: 120, alignment: .leading)
                }
            }
        }
    }
}

#Preview {
    Example105()
}

