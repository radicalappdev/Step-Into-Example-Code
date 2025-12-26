//  Step Into Vision - Example Code
//
//  Title: Example139
//
//  Subtitle: RealityKit Basics: Using Convenience Entities
//
//  Description: When should we use Convenience Entities vs. components.
//
//  Type: Space
//
//  Featured: true
//
//  Created by Joseph Simpson on 12/26/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example139: View {
    var body: some View {
        RealityView { content in
            let redMat = SimpleMaterial(color: .stepRed, isMetallic: false)

            // Right hand: Build an entity and attach all components to it
            let rightHand = Entity()
            let model = ModelComponent(mesh: .generateSphere(radius: 0.01), materials: [redMat])
            let anchor = AnchoringComponent(.hand(.right, location: .indexFingerTip))
            let attachment = ViewAttachmentComponent(rootView: SimpleLabel(text: "Right"))
            rightHand.components.set([anchor, model, attachment])
            content.add(rightHand)

        

            // Right hand alternative: combine both options
//            let rightHand = Entity()
//            let model = ModelComponent(mesh: .generateSphere(radius: 0.01), materials: [redMat])
//            let anchor = AnchoringComponent(.hand(.right, location: .indexFingerTip))
//            rightHand.components.set([anchor, model])
//            let attachment = ViewAttachmentComponent(rootView: SimpleLabel(text: "Right"))
//            let rightAttachment = Entity()
//            rightAttachment.components.set([attachment])
//            rightAttachment.position.y = 0.05
//            rightHand.addChild(rightAttachment)
//            content.add(rightHand)


            // Left Hand: Use an Anchor Entity as the root, then attach children to it
            let leftHand = AnchorEntity(.hand(.left, location: .indexFingerTip))
            content.add(leftHand)

            // Add a sphere to track the anchor
            let leftSphere = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [redMat])
            leftHand.addChild(leftSphere)

            // Add an attachment just above the sphere
            let leftAttachment = ViewAttachmentEntity()
            leftAttachment.attachment = .init(rootView: SimpleLabel(text: "Left"))
            leftAttachment.position.y = 0.05
            leftHand.addChild(leftAttachment)


        }
    }
}

fileprivate struct SimpleLabel: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .padding()
            .background(.black)
            .cornerRadius(10)
    }
}

#Preview {
    Example139()
}
