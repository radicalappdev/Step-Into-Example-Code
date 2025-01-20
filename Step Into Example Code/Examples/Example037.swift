//  Step Into Vision - Example Code
//
//  Title: Example037
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 1/20/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example037: View {
    @State var ornamentVisibility: Visibility = .hidden
    @State var ornamentAnchor: UnitPoint = .top
    @State var ornamentAlignment: Alignment = .center

    // convenience functions so I don't have to repeat "withAnimation" in every button
    func setAnchor(_ newAnchor: UnitPoint) {
        withAnimation {
            ornamentAnchor = newAnchor
        }
    }

    func setAlignment(_ newAlignment: Alignment) {
        withAnimation {
            ornamentAlignment = newAlignment
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Button{
                    withAnimation {
                        ornamentVisibility = ornamentVisibility == .visible ? .hidden : .visible
                    }
                } label: {
                    Text("Toggle Ornament")
                }

                Spacer()

                HStack(spacing: 40) {

                    // Anchor buttons
                    VStack {
                        Text("Anchor")
                        HStack(alignment: .center) {
                            Button{
                                setAnchor(.topLeading)
                            } label: {
                                Image(systemName: "arrow.up.left")
                            }

                            Button{
                                setAnchor(.top)
                            } label: {
                                Image(systemName: "arrow.up")
                            }

                            Button{
                                setAnchor(.topTrailing)
                            } label: {
                                Image(systemName: "arrow.up.right")
                            }
                        }

                        HStack(alignment: .center) {
                            Button{
                                setAnchor(.leading)
                            } label: {
                                Image(systemName: "arrow.left")
                            }


                            Button{
                                setAnchor(.center)
                            } label: {
                                Image(systemName: "square")
                            }

                            Button{
                                setAnchor(.trailing)
                            } label: {
                                Image(systemName: "arrow.right")
                            }
                        }

                        HStack(alignment: .center) {
                            Button{
                                setAnchor(.bottomLeading)
                            } label: {
                                Image(systemName: "arrow.down.left")
                            }

                            Button{
                                setAnchor(.bottom)
                            } label: {
                                Image(systemName: "arrow.down")
                            }

                            Button{
                                setAnchor(.bottomTrailing)
                            } label: {
                                Image(systemName: "arrow.down.right")
                            }
                        }
                    }
                    // Alignment buttons
                    VStack {
                        Text("Alignment")
                        HStack(alignment: .center) {
                            Button{
                                setAlignment(.topLeading)
                            } label: {
                                Image(systemName: "arrow.up.left")
                            }

                            Button{
                                setAlignment(.top)
                            } label: {
                                Image(systemName: "arrow.up")
                            }

                            Button{
                                setAlignment(.topTrailing)
                            } label: {
                                Image(systemName: "arrow.up.right")
                            }
                        }

                        HStack(alignment: .center) {
                            Button{
                                setAlignment(.leading)
                            } label: {
                                Image(systemName: "arrow.left")
                            }


                            Button{
                                setAlignment(.center)
                            } label: {
                                Image(systemName: "square")
                            }


                            Button{
                                setAlignment(.trailing)
                            } label: {
                                Image(systemName: "arrow.right")
                            }
                        }

                        HStack(alignment: .center) {
                            Button{
                                setAlignment(.bottomLeading)
                            } label: {
                                Image(systemName: "arrow.down.left")
                            }

                            Button{
                                setAlignment(.bottom)
                            } label: {
                                Image(systemName: "arrow.down")
                            }

                            Button{
                                setAlignment(.bottomTrailing)
                            } label: {
                                Image(systemName: "arrow.down.right")
                            }
                        }
                    }
                }

            }
            .padding(100)
            .ornament(
                visibility: ornamentVisibility,
                attachmentAnchor: .scene(ornamentAnchor),
                contentAlignment: ornamentAlignment
            ) {
                Text("Ornament")
                    .padding(20)
                    .background(.stepBlue)
                    .cornerRadius(20)
            }


        }

    }}

#Preview {
    Example037()
}
