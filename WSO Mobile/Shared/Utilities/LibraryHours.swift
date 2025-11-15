//
//  LibraryHours.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-14.
//

import SwiftSoup
import Foundation

struct LibraryHours: Codable, Hashable {
    let name: String
    let hours: String
}

func parseLibraryHours() async throws -> [LibraryHours] {
    let url = URL(string: "https://libcal.williams.edu/api_hours_today.php")!
    let (data, _) = try await URLSession.shared.data(from: url)

    let doc = try SwiftSoup.parse(data)
    let rows = try doc.select("tr.hours-today-row")

    return rows.compactMap { row in
        guard let name = try? row.select("th.hours-col-loc").text(),
              let time = try? row.select("td.hours-col-time span.s-lc-time").text()
            else { return nil }

        let trimmedTime = time.trimmingCharacters(in: .whitespacesAndNewlines)
        let hours = trimmedTime.isEmpty ? "(closed)" : trimmedTime

        return LibraryHours(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            hours: hours
        )
    }
}

func doLibraryHours() async {
    do {
        let data = try await parseLibraryHours()
        for item in data {
            print("name: \(item.name), hours: \(item.hours)")
        }
    }
    catch {
        print("no hours today")
    }
}
