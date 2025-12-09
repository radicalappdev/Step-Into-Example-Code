//  Step Into Vision - Example Code
//
//  Title: Example132
//
//  Subtitle: Spatial SwiftUI: Preferred Surroundings Effect
//
//  Description: We can use this SwiftUI modifier to adjust the lighting and tint color for the passthrough feed.
//
//  Type: Window
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/8/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example132: View {

    @State private var effect: SurroundingsEffect? = nil

    var body: some View {
        VStack {
            Text("Spatial SwiftUI: SurroundingsEffect")
                .font(.largeTitle)

            HStack(spacing: 12) {

                Button(action: {
                    effect = nil
                }, label: {
                    Text("Unset")
                })

                Button(action: {
                    effect = .semiDark
                }, label: {
                    Text("Semi Dark")
                })

                Button(action: {
                    effect = .dark
                }, label: {
                    Text("Dark")
                })

                Button(action: {
                    effect = .ultraDark
                }, label: {
                    Text("Ultra Dark")
                })

            }

        }
        .preferredSurroundingsEffect(effect)
    }
}

#Preview {
    Example132()
}
