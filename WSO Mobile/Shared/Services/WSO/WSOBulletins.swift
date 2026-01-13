//
//  WSOBulletins.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-16.
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation

struct WSOBulletinResponse: Codable, Hashable {
    let status: Int
    let data: [WSOBulletinItem]
    var paginationTotal: Int
}

// the nice part is that there's almost no data missing. great!
struct WSOBulletinItem: Codable, Hashable, Identifiable {
    private let rawId: Int
    private let rawStartDate: String
    private let rawEndDate: String?
    private let rawTitle: String
    private let rawType: String
    private let rawBody: String
    private let rawUserID: Int

    // some nonsense to get around WSO's terrible date formatting
    var id: Int { rawId }
    var startDate: Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withTimeZone
        ]
        let date = isoFormatter.date(from: rawStartDate)
        return date
    }
    var endDate: Date? {
        guard let rawEndDate else { return nil }
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
            .withTimeZone
        ]
        let date = isoFormatter.date(from: rawEndDate)
        return date
    }
    var title: String { rawTitle }
    var type: String { rawType }
    var body: String { rawBody }
    var userID: Int { rawUserID }

    enum CodingKeys: String, CodingKey {
        case rawId = "id"
        case rawStartDate = "startDate"
        case rawEndDate = "endDate"
        case rawTitle = "title"
        case rawType = "type"
        case rawBody = "body"
        case rawUserID = "userID"
    }
}

// iOS is so beefy that we can easily just get huge list chunks, no problem,
// user will barely even see a performance hit. note that RAM use grows
// linearly with an increased limit!

func WSOListBulletin() async throws -> [WSOBulletinItem] {
    let parser = JSONISO8601Parser<WSOBulletinResponse>()
    let request = WebRequest<JSONISO8601Parser<WSOBulletinResponse>, NoParser>(
        // iPhone and backend performance so good that we should just get em all every time
        url: URL(string: "https://wso.williams.edu/api/v2/bulletin/bulletins?preload=users&all=true")!,
        requestType: .get,
        getParser: parser
    )
    return try await request.authGet().data
}

