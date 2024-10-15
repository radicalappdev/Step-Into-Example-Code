//
//  LabDetail.swift
//  Step Into Labs
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI

struct LabDetail: View {

    // Pass a lab as a parameter
    var lab: Lab

    // 2D Windows
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    // Immersive Spaces
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    // Local state
    @State private var showLabContent = false
    @State private var labIsOpen = false
    @State private var currentRoute: String?

    init(lab: Lab) {
        self.lab = lab
        _currentRoute = State(initialValue: lab.title)
    }

    var body: some View {
        List {
            Section() {
                VStack(alignment: .leading) {
                    Text("\(lab.title) - \(lab.subtitle)")
                        .font(.title)
                    Text("\(lab.date.formatted(date: .long, time: .omitted))")
                        .font(.subheadline)
                }
                Text(.init(lab.description))
                if(lab.success == false) {
                    HStack {
                        Text("This lab was marked as a failure")
                        Spacer()
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.red)
                            .padding(4)
                    }
                }
            }

            Section() {

                HStack(alignment: .center, content: {
                    Text(lab.type.rawValue)
                    Spacer()
                    Toggle(isOn: $showLabContent) {
                        Text(showLabContent ? "Close Lab" : "Open Lab")
                    }
                    .toggleStyle(.button)
                })
                .padding(.vertical, 6)
            }
        }
        .listStyle(.grouped)
        .onChange(of: showLabContent) { _, newValue in
            Task {
                if(lab.type == .WINDOW) {
                    handleWindow()
                } else if (lab.type == .WINDOW_ALT) {
                    handleWindowAlt()
                } else if (lab.type == .VOLUME) {
                    handleVolume()
                } else if (lab.type == .SPACE) {
                    await handleSpace(newValue: newValue)
                } else if (lab.type == .SPACE_FULL) {
                    await handleSpaceFull(newValue: newValue)
                }
            }
        }
        .navigationTitle("Step Into Labs")
    }

    func handleWindow() {
        if(labIsOpen) {
            dismissWindow(id: "RouterWindow")
            labIsOpen = false
            showLabContent = false
        } else {
            openWindow(id: "RouterWindow", value: lab.title)
            labIsOpen = true
        }
    }

    func handleWindowAlt() {
        if(labIsOpen) {
            dismissWindow(id: "RouterWindowAlt")
            labIsOpen = false
            showLabContent = false
        } else {
            openWindow(id: "RouterWindowAlt", value: lab.title)
            labIsOpen = true
        }
    }

    func handleVolume() {
        if(labIsOpen) {
            dismissWindow(id: "RouterVolume")
            labIsOpen = false
            showLabContent = false
        } else {
            openWindow(id: "RouterVolume", value: lab.title)
            labIsOpen = true
        }
    }

    func handleSpace(newValue: Bool) async {
        if newValue {
            switch await openImmersiveSpace(id: "RouterSpace", value: lab.title) {
            case .opened:
                labIsOpen = true
            case .error, .userCancelled:
                fallthrough
            @unknown default:
                labIsOpen = false
                showLabContent = false
            }
        } else if labIsOpen {
            await dismissImmersiveSpace()
            labIsOpen = false
        }
    }

    func handleSpaceFull(newValue: Bool) async {
        if newValue {
            switch await openImmersiveSpace(id: "RouterSpaceFull", value: lab.title) {
            case .opened:
                labIsOpen = true
            case .error, .userCancelled:
                fallthrough
            @unknown default:
                labIsOpen = false
                showLabContent = false
            }
        } else if labIsOpen {
            await dismissImmersiveSpace()
            labIsOpen = false
        }
    }

}

#Preview {
    let modelData = ModelData()
    let length = modelData.labData.count
    return LabDetail(lab: modelData.labData[length - 1])
}
