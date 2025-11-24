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
            photoEntity.setPosition([0, 1.6, -2.0], relativeTo: nil)
            photoEntity.scale = .init(repeating: 0.6)
            content.add(photoEntity)

            // Add some buttons to switch photos
            let controlMenu = Entity()
            let controlAttachment = ViewAttachmentComponent(rootView: controls)
            controlMenu.components.set(controlAttachment)
            controlMenu.setPosition([0, 1.2, -1.8], relativeTo: nil)
            content.add(controlMenu)
        }
    }
    var controls: some View {
        HStack(spacing: 12) {
            Button(action: {
                Task {
                    await loadPhoto(entity: photoEntity)
                }
            }, label: {
                Text("Photo")

            })

            Button(action: {
                Task {
                    await loadSpatialPhoto(entity: photoEntity)
                }
            }, label: {
                Text("Spatial Photo")

            })

            Button(action: {
                Task {
                    await loadPhotoToConvert(entity: photoEntity)
                }
            }, label: {
                Text("Spatial Scene")

            })

        }
        .padding()
        .background(.black)
        .clipShape(.capsule)
        .controlSize(.extraLarge)

    }
    func loadPhoto(entity: Entity) async {

        guard let url = Bundle.main.url(forResource: "bell-01", withExtension: "jpeg") else { return }
        do {
            let component = try await ImagePresentationComponent(contentsOf: url)
            entity.components.set(component)
        } catch {
            print("Failed to load image: \(error)")
        }


    }
    func loadSpatialPhoto(entity: Entity) async {
        guard let url = Bundle.main.url(forResource: "bell-01-s", withExtension: "HEIC") else { return }
        do {
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
