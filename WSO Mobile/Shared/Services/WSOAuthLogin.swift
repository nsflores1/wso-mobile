//
//  WSOAuthLogin.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-28.
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation
import Logging

struct WSOAuthLogin: Codable {
    var status: Int?
    var data: WSOAuthLoginData?
}

struct WSOAuthLoginData: Codable {
    var expire: Date?
    var token: String?
}

// this is undocumented, but by leaving out localIP and useIP,
// you can get a level 3 token off or on campus. this is probably a bug
struct WSOAuthLoginForm: Codable {
    var password: String
    var unixID: String
}

// takes a user password, returns an identitytoken
// this should work both on and off campus
@available(macOS 14.0, *)
func WSOIdentityLogin(password: String, unixID: String) async throws -> WSOAuthLogin {
    let parser = JSONISO8601Parser<WSOAuthLogin>()
    let request = WebRequest<NoParser, JSONISO8601Parser<WSOAuthLogin>>(
        url: URL(string: "https://wso.williams.edu/api/v2/auth/login")!,
        requestType: .post,
        postParser: parser
    )
    let formData: WSOAuthLoginForm = .init(password: password, unixID: unixID)
    let formDataJSON = try JSONEncoder().encode(formData)
    return try await request.post(sendData: formDataJSON)
}

// takes an identitytoken, return an apitoken
func WSOAPILogin(identityToken: String) async throws -> WSOAuthLogin {
    let logger = Logger(label: "com.wso.WebRequest") // technically not but whatever, this is a web request
    var request = HTTPRequest(method: .post, url: URL(string: "https://wso.williams.edu/api/v2/auth/api/token")!)
    request.headerFields[.userAgent] = "New WSO Mobile/1.2.0"
    request.headerFields[.authorization] = "Bearer \(identityToken)"

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let http = response as HTTPResponse?,
          (200..<300).contains(http.status.code) else {
        logger.error("POST (auth) request to https://wso.williams.edu/api/v2/auth/api/token failed due to invalid HTTP response: \(response.status)")
        throw WebRequestError.invalidResponse
    }
    logger.debug("POST (auth) success: the request HTTP status was \(response.status)")
    logger.debug("POST (auth) data: \(String(decoding: data, as: UTF8.self))")
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    do {
        let decodedResponse = try decoder.decode(WSOAuthLogin.self, from: data)
        logger.trace("POST (auth) request to completed")
        return decodedResponse
    } catch let decoding as DecodingError {
        logger.error("POST (auth) failure: decoding API Token failed with \(decoding.localizedDescription)")
        throw WebRequestError.parseError(decoding)
    }
}
