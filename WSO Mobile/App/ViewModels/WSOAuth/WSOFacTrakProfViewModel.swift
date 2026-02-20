//
//  WSOFacTrakProfView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-02-07.
//

import SwiftUI

@MainActor
@Observable
class WSOFacTrakOverviewViewModel {
    private let cache = CacheManager.shared

    // cache per-id.
    let id: Int

    init(id: Int) {
        self.id = id
    }

        // contains ALL data.
    var data: [WSOFacTrakAreasOfStudy] = []

    var isLoading: Bool = false
    var error: WebRequestError?
    private var hasFetched = false

    func loadList() async {
        isLoading = true
        error = nil

            // only last about an hour
        if let cached: TimestampedData<[WSOFacTrakAreasOfStudy]> = await cache.load(
            [WSOFacTrakAreasOfStudy].self,
            from: "factrak_overview.json",
            maxAge: 3600
        ) {
            self.data = cached.data
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: [WSOFacTrakAreasOfStudy] = try await WSOFacTrakGetAreasOfStudy()
            self.data = data
            self.error = nil

            try await cache.save(data, to: "factrak_overview.json")
        } catch let err as WebRequestError {
            self.error = err
            self.data = []
        } catch {
            self.error = WebRequestError.internalFailure
            self.data = []
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
            let data: [WSOFacTrakAreasOfStudy] = try await WSOFacTrakGetAreasOfStudy()
            self.data = data
            self.error = nil

            try await cache.save(data, to: "factrak_overview.json")
        } catch let err as WebRequestError {
            self.error = err
            self.data = []
        } catch {
            self.error = WebRequestError.internalFailure
            self.data = []
        }

        isLoading = false
    }

    func clearCache() async {
        await cache.clear(path: "factrak_overview.json")
        self.data = []
    }
}
