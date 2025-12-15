//
//  LibraryHours.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-14.
//

import SwiftSoup
import Foundation
import HTTPTypes
import HTTPTypesFoundation

// codable data
struct LibraryServices: Codable {
    let libraryServices: [String: LibraryHours]
    let updateTime: String // TODO: parse as date somehow

    enum CodingKeys: String, CodingKey {
        case libraryServices = "libraryservices"
        case updateTime
    }
}

struct LibraryHours: Codable {
    let name: String
    let hours: HoursList

    struct HoursList: Codable {
        let open: [String]?
        let close: [String]?
    }
}

// clean data storage
struct SaneLibraryHours: Codable {
    let name: String
    let openHours: [String]
    let closeHours: [String]
}

func parseLibraryHours() async throws -> [SaneLibraryHours] {
    let parser = JSONParser<LibraryServices>()
    let request = WebRequest<JSONParser<LibraryServices>, NoParser>(
        url: URL(string: "https://wso.williams.edu/library.json")!,
        requestType: .get,
        getParser: parser
    )
    let data = try await request.get()
    return data.libraryServices.map { library in
        SaneLibraryHours(
            name: library.key,
            openHours: library.value.hours.open ?? [],
            closeHours: library.value.hours.close ?? []
        )
    }

}

func doLibraryHours() async throws {
    let data = try await parseLibraryHours()
    for item in data {
        print(
            "name: \(item.name), hours: \(item.openHours.joined(separator: "-")) - \(item.closeHours.joined(separator: "-"))"
        )
    }
}
