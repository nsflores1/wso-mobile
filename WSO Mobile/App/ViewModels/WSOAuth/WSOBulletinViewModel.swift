//
//  WSOBulletinViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-30.
//

import SwiftUI

@MainActor
@Observable
class WSOBulletinViewModel {
    private let cache = CacheManager.shared

    // contains ALL data.
    var data: [WSOBulletinItem] = []

    // for rendering. show a preview with length of 10 items
    // TODO: discussions, rides, not present via this API.
    // need to write separate endpoints for them
    var discussionsPreview: ArraySlice<WSOBulletinItem> {
        data.filter { $0.type == "discussions" }.prefix(10)
    }
    var announcementsPreview: ArraySlice<WSOBulletinItem> {
        data.filter { $0.type == "announcement" }.prefix(10)
    }
    var exchangePreview: ArraySlice<WSOBulletinItem> {
        data.filter { $0.type == "exchange" }.prefix(10)
    }
    var lostandfoundPreview: ArraySlice<WSOBulletinItem> {
        data.filter { $0.type == "lostAndFound" }.prefix(10)
    }
    var jobsPreview: ArraySlice<WSOBulletinItem> {
        data.filter { $0.type == "job" }.prefix(10)
    }
    var ridesPreview: ArraySlice<WSOBulletinItem> {
        data.filter { $0.type == "ride" }.prefix(10)
    }

    var isLoading: Bool = false
    var error: WebRequestError?
    private var hasFetched = false

    func loadList() async {
        isLoading = true
        error = nil

        // only last about an hour
        if let cached: [WSOBulletinItem] = await cache.load(
            [WSOBulletinItem].self,
            from: "bulletin_allData.json",
            maxAge: 3600
        ) {
            self.data = cached
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: [WSOBulletinItem] = try await WSOListBulletin()
            self.data = data
            self.error = nil

            try await cache.save(data, to: "bulletin_allData.json")
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
            let data: [WSOBulletinItem] = try await WSOListBulletin()
            self.data = data
            self.error = nil

            try await cache.save(data, to: "bulletin_allData.json")
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
        await cache.clear(path: "bulletin_allData.json")
        self.data = []
    }
}
