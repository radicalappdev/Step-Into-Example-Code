//  Step Into Vision - Example Code
//
//  Title: Example099
//
//  Subtitle: Spatial SwiftUI: Presentation Breakthrough Effect
//
//  Description: We can use this new modifier to override the system default breakthrough effect for presentations.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 8/28/25.

import SwiftUI
import RealityKit
import RealityKitContent

fileprivate struct EarthCard: View {

    @Binding var effect: BreakthroughEffect

    var body : some View {
        VStack {
            Text("Earth")
                .font(.title)
            Text("The only known planet known to serve ice cream.")
                .font(.caption)
        }
        .padding()
        .presentationBreakthroughEffect(effect)
    }

}

struct Example099: View {

    @State private var effect: BreakthroughEffect = .none
    @State private var showingPopover: Bool = false

    var body: some View {
        VStack {
            Spacer()
            RealityView { content in

                guard let scene = try? await Entity(named: "PresentingEarth", in: realityKitContentBundle) else { return }
                content.add(scene)
                guard let subject = scene.findEntity(named: "Earth") else { return }
                guard let moon = scene.findEntity(named: "Moon") else { return }
                moon.components.set(ManipulationComponent())


                // A secondary entity that we can use as the transform point for the presented popover
                guard let presentationPoint = scene.findEntity(named: "PresentationPoint") else { return }

                // We'll use a TapGesture and the new GestureComponent to toggle the popover
                let tapGesture = TapGesture()
                    .onEnded({
                        Entity.animate(.bouncy, body: {
                            showingPopover.toggle()
                        })
                    })
                let gestureComponent = GestureComponent(tapGesture)
                subject.components.set(gestureComponent)

                // Create the presentation component using $showingPopover to toggle presentation
                let presentation = PresentationComponent(
                    isPresented: $showingPopover,
                    configuration: .popover(arrowEdge: .bottom),
                    content: EarthCard(effect: $effect)
                )
                presentationPoint.components.set(presentation)

            }
            .realityViewLayoutBehavior(.fixedSize)
        }
        // Controls to modify the example
        .ornament(attachmentAnchor: .scene(.bottomTrailing), contentAlignment: .bottomTrailing, ornament: {
            VStack(alignment: .center, spacing: 8) {
                Button(action: {
                    withAnimation {
                        effect = .none
                    }
                }, label: {
                    Text("None")
                })
                Button(action: {
                    withAnimation {
                        effect = .subtle
                    }
                }, label: {
                    Text("Subtle")
                })
                Button(action: {
                    withAnimation {
                        effect = .prominent
                    }
                }, label: {
                    Text("Prominent")
                })

            }
            .padding()
            .controlSize(.extraLarge)
            .glassBackgroundEffect()

        })
    }
}


#Preview {
    Example099()
}
