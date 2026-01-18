//
//  WilliamsRecordViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-17.
//

import SwiftUI

@MainActor
@Observable
class WilliamsRecordViewModel {
    private let cache = CacheManager.shared

    var posts: [NewsFeed] = []
    var isLoading: Bool = false
    var lastUpdated: Date? = nil
    var error: WebRequestError?
    private var hasFetched = false

    func loadContent() async {
        isLoading = true
        error = nil

        if let cached: TimestampedData<[NewsFeed]> = await cache.load(
            [NewsFeed].self,
            from: "viewmodelstate_williams_record.json",
            maxAge: 3600 * 18 // a little under a day
        ) {
            self.posts = cached.data
            self.lastUpdated = cached.timestamp
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: [NewsFeed] = try await parseWilliamsRecord()
            self.lastUpdated = Date()
            self.posts = data
            self.error = nil

            try await cache.save(data, to: "viewmodelstate_williams_record.json")
        } catch let err as WebRequestError {
            self.error = err
            self.posts = []
        } catch {
            self.error = WebRequestError.internalFailure
            self.posts = []
        }

        isLoading = false
    }

    func fetchIfNeeded() async {
        guard !hasFetched else { return }
        hasFetched = true
        await loadContent()
    }

    func forceRefresh() async {
        isLoading = true

        do {
            let data: [NewsFeed] = try await parseWilliamsRecord()
            self.lastUpdated = Date()
            self.posts = data
            self.error = nil

            try await cache.save(data, to: "viewmodelstate_williams_record.json")
        } catch let err as WebRequestError {
            self.error = err
            self.posts = []
        } catch {
            self.error = WebRequestError.internalFailure
            self.posts = []
        }

        isLoading = false
    }

    func clearCache() async {
        await cache.clear(path: "viewmodelstate_williams_record.json")
        self.posts = []
        self.lastUpdated = nil
    }

}
