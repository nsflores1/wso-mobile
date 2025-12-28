//
//  LibraryHoursViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI

@MainActor
@Observable
class LibraryHoursViewModel {
    private let cache = CacheManager.shared
    
    var libraryHours: [LibraryViewData] = []
    var isLoading: Bool = false
    var error: WebRequestError?
    private var hasFetched = false

    func loadHours() async {
        isLoading = true
        error = nil

        if let cached: [LibraryViewData] = await cache.load(
            [LibraryViewData].self,
            from: "viewmodelstate_library_hours.json",
            maxAge: 3600 * 24
        ) {
            self.libraryHours = cached
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: [LibraryViewData] = try await parseLibraryHours()
            self.libraryHours = data
            self.error = nil

            try await cache.save(data, to: "viewmodelstate_library_hours.json")
        } catch let err as WebRequestError {
            self.error = err
            self.libraryHours = []
        } catch {
            self.error = WebRequestError.internalFailure
            self.libraryHours = []
        }

        isLoading = false
    }

    func fetchIfNeeded() async {
        guard !hasFetched else { return }
        hasFetched = true
        await loadHours()
    }

    func forceRefresh() async {
        isLoading = true

        do {
            let data: [LibraryViewData] = try await parseLibraryHours()
            self.libraryHours = data
            self.error = nil

            try await cache.save(data, to: "viewmodelstate_library_hours.json")
        } catch let err as WebRequestError {
            self.error = err
            self.libraryHours = []
        } catch {
            self.error = WebRequestError.internalFailure
            self.libraryHours = []
        }

        isLoading = false
    }

    func clearCache() async {
        await cache.clear(path: "viewmodelstate_library_hours.json")
        self.libraryHours = []
    }

}
