//  Step Into Vision - Example Code
//
//  Title: Example001
//
//  Subtitle: Example of a 2D Window
//
//  Description: Testing out the window
//
//  Type: Window
//
//  Created by Joseph Simpson on 10/3/24.

import SwiftUI

struct Example001: View {
    var body: some View {
        VStack {
            Text("A Regular Window")
                .font(.title)
            Text("2D content made with SwiftUI")
        }
    }
}

#Preview {
    Example001()
}
