//  Step Into Vision - Example Code
//
//  Title: Example105
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 9/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example105: View {

    @State private var manipulationState = Manipulable.GestureState()
    @State private var onChangeVectorExample: SIMD3<Float> = .zero

    let frameSize: CGFloat = 100

    var body: some View {
        VStackLayout().depthAlignment(.center) {
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

                ModelViewSimple(name: "ToyCar", bundle: realityKitContentBundle)
                    .frame(width: frameSize, height: frameSize)
                    .manipulable()
                    .hoverEffect()

                ModelViewSimple(name: "ToyRocket", bundle: realityKitContentBundle)
                    .frame(width: frameSize, height: frameSize)
                    .manipulable()
                    .hoverEffect()

                ModelViewSimple(name: "ToyBiplane", bundle: realityKitContentBundle)
                    .frame(width: frameSize, height: frameSize)
                    .manipulable()
                    .hoverEffect()

            }

            HStackLayout().depthAlignment(.center) {

                VStack {
                    Text("Redirected")
                        .font(.headline)
                    Text("Using manipulationGesture and manipulable(using:)")
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
//                .frame(width: frameSize * 2, height: frameSize * 2)

//                .spatialOverlay(alignment: .bottomFront ,content: {
//                    VStack {
//                        Text("Redirected")
//                            .font(.headline)
//                        Text("Using manipulationGesture and manipulable(using:)")
//                            .font(.caption)
//                    }
//                    .padding()
//                    .background(.black)
//                    .cornerRadius(24)
//                    .shadow(radius: 20)
//                    .frame(width: 180, height: 120)
//                })

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
            
        }
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
