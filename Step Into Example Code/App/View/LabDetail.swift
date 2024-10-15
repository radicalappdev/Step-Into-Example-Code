//
//  ExampleDetail.swift
//  Step Into Examples
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI

struct ExampleDetail: View {

    // Pass a example as a parameter
    var example: Example

    // 2D Windows
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    // Immersive Spaces
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    // Local state
    @State private var showExampleContent = false
    @State private var exampleIsOpen = false
    @State private var currentRoute: String?

    init(example: Example) {
        self.example = example
        _currentRoute = State(initialValue: example.title)
    }

    var body: some View {
        List {
            Section() {
                VStack(alignment: .leading) {
                    Text("\(example.title) - \(example.subtitle)")
                        .font(.title)
                    Text("\(example.date.formatted(date: .long, time: .omitted))")
                        .font(.subheadline)
                }
                Text(.init(example.description))
                if(example.success == false) {
                    HStack {
                        Text("This example was marked as a failure")
                        Spacer()
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.red)
                            .padding(4)
                    }
                }
            }

            Section() {

                HStack(alignment: .center, content: {
                    Text(example.type.rawValue)
                    Spacer()
                    Toggle(isOn: $showExampleContent) {
                        Text(showExampleContent ? "Close Example" : "Open Example")
                    }
                    .toggleStyle(.button)
                })
                .padding(.vertical, 6)
            }
        }
        .listStyle(.grouped)
        .onChange(of: showExampleContent) { _, newValue in
            Task {
                if(example.type == .WINDOW) {
                    handleWindow()
                } else if (example.type == .WINDOW_ALT) {
                    handleWindowAlt()
                } else if (example.type == .VOLUME) {
                    handleVolume()
                } else if (example.type == .SPACE) {
                    await handleSpace(newValue: newValue)
                } else if (example.type == .SPACE_FULL) {
                    await handleSpaceFull(newValue: newValue)
                }
            }
        }
        .navigationTitle("Step Into Examples")
    }

    func handleWindow() {
        if(exampleIsOpen) {
            dismissWindow(id: "RouterWindow")
            exampleIsOpen = false
            showExampleContent = false
        } else {
            openWindow(id: "RouterWindow", value: example.title)
            exampleIsOpen = true
        }
    }

    func handleWindowAlt() {
        if(exampleIsOpen) {
            dismissWindow(id: "RouterWindowAlt")
            exampleIsOpen = false
            showExampleContent = false
        } else {
            openWindow(id: "RouterWindowAlt", value: example.title)
            exampleIsOpen = true
        }
    }

    func handleVolume() {
        if(exampleIsOpen) {
            dismissWindow(id: "RouterVolume")
            exampleIsOpen = false
            showExampleContent = false
        } else {
            openWindow(id: "RouterVolume", value: example.title)
            exampleIsOpen = true
        }
    }

    func handleSpace(newValue: Bool) async {
        if newValue {
            switch await openImmersiveSpace(id: "RouterSpace", value: example.title) {
            case .opened:
                exampleIsOpen = true
            case .error, .userCancelled:
                fallthrough
            @unknown default:
                exampleIsOpen = false
                showExampleContent = false
            }
        } else if exampleIsOpen {
            await dismissImmersiveSpace()
            exampleIsOpen = false
        }
    }

    func handleSpaceFull(newValue: Bool) async {
        if newValue {
            switch await openImmersiveSpace(id: "RouterSpaceFull", value: example.title) {
            case .opened:
                exampleIsOpen = true
            case .error, .userCancelled:
                fallthrough
            @unknown default:
                exampleIsOpen = false
                showExampleContent = false
            }
        } else if exampleIsOpen {
            await dismissImmersiveSpace()
            exampleIsOpen = false
        }
    }

}

#Preview {
    let modelData = ModelData()
    let length = modelData.exampleData.count
    return ExampleDetail(example: modelData.exampleData[length - 1])
}
