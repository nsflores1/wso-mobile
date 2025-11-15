//
//  LibraryHours.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-14.
//

import SwiftSoup
import Foundation

struct LibraryHours: Codable {
    let name: String
    let hours: String
}

//func parseLibraryHours() async throws -> [LibraryHours] {
//    let url = URL(string: "https://libcal.williams.edu/api_hours_today.php")!
//    let (data, _) = try await URLSession.shared.data(from: url)

//    let doc = try SwiftSoup.parse(data)
//    let rows = try doc.select("tr.hours-today-row")

//}
