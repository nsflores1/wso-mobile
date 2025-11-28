//
//  WSOGetWords.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-20.
//

import Foundation
import Combine
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

func WSOGetWords() async throws -> String {
    var request = HTTPRequest(method: .get, url: URL(string: "https://wso.williams.edu/api/v2/words")!)
    request.headerFields[.userAgent] = "New WSO Mobile/0.1"

    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()

        let decodedResponse = try decoder.decode(WSOWords.self, from: data)
        // TODO: handle errors here better
        return decodedResponse.data
    } catch {
        throw WSOGetWordsParseError()
    }
}
