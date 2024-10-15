//
//  Helpers.swift
//  Step Into Example Code
//
//  Created by Joseph Simpson on 10/15/24.
//

import SwiftUI

extension Date {
    init(_ dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self = dateFormatter.date(from: dateString) ?? Date()
    }
}
