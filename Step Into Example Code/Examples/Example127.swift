//  Step Into Vision - Example Code
//
//  Title: Example127
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 11/24/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example127: View {
    @State var photoEntity = Entity()

    var body: some View {
        RealityView { content in
            content.add(photoEntity)
        }.toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    Button(action: {
                        Task {
                            await loadSpatialPhoto(entity: photoEntity)
                        }
                    }, label: {
                        Text("Spatial")

                    })
                }
            })
        }
    }
    func loadPhoto(entity: Entity) async {

    }
    func loadSpatialPhoto(entity: Entity) async {
        guard let url = Bundle.main.url(forResource: "bell-01-s", withExtension: "HEIC") else { return }

        do {
            // 1) Create the component from a file URL.
            var component = try await ImagePresentationComponent(contentsOf: url)
            if(component.availableViewingModes .contains(.spatialStereo)) {
                component.desiredViewingMode = .spatialStereo

            }
            entity.components.set(component)

        } catch {
            print("Failed to load image: \(error)")
        }

    }
    func loadPhotoToConvert(entity: Entity) async {

    }
}

//#Preview {
//    Example127()
//}
