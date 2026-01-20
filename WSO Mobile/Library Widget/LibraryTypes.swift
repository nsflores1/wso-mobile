//
//  LibraryTypes.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-19.
//

// bundled dining data types, from LibraryHours.swift in the app.

struct LibraryViewData: Identifiable, Codable {
    let id: String
    let name: String
    let open: [String]
    let close: [String]
    // again, pointlessly copied, but cheaper than wrapper class
    let updateTime: String
}
