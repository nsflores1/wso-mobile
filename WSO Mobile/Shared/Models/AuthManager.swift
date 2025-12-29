//
//  AuthManager.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-28.
//

// This is a weird meta-class that stores info not related to any particular
// ViewModel, but is too useful to end up duplicating across a bunch of files.

import Foundation
import LocalAuthentication
import Security
import JWTDecode
import Logging

enum KeychainError: Error {
    case noToken
    case noRefreshToken
    case invalidToken
    case encodingFailed
    case saveFailed
    case authenticationFailed
    case refreshFailed
    case biometricsFailed
    case biometricsExhausted
    case notImplemented
}

@available(macOS 14.0, *)
@MainActor
@Observable
class AuthManager {
    fileprivate let logger = Logger(label: "com.wso.AuthManager")
    static let shared = AuthManager()
    private var keychainKey = "com.wsomobile.authToken"
    private let keychainUsername = "com.wsomobile.username"

    var isAuthenticated = false

    // our tokens
    private var identityToken: String?
    private var authToken: String?

    // some info about auth state
    private var tokenExpiry: Date?
    private var biometricFailCount = 0
    private let maxBiometricAttempts = 3

    private init() {

    }

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
        logger.info("Identity token is being fetched...")
        if identityToken.data?.token != nil {
            logger.info("Identity token successfully fetched")
            logger.debug("Identity token data: \(identityToken.data!.token!)")
            logger.info("Auth token is being fetched...")
            let apiToken = try await WSOAPILogin(identityToken: identityToken.data!.token!)
            if apiToken.data?.token != nil {
                logger.info("Auth token successfully fetched")
                logger.debug("Auth token data: \(apiToken.data!.token!)")
                // now to decode our token
                _ = try decode(jwt: apiToken.data!.token!)
                //print(apiToken.data!.token!)
                //print(jwtToken.body)
                self.authToken = apiToken.data!.token!
                self.isAuthenticated = true
            } else {
                logger.error("Auth token could not be fetched")
                throw KeychainError.noToken
            }
        } else {
            logger.error("Identity token could not be fetched")
            throw KeychainError.noToken
        }
    }

    func logout() {
        logger.trace("User has logged out")
        self.authToken = nil
        self.isAuthenticated = false
    }
}
