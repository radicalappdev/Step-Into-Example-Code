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

    var body: some View {
        TabView {

            // MARK: - Vertical list
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 16) {
                    ForEach(0..<101, id: \.self) { number in
                        Text("\(number)")
                            .font(.extraLargeTitle2)
                            .padding()
                            .frame(width: 120, height: 80)
                            .background(Color(.stepGreen))
                            .cornerRadius(16)
                    }
                }
                .padding()
            }
            .scrollInputBehavior(.enabled, for: .look)
            .tabItem {
                Label("Vertical", systemImage: "chevron.up.chevron.down")
            }

            // MARK: - Horizontal row
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 16) {
                    ForEach(0..<101, id: \.self) { number in
                        Text("\(number)")
                            .font(.extraLargeTitle2)
                            .padding()
                            .frame(width: 120, height: 80)
                            .background(Color(.stepGreen))
                            .cornerRadius(16)
                    }
                }
                .padding()
            }
            .background(.thickMaterial)
            .frame(height: 200)
            .scrollInputBehavior(.enabled, for: .look)
            .tabItem {
                Label("Horizontal", systemImage: "chevron.left.chevron.right")
            }

            // MARK: - Scrollable grid (both axes)
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 12)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(0..<101, id: \.self) { number in
                        Text("\(number)")
                            .font(.extraLargeTitle2)
                            .padding()
                            .frame(width: 120, height: 80)
                            .background(Color(.stepGreen))
                            .cornerRadius(16)
                    }

                }
                .padding()
            }
            .background(.thickMaterial)
            .scrollInputBehavior(.enabled, for: .look)
            .tabItem {
                Label("Grid", systemImage: "square.grid.3x3")
            }
        }
    }
}

#Preview {
    Example100()
}

