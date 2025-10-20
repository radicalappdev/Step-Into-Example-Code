//  Step Into Vision - Example Code
//
//  Title: Example112
//
//  Subtitle: RealityKit Basics: Perform Entity Actions
//
//  Description: RealityKit simplifies many common actions like spin, orbit, playing audio, etc.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 10/20/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example112: View {
    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "EntityActionLab", in: realityKitContentBundle) else { return }
            content.add(scene)

            guard let earth = scene.findEntity(named: "Earth") else { return }
            let earthTap = TapGesture().onEnded({ [weak earth] _ in
                if let earth = earth {
                    exampleAction1(entity: earth)
                }
            })
            let earthGesture = GestureComponent(earthTap)
            earth.components.set(earthGesture)

            guard let rocket = scene.findEntity(named: "ToyRocket") else { return }
            let rocketTap = TapGesture().onEnded({ [weak rocket] _ in
                if let rocket = rocket {
                    exampleAction2(entity: rocket)
                }
            })
            let rocketGesture = GestureComponent(rocketTap)
            rocket.components.set(rocketGesture)

            guard let moon = scene.findEntity(named: "Moon") else { return }
            let moonTap = TapGesture().onEnded({ [weak moon] _ in
                if let moon = moon {
                    exampleAction3(entity: moon)
                }
            })
            let moonGesture = GestureComponent(moonTap)
            moon.components.set(moonGesture)


        }
    }

    func exampleAction1(entity: Entity) {
        Task {
            // Create the action
            let action = SpinAction(revolutions: 1,
                                    localAxis: [0, 1, 0],
                                    timingFunction: .easeInOut,
                                    isAdditive: false)

            // Use the action in an animation
            let animation = try AnimationResource.makeActionAnimation(for: action,
                                                                      duration: 2,
                                                                      bindTarget: .transform)

            // Play the animation
            entity.playAnimation(animation)
        }
    }
    func exampleAction2(entity: Entity) {
        Task {

            // Create an orbit action that will move this entity around the Earth
            let action = OrbitEntityAction(pivotEntity: .entityNamed("Earth"),
                                           revolutions: 2,
                                           orbitalAxis: [0, 0, 1],
                                           isOrientedToPath: true,
                                           isAdditive: false)

            // Use the action in an animation
            let animation = try AnimationResource.makeActionAnimation(for: action,
                                                                      duration: 4,
                                                                      bindTarget: .transform)

            // Play the animation
            entity.playAnimation(animation)
        }
    }

    func exampleAction3(entity: Entity) {
        Task {
            let spinAction = SpinAction(revolutions: 1,
                                    localAxis: [0, 1, 0],
                                    timingFunction: .easeInOut,
                                    isAdditive: false)

            let spinAnimation = try AnimationResource.makeActionAnimation(for: spinAction,
                                                                      duration: 6,
                                                                      bindTarget: .transform)


            let orbitAction = OrbitEntityAction(pivotEntity: .entityNamed("Earth"),
                                           revolutions: 2,
                                           orbitalAxis: [0, 1, 0],
                                           isOrientedToPath: false,
                                           isAdditive: false)


            let orbitAnimation = try AnimationResource.makeActionAnimation(for: orbitAction,
                                                                      duration: 2,
                                                                      bindTarget: .transform)

            // Play the animations at the same time
            entity.playAnimation(spinAnimation)
            entity.playAnimation(orbitAnimation)
        }
    }
}

#Preview {
    Example112()
}


