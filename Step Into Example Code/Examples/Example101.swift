//  Step Into Vision - Example Code
//
//  Title: Example101
//
//  Subtitle: Spatial SwiftUI: Custom alignment with spatialOverlay
//
//  Description: We can use AlignmentID to customize the alignment of a view within a spatialOverlay.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 9/4/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example101: View {

    @State private var alignmentSign: Alignment3D = .init(horizontal: .center, vertical: .center, depth: .front)

    var body: some View {
        VStack {

            Spacer()

            // Use an Earth Model with a simple 2D view as an overlay
            ModelViewSimple(name: "Earth", bundle: realityKitContentBundle)
                .frame(width: 600, height: 600)
                .debugBorder3D(.white)
                .spatialOverlay(alignment: alignmentSign) {
                    VStack {
                        Text("Earth")
                            .font(.headline)
                        Text("The only planet known to serve ice cream")
                            .font(.caption)
                    }
                    .padding()
                    .background(.black)
                    .cornerRadius(24)
                    .breakthroughEffect(.prominent)
                }
        }
        .ornament(attachmentAnchor: .scene(.trailing), ornament: {
            VStack(alignment: .leading) {
                Button(action: {
                    withAnimation {
                        alignmentSign = .init(horizontal: .center, vertical: .center, depth: .front)
                    }
                }, label: {
                    Text("Center Front")
                })

                Button(action: {
                    withAnimation {
                        alignmentSign = .init(horizontal: .leading, vertical: .top, depth: .front)
                    }
                }, label: {
                    Text("Top Left Front")
                })

                Button(
                    action: {
                        withAnimation {
                            alignmentSign = .init(
                                horizontal: .init(ThirdHorizontalAlignment.self),
                                vertical: .init(ThirdVerticalAlignment.self),
                                depth: .front
                            )
                        }
                    },label: {
                        Text("Fractional Alignment")
                    })

                Button(
                    action: {
                        withAnimation {
                            alignmentSign = .init(horizontal: .explicit,
                                                  vertical: .explicit,
                                                  depth: .front)

                        }
                    },label: {
                        Text("Explicit Alignment")
                    })

            }
            .frame(width: 240)
            .padding()
            .glassBackgroundEffect()
        })

    }

}

// Custom Fractional Examples
fileprivate struct ThirdHorizontalAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context.width / 3
    }
}
fileprivate struct ThirdVerticalAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context.height / 3
    }
}

// Explicite Examples: 0.66 on X and 1.0 on Y
fileprivate struct ExplicitHorizontalAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context.width * 0.66
    }
}
fileprivate extension HorizontalAlignment {
    static let explicit = HorizontalAlignment(ExplicitHorizontalAlignment.self)
}

fileprivate struct ExplicitVerticalAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context.height * 1.0
    }
}
fileprivate extension VerticalAlignment {
    static let explicit = VerticalAlignment(ExplicitVerticalAlignment.self)
}

#Preview {
    Example101()
}

