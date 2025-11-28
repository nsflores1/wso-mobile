//
//  AuthManager.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-28.
//

// This is a weird meta-class that stores info not related to any particular
// ViewModel, but is too useful to end up duplicating across a bunch of files.

import Foundation
import Combine
import LocalAuthentication

// TODO: this has a bunch of stuff that most users will never see,
// which is probably fine.

struct User: Codable {
    let admin: Bool
    let atWilliams: Bool
    let cellPhone: String?
    let classYear: Int
    let hasAcceptedDormtrakPolicy: Bool
    let hasAcceptedFactrakPolicy: Bool
    let homeCountry: String?
    let homePhone: String?
    let homeState: String?
    let homeTown: String?
    let homeVisible: Bool
    let id: Int
    let name: String
    let pronoun: String
    let unixID: String
    let visible: Bool
    let williamsEmail: String
    let williamsID: String
}

// shamelessly stole this enum from Apple
enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case biometricsUnavailable
    case authenticationFailed
    case unhandledError(status: OSStatus)
}

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?

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
        context.localizedReason = "Authenticate to access your account"

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
        return token
    }

    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey
        ]
        SecItemDelete(query as CFDictionary)
    }

    func login(username: String, password: String) async throws {
        // Something that needs to be implemented in here:
        // if our token fails on backend, we need to reload it
    }

    func logout() {
        authToken = nil
        isAuthenticated = false
        currentUser = nil
    }
}
