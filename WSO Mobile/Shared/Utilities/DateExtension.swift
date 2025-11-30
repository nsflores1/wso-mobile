//
//  DateExtension.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-29.
//

// this extension allows you to quickly shorten a date.
// so it becomes something like 12:08PM, Wed, 31 Oct which is what
// most people want to see anyways. year is oft too much.

import Foundation

extension Date {
    static let shortDisplayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a E, d MMM"
        return f
    }()

    var shortDisplay: String {
        Date.shortDisplayFormatter.string(from: self)
    }
}
