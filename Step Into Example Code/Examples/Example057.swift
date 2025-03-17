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

    // Just a hack to access the scene from the toolbar buttons
    @State var sceneContent = Entity()

    var body: some View {
        RealityView { content in

            // Note: These USDZ files have the mesh in a child entity because 🤷🏻‍♂️
            guard let scene = try? await Entity(named: "CollisionLabsCustom", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.4
            self.sceneContent = scene


            if let pin = scene.findEntity(named: "pin") {
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

            if let sheet = scene.findEntity(named: "sheet")  {
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

            // Bowl with static concave collision
            if let bowl = scene.findEntity(named: "bowl") {
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

            // Bowl with convex collision
            if let bowl2 = scene.findEntity(named: "bowl_2") {
                if let modelComponent = bowl2.children.first?.components[ModelComponent.self] {
                    let mesh = modelComponent.mesh
                    Task {
                        do {
                            let collision = try await CollisionComponent(shapes: [.generateConvex(from: mesh)])
                            bowl2.components[CollisionComponent.self] = collision
                        } catch {
                            print("Error generating collision mesh: \(error)")
                        }
                    }
                }
            }


        }
        .modifier(DragGestureImproved())
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {
                    Button(action: {
                        if let ball1 = sceneContent.findEntity(named: "ExamplePhysics_1") {
                            ball1.position.y = 0.3
                        }
                    }, label: {
                        Text("Drop 1")
                    })
                    Button(action: {
                        if let ball2 = sceneContent.findEntity(named: "ExamplePhysics_2") {
                            ball2.position.y = 0.3
                        }
                    }, label: {
                        Text("Drop 2")
                    })
                    Button(action: {
                        if let ball3 = sceneContent.findEntity(named: "ExamplePhysics_3") {
                            ball3.position.y = 0.3
                        }
                    }, label: {
                        Text("Drop 3")
                    })
                }
            })
        }
    }
}

#Preview {
    Example057()
}
