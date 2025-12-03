//  Step Into Vision - Example Code
//
//  Title: Example128
//
//  Subtitle: Explore Viewing Modes with Image Presentation Component
//
//  Description: The available viewing modes depend on the type of image the component is presenting.
//
//  Type: Space
//
//  Featured: true
//
//  Created by Joseph Simpson on 11/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example128: View {
    @State var photoEntity = Entity()

    @State private var currentMode = ImagePresentationComponent.ViewingMode.mono
    @State private var availableModes: Set<ImagePresentationComponent.ViewingMode> = []

    var body: some View {
        RealityView { content in
            photoEntity.setPosition([0, 1.6, -2.0], relativeTo: nil)
            photoEntity.scale = .init(repeating: 0.6)
            content.add(photoEntity)

            // Attach SwiftUI controls into the scene
            let controlMenu = Entity()
            let controlAttachment = ViewAttachmentComponent(
                rootView: ControlsPanel(
                    currentMode: $currentMode,
                    availableModes: $availableModes,
                    loadPhoto: { Task { await loadPhoto(entity: photoEntity) } },
                    loadSpatialPhoto: { Task { await loadSpatialPhoto(entity: photoEntity) } },
                    loadPhotoToConvert: { Task { await loadPhotoToConvert(entity: photoEntity) } }
                )
            )
            controlMenu.components.set(controlAttachment)
            controlMenu.setPosition([0, 1.2, -1.8], relativeTo: nil)
            content.add(controlMenu)
        }
        // Listen for changes to mode and update the component
        .onChange(of: currentMode, { _, newValue in
            photoEntity.components[ImagePresentationComponent.self]?.desiredViewingMode = newValue
        })

    }

    /// Load a regular (non-spatial) photo
    func loadPhoto(entity: Entity) async {
        guard let url = Bundle.main.url(forResource: "bell-01", withExtension: "jpeg") else { return }
        do {
            let component = try await ImagePresentationComponent(contentsOf: url)
            availableModes = component.availableViewingModes
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
            availableModes = component.availableViewingModes
            if availableModes.contains(.spatialStereo) {
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
            let converted = try await ImagePresentationComponent.Spatial3DImage(contentsOf: url)
            try await converted.generate()

            var component = ImagePresentationComponent(spatial3DImage: converted)
            availableModes = component.availableViewingModes
            if availableModes.contains(.spatial3D) {
                component.desiredViewingMode = .spatial3D
            }
            entity.components.set(component)
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}

// Moving the control panel to a view
fileprivate struct ControlsPanel: View {
    @Binding var currentMode: ImagePresentationComponent.ViewingMode
    @Binding var availableModes: Set<ImagePresentationComponent.ViewingMode>

    let loadPhoto: () -> Void
    let loadSpatialPhoto: () -> Void
    let loadPhotoToConvert: () -> Void

    var body: some View {
        VStack(spacing: 12) {

            HStack(spacing: 12) {
                Button(action: {
                    loadPhoto()
                }, label: {
                    Text("Photo")
                })
                Button(action: {
                    loadSpatialPhoto()
                }, label: {
                    Text("Spatial Photo")
                })
                Button(action: {
                    loadPhotoToConvert()
                }, label: {
                    Text("Spatial Scene")
                })
            }
            .controlSize(.extraLarge)

            HStack {
                Button(action: {
                    currentMode = .mono
                }, label: {
                    Text("mono")
                })
                .disabled(!availableModes.contains(.mono))

                Button(action: {
                    currentMode = .spatialStereo
                }, label: {
                    Text("spatialStereo")
                })
                .disabled(!availableModes.contains(.spatialStereo))

                Button(action: {
                    currentMode = .spatialStereoImmersive
                }, label: {
                    Text("spatialStereoImmersive")
                })
                .disabled(!availableModes.contains(.spatialStereoImmersive))

                Button(action: {
                    currentMode = .spatial3D
                }, label: {
                    Text("spatial3D")
                })
                .disabled(!availableModes.contains(.spatial3D))

                Button(action: {
                    currentMode = .spatial3DImmersive
                }, label: {
                    Text("spatial3DImmersive")
                })
                .disabled(!availableModes.contains(.spatial3DImmersive))

            }
            .controlSize(.small)
            .padding()

        }
        .padding()
        .background(.black)
        .clipShape(.capsule)
    }
}

#Preview {
    Example128()
}
