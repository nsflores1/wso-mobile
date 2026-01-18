//
//  WSOUserViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-25.
//

import SwiftUI

@MainActor
@Observable
class WSOSelfUserViewModel {
    private let cache = CacheManager.shared

    var data: User? // this value MUST exist
    var isLoading: Bool = false
    var lastUpdated: Date? = nil
    var error: WebRequestError?
    private var hasFetched = false

    func loadUser() async {
        isLoading = true
        error = nil

        if let cached: TimestampedData<User> = await cache.load(
            User.self,
            from: "userstate_me.json",
            maxAge: 3600 * 24
        ) {
            self.data = cached.data
            self.lastUpdated = cached.timestamp
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: User = try await WSOGetUserSelf()
            self.lastUpdated = Date()
            self.data = data
            self.error = nil

            try await cache.save(data, to: "userstate_me.json")
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
            let data: User = try await WSOGetUserSelf()
            self.lastUpdated = Date()
            self.data = data
            self.error = nil

            try await cache.save(data, to: "userstate_me.json")
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
        await cache.clear(path: "userstate_me.json")
        self.data = nil
        self.lastUpdated = nil
    }
}
