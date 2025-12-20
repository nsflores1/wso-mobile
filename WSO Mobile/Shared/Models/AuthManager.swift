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

// TODO: this has a bunch of stuff that most users will never see,
// which is probably fine.

// shamelessly stole this enum from Apple
enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case biometricsUnavailable
    case authenticationFailed
    case unhandledError(status: OSStatus)
}

@available(macOS 14.0, *)
@MainActor
@Observable
class AuthManager {
    static let shared = AuthManager()

    var isAuthenticated: Bool = false
    var currentUser: User?

    private var keychainKey: String = "com.wsomobile.authToken"
    private var authToken: String?

    func saveToken(_ token: String) throws {
        let data = token.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            kSecUseAuthenticationContext as String: LAContext()
        ]

        // overwrite current item
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    // note that this can throw, so handle that!
    // in which case the user must manually re-enter auth details
    // every single time from their password booklet.
    func getToken() async throws -> String {
        let context = LAContext()
        context.localizedReason = "Authenticate to access your WSO account"

        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw KeychainError.biometricsUnavailable
        }

        // try FaceID first before doing anything else
        let success = try await context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Unlock app"
        )

        guard success else {
            throw KeychainError.authenticationFailed
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecReturnData as String: true,
            kSecUseAuthenticationContext as String: context
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            throw KeychainError.unhandledError(status: status)
        }
        self.authToken = token
        return token
    }

    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey
        ]
        SecItemDelete(query as CFDictionary)
        // we had better not keep using it, then
        // if you call this, don't be a moron and remember to get a fresh token
        self.authToken = nil
    }

    // this should be used in the case we need to login,
    // but only fall back to this if getToken() throws.
    // initially, you should start by trying to getToken(),
    // and then switch back to a login screen.
    func login(username: String, password: String) async throws -> Bool {
        let token = try await WSOAuthLogin(password: password, unixID: username)
        if token.data?.token != nil {
            try saveToken(token.data!.token!)
            self.authToken = token.data!.token!
            // now the moment of truth:
            print(self.authToken ?? "(no token)")
            self.currentUser = try await WSOGetUserSelf()
            if self.currentUser != nil {
                self.isAuthenticated = true
                return true
            } else {
                // this token is clearly bogus
                self.isAuthenticated = false
                self.authToken = nil
                return false
            }
        }
        return false
        // TODO: Something that needs to be implemented in here:
        // if our token fails on backend, we need to reload it
    }

    func logout() {
        authToken = nil
        isAuthenticated = false
        currentUser = nil
    }
}
