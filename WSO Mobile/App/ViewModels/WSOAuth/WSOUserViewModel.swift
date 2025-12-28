//
//  WSOUserViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-26.
//

import SwiftUI

@MainActor
@Observable
class WSOUserViewModel {
    private let cache = CacheManager.shared

    var data: User? // this value MUST exist
    let userID: Int
    var isLoading: Bool = false
    var error: WebRequestError?
    private var hasFetched = false

    // must be initialized with the proper ID
    init(userID: Int) {
        self.userID = userID
    }

    func loadUser() async {
        isLoading = true
        error = nil

        if let cached: User = await cache.load(
            User.self,
            from: "userstate_\(userID).json",
            maxAge: 3600 * 24
        ) {
            self.data = cached
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: User = try await WSOGetUser(userid: userID)
            self.data = data
            self.error = nil

            try await cache.save(data, to: "userstate_\(userID).json")
        } catch let err as WebRequestError {
            self.error = err
            self.data = nil
        } catch {
            self.error = WebRequestError.internalFailure
            self.data = nil
        }

        isLoading = false
    }

    func fetchIfNeeded() async {
        guard !hasFetched else { return }
        hasFetched = true
        await loadUser()
    }

    func forceRefresh() async {
        isLoading = true

        do {
            let data: User = try await WSOGetUser(userid: userID)
            self.data = data
            self.error = nil

            try await cache.save(data, to: "userstate_\(userID).json")
        } catch let err as WebRequestError {
            self.error = err
            self.data = nil
        } catch {
            self.error = WebRequestError.internalFailure
            self.data = nil
        }

        isLoading = false
    }

    func clearCache() async {
        await cache.clear(path: "userstate_\(userID).json")
        self.data = nil
    }
}
