//
//  WSOFacTrakProfView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-02-07.
//

import SwiftUI

@MainActor
@Observable
class WSOFacTrakProfViewModel {
    private let cache = CacheManager.shared

    // cache per-id.
    let id: Int
    init(id: Int) {
        self.id = id
    }

    // contains ALL data.
    var data: WSOFacTrakProf? = nil
    var ratings: WSOFacTrakProfRatings? = nil

    var isLoading: Bool = false
    var error: WebRequestError?
    private var hasFetched = false

    func loadList() async {
        isLoading = true
        error = nil

        // only last about an hour
        if let cached: TimestampedData<WSOFacTrakProf> = await cache.load(
            WSOFacTrakProf.self,
            from: "factrak_prof_\(self.id).json",
            maxAge: 3600
        ) {
            self.data = cached.data
        }

        if let cachedRatings: TimestampedData<WSOFacTrakProfRatings> = await cache.load(
            WSOFacTrakProfRatings.self,
            from: "factrak_prof_ratings_\(self.id).json",
            maxAge: 3600
        ) {
            self.ratings = cachedRatings.data
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: WSOFacTrakProf = try await WSOFacTrakGetProf(query: self.id)
            self.data = data

            try await cache.save(data, to: "factrak_prof_\(self.id).json")

            let ratings: WSOFacTrakProfRatings = try await WSOFacTrakGetProfRatings(
                query: self.id
            )
            self.ratings = ratings
            self.error = nil

            try await cache.save(ratings, to: "factrak_prof_ratings_\(self.id).json")
        } catch let err as WebRequestError {
            self.error = err
            self.data = nil
            self.ratings = nil
        } catch {
            self.error = WebRequestError.internalFailure
            self.data = nil
            self.ratings = nil
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
            let data: WSOFacTrakProf = try await WSOFacTrakGetProf(query: self.id)
            self.data = data

            try await cache.save(data, to: "factrak_prof_\(self.id).json")

            let ratings: WSOFacTrakProfRatings = try await WSOFacTrakGetProfRatings(
                query: self.id
            )
            self.ratings = ratings
            self.error = nil

            try await cache.save(ratings, to: "factrak_prof_ratings_\(self.id).json")
        } catch let err as WebRequestError {
            self.error = err
            self.data = nil
            self.ratings = nil
        } catch {
            self.error = WebRequestError.internalFailure
            self.data = nil
            self.ratings = nil
        }

        isLoading = false
    }

    func clearCache() async {
        await cache.clear(path: "factrak_prof_\(self.id).json")
        await cache.clear(path: "factrak_prof_ratings_\(self.id).json")
        self.data = nil
        self.ratings = nil
    }
}
