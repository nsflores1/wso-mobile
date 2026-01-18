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
    case noUsername
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

    // some internal state
    var isAuthenticated = false
    let context = LAContext()

    static let server = "wso.williams.edu"
    static let account = "tokens"

    // our tokens
    struct StoredTokens: Codable {
        let identityToken: String
        let authToken: String
        let authExpiry: Date
    }
    private var tokens: StoredTokens?

    // some info about auth state
    private var tokenExpiry: Date?
    private var biometricFailCount = 0
    private let maxBiometricAttempts = 3

    private init() { }

    private func save(_ tokens: StoredTokens) throws {
        let data = try JSONEncoder().encode(tokens)

        logger.debug("Created SecAccessControlFlags")
        let access = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            [.biometryCurrentSet],
            nil
        )!

        // let the system be smart
        context.interactionNotAllowed = true

        logger.debug("Query started with kSecUseAuthenticationContext")
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: AuthManager.server,
            kSecAttrAccount as String: AuthManager.account,
            kSecValueData as String: data,
            kSecAttrAccessControl as String: access,
            kSecUseAuthenticationContext as String: context,
            kSecUseAuthenticationUI as String: kSecUseAuthenticationContext
        ]

        logger.debug("Deleting SecItemDelete")
        SecItemDelete(query as CFDictionary)
        logger.debug("Adding SecItemAdd")
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            logger.debug("something's fucked up on save!!! abort!!!")
            throw NSError(domain: "keychain", code: Int(status))
        }
    }

    private func load() throws -> StoredTokens {
        context.localizedReason = "Authenticating..."
        context.interactionNotAllowed = false

        logger.debug("Load query started with kSecUseAuthenticationContext")
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: AuthManager.server,
            kSecAttrAccount as String: AuthManager.account,
            kSecReturnData as String: true,
            kSecUseAuthenticationContext as String: context,
            kSecUseAuthenticationUI as String: kSecUseAuthenticationContext
        ]

        var item: CFTypeRef?
        logger.debug("Checking: does SecItemCopyMatching not segfault?")
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Data else {
            logger.debug("something's fucked up on load!!! abort!!!")
            throw NSError(domain: "keychain", code: Int(status))
        }

        return try JSONDecoder().decode(StoredTokens.self, from: data)
    }

    func getToken() async throws -> String {
        logger.debug("Loading token from memory...")
        let tokens: StoredTokens? = try load()
        guard let tokens else { throw KeychainError.noToken }
        if tokens.authExpiry > Date() {
            logger.debug("Loading token from memory success, in cache")
            self.isAuthenticated = true
            return tokens.authToken
        } else {
            logger.debug("Loading token is out of date, retrying now...")
            return try await refreshToken()
        }
    }

    func refreshToken() async throws -> String {
        logger.debug("Loading token from memory...")
        let tokens: StoredTokens? = try load()
        guard let tokens else { throw KeychainError.noToken }
        let response: WSOAuthLogin? = try await WSOAPIRefresh(identityToken: tokens.identityToken)
        guard let response else { throw KeychainError.authenticationFailed }

        guard let update = response.data?.token else {
            throw KeychainError.noRefreshToken
        }

        let updated = StoredTokens(
            identityToken: tokens.identityToken,
            authToken: update,
            authExpiry: try decode(jwt: update).expiresAt!
        )

        try save(updated)
        self.isAuthenticated = true
        return update
    }

    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: AuthManager.server,
            kSecAttrAccount as String: AuthManager.account
        ]
        SecItemDelete(query as CFDictionary)
    }

    func wipeAppKeychain() {
        let secItemClasses = [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity
        ]

        for secClass in secItemClasses {
            let query: [String: Any] = [
                kSecClass as String: secClass
            ]
            SecItemDelete(query as CFDictionary)
        }
    }

    func login(username: String, password: String) async throws {
        let identityToken = try await WSOIdentityLogin(password: password, unixID: username)
        logger.info("Identity token is being fetched...")

        if identityToken.data?.token != nil {
            logger.info("Identity token successfully fetched")
            logger.debug("Identity token data: \(identityToken.data!.token!)")
            logger.info("Auth token is being fetched...")

            let apiToken = try await WSOAPILogin(identityToken: identityToken.data!.token!)

            if apiToken.data?.token != nil {
                logger.info("Auth token successfully fetched")
                logger.debug("Auth token data: \(apiToken.data!.token!)")
                self.tokens = StoredTokens(
                    identityToken: identityToken.data!.token!,
                    authToken: apiToken.data!.token!,
                    authExpiry: try decode(jwt: apiToken.data!.token!).expiresAt!
                )
                // if we get to this point it def exists so unwrap ok
                try save(self.tokens!)
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
        deleteToken()
        self.tokens = nil
        self.isAuthenticated = false
    }
}
