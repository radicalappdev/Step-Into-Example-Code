//
//  LabList.swift
//  Step Into Labs
//
//  Created by Joseph Simpson on 10/3/24.
//

import SwiftUI

struct LabList: View {
    @Environment(ModelData.self) var modelData

    var featuredLabs: [Lab] {
        modelData.labData.filter { $0.isFeatured }
    }

    var body: some View {
        List {
            Section(header: Text("Featured Labs")) {
                ForEach(featuredLabs) { lab in
                    NavigationLink {
                        LabDetail(lab: lab)
                    } label: {
                        LabListRow(lab: lab)
                    }
                }
            }

            Section(header: Text("All Labs")) {
                ForEach(modelData.labData) { lab in
                    NavigationLink {
                        LabDetail(lab: lab)
                    } label: {
                        LabListRow(lab: lab)
                    }
                }
            }

        }

    }
}

#Preview {
    let modelData = ModelData()
    return LabList()
        .environment(modelData)
}
