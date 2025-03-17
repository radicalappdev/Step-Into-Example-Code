//  Step Into Vision - Example Code
//
//  Title: Example057
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 3/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example057: View {
    var body: some View {
        RealityView { content, attachments in

            guard let scene = try? await Entity(named: "CollisionLabsCustom", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4

            if let pin = scene.findEntity(named: "pin") {

                // Get the mesh using ModelComponent
                // Note: These USDZ files have the mesh in a child entity because 🤷🏻‍♂️
                if let modelComponent = pin.children.first?.components[ModelComponent.self] {
                    let mesh = modelComponent.mesh
                    Task {
                        do {
                            let collision = try await CollisionComponent(shapes: [.generateConvex(from: mesh)])
                            pin.components[CollisionComponent.self] = collision
                        } catch {
                            print("Error generating collision mesh: \(error)")
                        }
                    }
                }
            }

            if let bowl = scene.findEntity(named: "bowl") {

                // Get the mesh using ModelComponent
                // Note: These USDZ files have the mesh in a child entity because 🤷🏻‍♂️
                if let modelComponent = bowl.children.first?.components[ModelComponent.self] {
                    let mesh = modelComponent.mesh
                    Task {
                        do {
                            let collision = try await CollisionComponent(shapes: [.generateStaticMesh(from: mesh)])
                            bowl.components[CollisionComponent.self] = collision
                        } catch {
                            print("Error generating collision mesh: \(error)")
                        }
                    }
                }
            }

            if let sheet = scene.findEntity(named: "sheet")  {

                // Get the mesh using ModelComponent
                // Note: These USDZ files have the mesh in a child entity because 🤷🏻‍♂️
                if let modelComponent = sheet.children.first?.components[ModelComponent.self] {
                    let mesh = modelComponent.mesh
                    Task {
                        do {
                            let collision = try await CollisionComponent(shapes: [.generateStaticMesh(from: mesh)])
                            sheet.components[CollisionComponent.self] = collision
                        } catch {
                            print("Error generating collision mesh: \(error)")
                        }
                    }
                }
            }

        } update: { content, attachments in

        } attachments: {
            Attachment(id: "AttachmentContent") {
                Text("")
            }
        }
    }
}

#Preview {
    Example057()
}
