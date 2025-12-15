//
//  WSOAuthLogin.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-28.
//

import Foundation
import Combine
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

func newWSOAuthLogin(password: String, unixID: String) async throws -> WSOAuthLogin {
    let parser = JSONParser<WSOAuthLogin>()
    let request = WebRequest<NoParser, JSONParser<WSOAuthLogin>>(
        url: URL(string: "https://wso.williams.edu/api/v2/auth/login")!,
        requestType: .post,
        postParser: parser
    )
    let formData: WSOAuthLoginForm = .init(localIP: true, password: password, unixID: unixID, useIP: true)
    let formDataJSON = try JSONEncoder().encode(formData)
    return try await request.post(sendData: formDataJSON)
}

func WSOAuthLogin(password: String, unixID: String) async throws -> WSOAuthLogin {
    var request = HTTPRequest(method: .post, url: URL(string: "https://wso.williams.edu/api/v2/auth/login")!)
    request.headerFields[.userAgent] = "New WSO Mobile/0.1"

    let formData: WSOAuthLoginForm = .init(localIP: true, password: password, unixID: unixID, useIP: true)
    request.headerFields[.contentType] = "application/json"
    request.headerFields[.accept] = "application/json"
    let formDataJSON = try JSONEncoder().encode(formData)
    let str = (String(data: formDataJSON, encoding: .utf8) ?? "No data")
    print(str)

    let (data, _) = try await URLSession.shared.upload(for: request, from: formDataJSON)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    let decodedResponse = try decoder.decode(
        WSOAuthLogin.self,
        from: data
    )
    return decodedResponse
}

// test debug login for CLI.
// DO NOT USE THIS IN PRODUCTION!
func doWSOAuthLogin(password: String, unixID: String) async throws {
    let result = try await WSOAuthLogin(password: password, unixID: unixID)
    print(result.data?.token ?? "No token")
}

// stupid filler function for our buttons on the home screen
// until we add the actual auth system
func signIn() {
    print("clicked!")
}
