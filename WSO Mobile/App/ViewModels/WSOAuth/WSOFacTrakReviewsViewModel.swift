//
//  WSOFacTrakProfView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-02-07.
//

import SwiftUI

@MainActor
@Observable
class WSOFacTrakReviewsViewModel {
    private let cache = CacheManager.shared

    // cache per-id.
    let id: Int
    let type: WSOFacTrakTypes

    init(id: Int, type: WSOFacTrakTypes) {
        self.id = id
        self.type = type
    }
    // contains ALL data.
    var data: [WSOFacTrakMinimalReview]? = nil

    var isLoading: Bool = false
    var error: WebRequestError?
    private var hasFetched = false

    func loadList() async {
        isLoading = true
        error = nil

        // only last about an hour
        if let cached: TimestampedData<[WSOFacTrakMinimalReview]> = await cache.load(
            [WSOFacTrakMinimalReview].self,
            from: "factrak_reviews_\(self.id).json",
            maxAge: 3600
        ) {
            self.data = cached.data
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: [WSOFacTrakMinimalReview] = try await WSOFacTrakGetReviews(
                query: self.id,
                kind: self.type
            )
            self.data = data
            self.error = nil

            try await cache.save(data, to: "factrak_reviews_\(self.id).json")
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
        await loadList()
    }

    func forceRefresh() async {
        isLoading = true

        do {
            let data: [WSOFacTrakMinimalReview] = try await WSOFacTrakGetReviews(
                query: self.id,
                kind: self.type
            )
            self.data = data
            self.error = nil

            try await cache.save(data, to: "factrak_reviews_\(self.id).json")
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
        await cache.clear(path: "factrak_reviews_\(self.id).json")
        self.data = nil
    }
}
