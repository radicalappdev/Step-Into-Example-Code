//  Step Into Vision - Example Code
//
//  Title: Example129
//
//  Subtitle: Using Events with Image Presentation Component
//
//  Description: There are two events we can use to listen for changes to viewing mode, with some caveats.
//
//  Type: Space
//
//  Created by Joseph Simpson on 11/26/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example129: View {
    @State var photoEntity = Entity()

    @State private var currentMode = ImagePresentationComponent.ViewingMode.mono
    @State private var availableModes: Set<ImagePresentationComponent.ViewingMode> = []

    // Capture the events in state
    @State private var transitionStarted: EventSubscription?
    @State private var transitionCompleted: EventSubscription?

    @State private var applySurroundingEffect = false
    @State private var transitionCounter = 0

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
                    transitionCounter: $transitionCounter,
                    loadPhoto: { Task { await loadPhoto(entity: photoEntity) } },
                    loadSpatialPhoto: { Task { await loadSpatialPhoto(entity: photoEntity) } },
                    loadPhotoToConvert: { Task { await loadPhotoToConvert(entity: photoEntity) } }
                )
            )
            controlMenu.components.set(controlAttachment)
            controlMenu.setPosition([0, 1.2, -1.8], relativeTo: nil)
            content.add(controlMenu)


            // Only fires when an animated transition occurs (spatial3D to spatial3DImmersive)
            transitionStarted = content.subscribe(to: ImagePresentationEvents.TransitionStarted.self) { event in
                print("🟢 started with: \(event.currentViewingMode) target: \(event.targetViewingMode)")
                transitionCounter += 1
            }

            // Always fires after a viewing mode change
            transitionCompleted = content.subscribe(to: ImagePresentationEvents.TransitionCompleted.self) { event in
                print("🔴 completed with: \(event.currentViewingMode) previous: \(event.previousViewingMode)")

                // Apple the effect once we enter spatial3DImmersive or spatialStereoImmersive
                applySurroundingEffect = event.currentViewingMode == .spatial3DImmersive || event.currentViewingMode == .spatialStereoImmersive
            }
        }
        .preferredSurroundingsEffect(applySurroundingEffect ? .ultraDark : nil)
        // Listen for changes to mode and update the component
        .onChange(of: currentMode, { _, newValue in
            photoEntity.components[ImagePresentationComponent.self]?.desiredViewingMode = newValue
        })
        .onDisappear() {
            // cancel the subscriptions and remove the references
            transitionStarted?.cancel()
            transitionStarted = nil
            transitionCompleted?.cancel()
            transitionCompleted = nil
        }

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
    @Binding var transitionCounter: Int

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

            Text("Transitions: \(transitionCounter)")
                .contentTransition(.numericText(countsDown: false))

        }
        .padding()
        .background(.black)
        .clipShape(.capsule)
    }
}

#Preview {
    Example129()
}
