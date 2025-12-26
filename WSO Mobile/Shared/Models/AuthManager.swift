//
//  AuthManager.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-28.
//

// This is a weird meta-class that stores info not related to any particular
// ViewModel, but is too useful to end up duplicating across a bunch of files.

import Foundation
import JWTDecode

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case biometricsUnavailable
    case authenticationFailed
    case noToken
    case userFetchError
    case unhandledError(status: OSStatus)
}

@available(macOS 14.0, *)
@MainActor
@Observable
class AuthManager {
    static let shared = AuthManager()
    private var keychainKey = "com.wsomobile.authToken"

    var isAuthenticated = false
    // our tokens
    private var identityToken: String?
    private var authToken: String?

    // singleton nonsense
    private init() {}

    // note that this can throw, so handle that!
    // in which case the user must manually re-enter auth details
    // every single time from their password booklet.
    func getToken() throws -> String {
        if self.authToken != nil {
            return self.authToken!
        } else {
            throw KeychainError.noToken
        }
    }

    func deleteToken() {
        // we had better not keep using it, then
        // if you call this, don't be a moron and remember to get a fresh token
        self.authToken = nil
    }

    func login(username: String, password: String) async throws {
        // this should be used in the case we need to login,
        // but only fall back to this if getToken() throws.
        // initially, you should start by trying to getToken(),
        // and then switch back to a login screen.
        let identityToken = try await WSOIdentityLogin(
            password: password,
            unixID: username
        )
        if identityToken.data?.token != nil {
            let apiToken = try await WSOAPILogin(
                identityToken: identityToken.data!.token!
            )
            if apiToken.data?.token != nil {
                // now to decode our token
                let jwtToken = try decode(jwt: apiToken.data!.token!)
                //print(apiToken.data!.token!)
                //print(jwtToken.body)
                self.authToken = apiToken.data!.token!
                self.isAuthenticated = true
            }
        } else {
            throw KeychainError.noToken
        }
        // something has gone horribly wrong if we reach this point
        throw KeychainError.authenticationFailed
    }

    func logout() {
        self.authToken = nil
        self.isAuthenticated = false
    }
}
