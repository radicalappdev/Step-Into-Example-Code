//  Step Into Vision - Example Code
//
//  Title: Example130
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 11/27/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example130: View {
    @State var photoEntity = Entity()

    @State private var generationState: GenerationState = .empty
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
                    generationState: $generationState,
                    currentMode: $currentMode,
                    availableModes: $availableModes,
                    clearPhoto: { clearPhoto() },
                    loadPhotoPreGen: { Task { await loadPhotoPreGen(entity: photoEntity) } },
                    loadPhotoPostGen: { Task { await loadPhotoPostGen(entity: photoEntity) } }
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

    // Clear the current component
    func clearPhoto() {
        photoEntity.components.remove(ImagePresentationComponent.self)
        generationState = .empty
        currentMode = .mono
    }

    /// Load a regular (non-spatial) photo, then convert it to a Spatial Scene
    func loadPhotoPreGen(entity: Entity) async {
        guard let url = Bundle.main.url(forResource: "bell-01", withExtension: "jpeg") else { return }
        do {
            let converted = try await ImagePresentationComponent.Spatial3DImage(contentsOf: url)
            generationState = .loading
            try await converted.generate()
            generationState = .success

            var component = ImagePresentationComponent(spatial3DImage: converted)
            availableModes = component.availableViewingModes

            if availableModes.contains(.spatial3D) {
                component.desiredViewingMode = .spatial3D
                currentMode = .spatial3D
            }
            entity.components.set(component)
        } catch {
            print("Failed to load image: \(error)")
        }
    }

    /// Load a regular (non-spatial) photo, but do not generate it yet.
    func loadPhotoPostGen(entity: Entity) async {
        guard let url = Bundle.main.url(forResource: "bell-01", withExtension: "jpeg") else { return }
        do {
            let converted = try await ImagePresentationComponent.Spatial3DImage(contentsOf: url)
            let component = ImagePresentationComponent(spatial3DImage: converted)
            entity.components.set(component)

            generationState = .loading
            try await converted.generate()
            generationState = .success
            availableModes = component.availableViewingModes
            currentMode = .mono

        } catch {
            print("Failed to load image: \(error)")
        }
    }

}

fileprivate enum GenerationState {
    case empty
    case loading
    case success
    case failure
}

// Moving the control panel to a view
fileprivate struct ControlsPanel: View {
    @Binding var generationState: GenerationState
    @Binding var currentMode: ImagePresentationComponent.ViewingMode
    @Binding var availableModes: Set<ImagePresentationComponent.ViewingMode>

    let clearPhoto: () -> Void
    let loadPhotoPreGen: () -> Void
    let loadPhotoPostGen: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                switch generationState {
                case .empty:
                    Text("No photo loaded.")
                case .loading:
                    Text("Generating Spatial Scene...")
                case .success:
                    Text("Spatial Scene generated.")
                case .failure:
                    Text("Failed to generate Spatial Scene.")
                }
            }

            HStack(spacing: 12) {

                Button(action: {
                    clearPhoto()
                }, label: {
                    Text("Clear")
                })

                Button(action: {
                    loadPhotoPreGen()
                }, label: {
                    Text("Pre Gen")
                })

                Button(action: {
                    loadPhotoPostGen()
                }, label: {
                    Text("Post Gen")
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
    Example130()
}
