//  Step Into Vision - Example Code
//
//  Title: Example106
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 10/6/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Example106: View {
    var body: some View {
        RealityView { content in

            let subjectA = createStepDemoBox()
            content.add(subjectA)

            let subjectB = createStepDemoBox()
            content.add(subjectB)

            print(content.entities)

//            content.remove(subjectA)
//
//            print(content.entities)

        } update: { content in

        }
    }
}

#Preview {
    Example106()
}
