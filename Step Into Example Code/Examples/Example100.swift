//  Step Into Vision - Example Code
//
//  Title: Example100
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 9/3/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example100: View {
    var emoji: [String] = ["🌸", "🐸", "❤️", "🔥", "💻", "🐶", "🥸", "📱", "🎉", "🚀", "🤔", "🤓", "🧲", "💰", "🤩", "🍪", "🦉", "💡", "😎"]
    var body: some View {

        HStack {

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 0) {

                    ForEach(emoji, id: \.self) { emoji in

                        Text(emoji)
                            .font(.extraLargeTitle2)
                            .bold()
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                            .padding()

                    }


                }
            }
            .background(.thickMaterial)
            .scrollInputBehavior(.enabled, for: .look)
            .frame(width: 200)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {

                    ForEach(emoji, id: \.self) { emoji in

                        Text(emoji)
                            .font(.extraLargeTitle2)
                            .bold()
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                            .padding()

                    }


                }
            }
            .background(.thickMaterial)
            .frame(height: 200)
            .scrollInputBehavior(.enabled, for: .look)

        }
    }
}

#Preview {
    Example100()
}
