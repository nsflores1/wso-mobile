//
//  LinksViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-18.
//

import SwiftUI

@MainActor
@Observable
class LinksViewModel {
    private let cache = CacheManager.shared

    var data: [WSOImportantLinksSections] = []
    var isLoading: Bool = false
    var lastUpdated: Date? = nil
    var error: WebRequestError?

    private var hasFetched = false

    func loadContent() async {
        isLoading = true

        if let cached: TimestampedData<[WSOImportantLinksSections]> = await cache.load(
            [WSOImportantLinksSections].self,
            from: "viewmodelstate_links.json",
            maxAge: 3600 * 4 // four hours
        ) {
            self.data = cached.data
            self.lastUpdated = cached.timestamp
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: [WSOImportantLinksSections] = try await getImportantLinks().sections
            self.lastUpdated = Date()
            self.data = data
            self.error = nil

            try await cache.save(data, to: "viewmodelstate_links.json")
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
        await loadContent()
    }

    func forceRefresh() async {
        isLoading = true

        do {
            let data: [WSOImportantLinksSections] = try await getImportantLinks().sections
            self.lastUpdated = Date()
            self.data = data
            self.error = nil

            try await cache.save(data, to: "viewmodelstate_links.json")
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
        await cache.clear(path: "viewmodelstate_links.json")
        self.data = []
        self.lastUpdated = nil
    }

}
