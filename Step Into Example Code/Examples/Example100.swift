//  Step Into Vision - Example Code
//
//  Title: Example100
//
//  Subtitle: Spatial SwiftUI: Using Look to Scroll
//
//  Description: We can let users look to scroll with the Scroll Input Behavior modifier.
//
//  Type: Window
//
//  Created by Joseph Simpson on 9/3/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example100: View {

    @State private var inputKind: ScrollInputKind = .look

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
            .scrollInputBehavior(.enabled, for: inputKind)
            .ornament(attachmentAnchor: .scene(.top), contentAlignment: .bottom, ornament: {
                let display = inputKind == .look ? "All" : inputKind == .look(axes: .horizontal) ? "Horizontal" : "Vertical"
                Text("\(display)")

                .padding()
                .glassBackgroundEffect()
            })
            .ornament(attachmentAnchor: .scene(.trailing), contentAlignment: .leading, ornament: {
                VStack {
                    Button(action: {
                        inputKind = .look
                    }, label: {
                        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                    })
                    Button(action: {
                        inputKind = .look(axes: .vertical)
                    }, label: {
                        Image(systemName: "chevron.up.chevron.down")
                    })
                    Button(action: {
                        inputKind = .look(axes: .horizontal)
                    }, label: {
                        Image(systemName: "chevron.left.chevron.right")
                    })
                }

                .padding()
                .glassBackgroundEffect()
            })
            .tabItem {
                Label("Grid", systemImage: "square.grid.3x3")
            }
        }
    }
}

#Preview {
    Example100()
}

