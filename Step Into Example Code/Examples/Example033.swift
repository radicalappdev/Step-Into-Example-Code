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

    @State fileprivate var transformMode: TransformType = .none

    var body: some View {
        HStack(spacing: 12) {
                List {
                    Section(header: Text("Transform Mode"), content: {

                        ForEach(TransformType.allCases, id: \.self) { transformType in
                            Button(transformType.rawValue) {
                                self.transformMode = transformType
                            }
                        }
                    })
                }

                .frame(width: 300)

                ZStack {
                    RoundedRectangle(cornerRadius: 12.0)
                        .foregroundStyle(.thickMaterial)
                        .frame(width: 200, height: 200)

                    RoundedRectangle(cornerRadius: 12.0)
                        .foregroundStyle(.stepRed)
                        .frame(width: 200, height: 200)
                        .modifier(ExploringTransform3DEffect(mode: $transformMode))

                }

            }
            .padding(EdgeInsets(top: 24, leading: 12, bottom: 12, trailing: 12))

    }

}

fileprivate enum TransformType: String, CaseIterable {
    case none = "None"
    case translate = "Translate"
    case rotate = "Rotate"
    case scale = "Scale"
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
