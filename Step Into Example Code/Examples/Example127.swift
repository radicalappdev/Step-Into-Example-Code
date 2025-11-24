//  Step Into Vision - Example Code
//
//  Title: Example127
//
//  Subtitle: Loading Photos with Image Presentation Component
//
//  Description: This component allows us to display standard and Spatial photos. We can also generate Spatial Scenes from existing photos.
//
//  Type: Space
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

    /// Load a regular (non-spatial) photo
    func loadPhoto(entity: Entity) async {
        guard let url = Bundle.main.url(forResource: "bell-01", withExtension: "jpeg") else { return }
        do {
            let component = try await ImagePresentationComponent(contentsOf: url)
            entity.components.set(component)
        } catch {
            print("Failed to load image: \(error)")
        }
    }

    /// Load a spatial photo (captured on iPhone 17 Pro)
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

    /// Load a regular (non-spatial) photo, then convert it to a Spatial Scene
    func loadPhotoToConvert(entity: Entity) async {
        guard let url = Bundle.main.url(forResource: "bell-01", withExtension: "jpeg") else { return }
        do {
            // Load the image as a Spatial3DImage
            let converted = try await ImagePresentationComponent.Spatial3DImage(contentsOf: url)
            // The call generate. Note that this always fails in the Simulator as of November 2025. Make sure you test this on a device.
            try await converted.generate()

            // Create the component
            var component = ImagePresentationComponent(spatial3DImage: converted)

            if(component.availableViewingModes .contains(.spatial3D)) {
                component.desiredViewingMode = .spatial3D
            }
            entity.components.set(component)

        } catch {
            print("Failed to load image: \(error)")
        }
    }
}

#Preview {
    Example127()
}

