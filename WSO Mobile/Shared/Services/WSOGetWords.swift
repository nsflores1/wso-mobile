//
//  WSOGetWords.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-20.
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation

// this section implements wsoGetWords(),
// which gets three random words from production.
// it is a good reference for implementing other HTTP request-based services.

struct WSOWords: Codable {
    var status: Int
    var data: String
}

struct WSOGetWordsParseError: Error {}

// yay new reference function!
@available(macOS 14.0, *)
func WSOGetWords() async throws -> String {
    let parser = JSONParser<WSOWords>()
    let request = WebRequest<JSONParser<WSOWords>, NoParser>(
        url: URL(string: "https://wso.williams.edu/api/v2/words")!,
        requestType: .get,
        getParser: parser
    )
    return try await request.get().data
}
