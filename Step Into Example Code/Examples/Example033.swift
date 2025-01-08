//  Step Into Vision - Example Code
//
//  Title: Example033
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/8/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example033: View {



    @State fileprivate var transformMode: TransformType = .translate

    var body: some View {
        VStack(spacing: 24) {


            HStack(spacing: 24) {
                List {

                }

                RoundedRectangle(cornerRadius: 12.0)
                    .foregroundStyle(.stepRed)
                    .modifier(ExploringTransform3DEffect(mode: $transformMode))



            }
            .padding(12)
        }
        .padding(12)

    }

}

fileprivate enum TransformType {
    case none
    case translate
    case rotate
    case scale
}

fileprivate struct ExploringTransform3DEffect: ViewModifier {
    @Binding var mode: TransformType

    func body(content: Content) -> some View {
        switch mode {
        case .none:
            content
        case .translate:
            content
                .transform3DEffect(AffineTransform3D(translation: Vector3D(x: 25, y: 25, z: 50)))
        case .rotate:
            content
                .transform3DEffect(AffineTransform3D(rotation: Rotation3D(angle: Angle2D(degrees: 20), axis: .x)))
        case .scale:
            content
                .transform3DEffect(AffineTransform3D(scale: Size3D(vector: [0.5, 0.5, 0.5])))
        }
    }
}

#Preview {
    Example033()
}
