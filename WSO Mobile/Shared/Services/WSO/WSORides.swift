//
//  WSORides.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-15.
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation

struct WSORidesResponse: Codable, Hashable {
    let status: Int
    let data: [WSORidesItem]
    var paginationTotal: Int
}

    // the nice part is that there's almost no data missing. great!
struct WSORidesItem: Codable, Hashable, Identifiable {
    private let rawId: Int
    private let rawDate: String
    private let rawOffer: Bool
    private let rawSource: String
    private let rawDestination: String
    private let rawBody: String
    private let rawUserID: Int

        // some nonsense to get around WSO's terrible date formatting
    var id: Int { rawId }
    var date: Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withTimeZone
        ]
        let date = isoFormatter.date(from: rawDate)
        return date
    }
    var offer: Bool { rawOffer }
    var source: String { rawSource }
    var destination: String { rawDestination }
    var body: String { rawBody }
    var userID: Int { rawUserID }

    enum CodingKeys: String, CodingKey {
        case rawId = "id"
        case rawDate = "date"
        case rawOffer = "offer"
        case rawSource = "source"
        case rawDestination = "destination"
        case rawBody = "body"
        case rawUserID = "userID"
    }
}

// iOS is so beefy that we can easily just get huge list chunks, no problem,
// user will barely even see a performance hit. note that RAM use grows
// linearly with an increased limit!

// note that the backend filters rides for us, so its fine

func WSOListRides() async throws -> [WSORidesItem] {
    let parser = JSONISO8601Parser<WSORidesResponse>()
    let request = WebRequest<JSONISO8601Parser<WSORidesResponse>, NoParser>(
        // iPhone and backend performance so good that we should just get em all every time
        url: URL(string: "https://wso.williams.edu/api/v2/bulletin/rides?preload=users&all=true")!,
        requestType: .get,
        getParser: parser
    )
    return try await request.authGet().data
}
