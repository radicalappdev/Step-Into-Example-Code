//  Step Into Vision - Example Code
//
//  Title: Example051
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 2/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example051: View {

    @State private var isActive = false

    var body: some View {
        VStack {
            Text("Model3D Examples")
                .font(.title)

            HStack(alignment: .center) {
                ModelView(name: "Earth")
                    .frame(width: 160, height: 160)
                    .rotation3DEffect(
                        Angle(degrees: isActive ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .hoverEffect()
                    .onTapGesture {
                        withAnimation {
                            isActive.toggle()
                        }

                    }
                ModelView(name: "Moon")
                    .frame(width: 40, height: 40)
                    .offset(x: 50, y: -50)
                    .offset(z: 100)
                    .hoverEffect()

            }
            .padding(24)

            Text("Earth and Moon from the Reality Composer Pro asset library.")
                .font(.caption)
        }
    }
}

fileprivate struct ModelView: View {

    @State var name: String = ""

    var body: some View {
        Model3D(named: name, bundle: realityKitContentBundle)
        { phase in
            if let model = phase.model {
                model
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if phase.error != nil {
                Text("Could not load model \(name).")
            } else {
                ProgressView()
            }
        }

    }
}

#Preview {
    Example051()
}
