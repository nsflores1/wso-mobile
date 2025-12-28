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

struct LibraryResponse: Codable {
    let libraryServices: [String: LibraryService]
    let updateTime: String

    enum CodingKeys: String, CodingKey {
        case libraryServices = "libraryservices"
        case updateTime
    }
}

struct LibraryService: Codable {
    let name: String
    let hours: LibraryHours
}

struct LibraryHours: Codable {
    let open: [String]?
    let close: [String]?
}

// for the View
struct LibraryViewData: Identifiable, Codable {
    let id: String           // stable key from the api
    let name: String
    let open: [String]
    let close: [String]
}

func parseLibraryHours() async throws -> [LibraryViewData] {
    let parser = JSONParser<LibraryResponse>()
    let request = WebRequest<JSONParser<LibraryResponse>, NoParser>(
        url: URL(string: "https://wso.williams.edu/library.json")!,
        requestType: .get,
        getParser: parser
    )
    let data = try await request.get()
    return data.libraryServices.sorted(by: { $0.key < $1.key }).map { key, value in
        return LibraryViewData(
            id: key,
            name: value.name.cleanWhitespace(),
            open: value.hours.open ?? [],
            close: value.hours.close ?? []
        )
    }
}
