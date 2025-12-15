//  Step Into Vision - Example Code
//
//  Title: Example131
//
//  Subtitle: Read meta data from Image Presentation Component
//
//  Description: This component provides access to aspect ratio, image size, and the size of the presentation in our scene.
//
//  Type: Space
//
//  Featured: false
//
//  Created by Joseph Simpson on 11/28/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example131: View {

    @State var photoEntity = Entity()

    @State private var currentMode = ImagePresentationComponent.ViewingMode.mono
    @State private var availableModes: Set<ImagePresentationComponent.ViewingMode> = []

    @State private var aspectRatio: Float?

    @State private var presentationScreenSize: SIMD2<Float> = .zero
    @State private var worldScreenSize: SIMD2<Float> = .zero
    @State private var screenImageDimension: SIMD2<Float> = .zero

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
                    aspectRatio: $aspectRatio,
                    presentationScreenSize: $presentationScreenSize,
                    screenImageDimension: $screenImageDimension,
                    worldScreenSize: $worldScreenSize,
                    loadPhoto: { Task { await loadPhoto(entity: photoEntity) } },
                    loadSpatialPhoto: { Task { await loadSpatialPhoto(entity: photoEntity) } },
                    loadPhotoToConvert: { Task { await loadPhotoToConvert(entity: photoEntity) } }
                )
            )
            controlMenu.components.set(controlAttachment)
            controlMenu.setPosition([0, 1.2, -1.8], relativeTo: nil)
            content.add(controlMenu)
        }
        // Listen for changes to mode and update the component.
        .onChange(of: currentMode, { _, newValue in
            if var component = photoEntity.components[ImagePresentationComponent.self] {
                component.desiredViewingMode = newValue

                // Capture the metadata
                aspectRatio = component.aspectRatio(for: newValue)
                presentationScreenSize = component.presentationScreenSize
                screenImageDimension = component.screenImageDimension

                // Just a quick hack to calculate world scale. This assumes uniform scale.
                let worldScale = photoEntity.scale(relativeTo: nil).x
                worldScreenSize = presentationScreenSize * worldScale

                photoEntity.components.set(component)
            }
        })

    }

    /// Load a regular (non-spatial) photo
    func loadPhoto(entity: Entity) async {
        guard let url = Bundle.main.url(forResource: "bell-01", withExtension: "jpeg") else { return }
        do {
            let component = try await ImagePresentationComponent(contentsOf: url)
            availableModes = component.availableViewingModes
            currentMode = .mono
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
                currentMode = .spatialStereo
            } else {
                currentMode = .mono
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
                currentMode = .spatial3D
            } else {
                currentMode = .mono
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
    @Binding var aspectRatio: Float?
    @Binding var presentationScreenSize: SIMD2<Float>
    @Binding var screenImageDimension: SIMD2<Float>
    @Binding var worldScreenSize: SIMD2<Float>

    let loadPhoto: () -> Void
    let loadSpatialPhoto: () -> Void
    let loadPhotoToConvert: () -> Void

    var body: some View {
        HStack {


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

            // Display the metadata
            VStack {
                Vector2Display(title: "Aspect Ratio", vector: aspectVectorNormalized(aspectRatio ?? 0))
                Vector2Display(title: "Presentation size (local)", vector: presentationScreenSize)
                Vector2Display(title: "Presentation size (world)", vector: worldScreenSize)
                Vector2Display(title: "Image Dimension", vector: screenImageDimension)
            }
        }
        .padding()
        .background(.black)
        .clipShape(.rect(cornerRadius: 24))
    }
}

#Preview {
    Example131()
}
