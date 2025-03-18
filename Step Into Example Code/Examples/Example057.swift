//  Step Into Vision - Example Code
//
//  Title: Example057
//
//  Subtitle: Collisions & Physics: Generating Collision Meshes
//
//  Description: RealityKit provides a few methods to generate complex collision shapes, with one notable omission.
//
//  Type: Volume
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

            for (entityName, generateShape) in [
                // Example 1: bowling pin with convex collision shape
                ("pin", ShapeResource.generateConvex as (_) async throws -> _),

                // Example 2: sheet with concave static collision shape
                ("sheet", ShapeResource.generateStaticMesh),

                // Example 3: bowl with concave static collision shape
                ("bowl", ShapeResource.generateStaticMesh),

                // Example 4: bowl with convex static collision shape
                ("bowl_2", ShapeResource.generateConvex)
            ] {
                guard let components = scene.findEntity(named: entityName)?.children.first?.components,
                      let mesh = components[ModelComponent.self]?.mesh
                else { continue }

                Task {
                    do {
                        let collision = CollisionComponent(shapes: [try await generateShape(mesh)])
                        components.set(collision)
                    } catch {
                        print("Error generating collision mesh: \(error)")
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


