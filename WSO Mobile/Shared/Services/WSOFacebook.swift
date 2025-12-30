//
//  WSOFacebook.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-16.
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation

struct WSOFacebookData: Codable {
    var status: Int
    var data: [User]
}

// gets a list of users with a given query string
func WSOFacebookSearch(query: String) async throws -> [User] {
    let parser = JSONISO8601Parser<WSOFacebookData>()
    let request = WebRequest<JSONISO8601Parser<WSOFacebookData>, NoParser>(
        url: URL(string: "https://wso.williams.edu/api/v2/users?preload=tags&q=\(query)")!,
        requestType: .get,
        getParser: parser
    )
    return try await request.authGet().data
}
