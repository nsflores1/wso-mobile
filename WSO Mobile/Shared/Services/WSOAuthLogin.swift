//
//  WSOAuthLogin.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-28.
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation

    // this section implements wsoGetWords(),
    // which gets three random words from production.
    // it is a good reference for implementing other HTTP request-based services.

struct WSOAuthLogin: Codable {
    var status: Int?
    var data: WSOAuthLoginData?
}

struct WSOAuthLoginData: Codable {
    var expire: Date?
    var token: String?
}

struct WSOAuthLoginForm: Codable {
    var localIP: Bool
    var password: String
    var unixID: String
    var useIP: Bool
}

@available(macOS 14.0, *)
func WSOAuthLogin(password: String, unixID: String) async throws -> WSOAuthLogin {
    let parser = JSONISO8601Parser<WSOAuthLogin>()
    let request = WebRequest<NoParser, JSONISO8601Parser<WSOAuthLogin>>(
        url: URL(string: "https://wso.williams.edu/api/v2/auth/login")!,
        requestType: .post,
        postParser: parser
    )
    // TODO: investigatory research reveals that our IP location DOES matter a lot.
    // check our IP and see if we're in Williamstown. but how???
    let formData: WSOAuthLoginForm = .init(localIP: false, password: password, unixID: unixID, useIP: true)
    let formDataJSON = try JSONEncoder().encode(formData)
    return try await request.post(sendData: formDataJSON)
}

// test debug login for CLI.
// DO NOT USE THIS IN PRODUCTION!
func doWSOAuthLogin(password: String, unixID: String) async throws {
    let result = try await WSOAuthLogin(password: password, unixID: unixID)
    print(result.data?.token ?? "No token")
}
