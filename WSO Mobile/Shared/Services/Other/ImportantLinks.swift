//
//  ImportantLinks.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-18.
//

// set of helper functions for fetching importantlinks.

import Foundation
import HTTPTypes
import HTTPTypesFoundation

struct WSOImportantLinksStructure: Codable {
    let sections: [WSOImportantLinksSections]
}

struct WSOImportantLinksSections: Codable {
    let id: Int
    let header: WSOImportantLinksHeader
    let links: [WSOImportantLink]
}

struct WSOImportantLinksHeader: Codable {
    let title: String
    let shortTitle: String
    let sfSymbol: String?
    let description: String?
}

struct WSOImportantLink: Codable {
    let id: Int
    let title: String
    let url: String
    let sfSymbol: String?
    let description: String?
}

func getImportantLinks() async throws -> WSOImportantLinksStructure {
    let parser = JSONParser<WSOImportantLinksStructure>()
    let request = WebRequest<JSONParser<WSOImportantLinksStructure>, NoParser>(
        url: URL(string: "https://wso.williams.edu/mobile/links.json")!,
        requestType: .get,
        getParser: parser
    )
    return try await request.get()
}



