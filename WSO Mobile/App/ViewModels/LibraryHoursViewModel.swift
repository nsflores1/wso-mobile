//
//  LibraryHoursViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI
import WidgetKit

@MainActor
@Observable
class LibraryHoursViewModel {
    // this one is instantiated globally,
    // because the home page needs to be able to refresh it
    static let shared = LibraryHoursViewModel()
    private let cache = CacheManager.shared
    
    var libraryHours: [LibraryViewData] = []
    var isLoading: Bool = false
    var lastUpdated: Date? = nil
    var error: WebRequestError?
    private var hasFetched = false

    // this special function exists for all widget-having ViewModels and allows them
    // to fetch data and stash it into the widget.
    func widgetUpdate(_ data: Codable) {
        if let sharedDefaults = UserDefaults(suiteName: "group.com.WSO") {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(data) {
                sharedDefaults.set(encoded, forKey: "libraries")
                // push data out to widgets
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }

    func loadHours() async {
        isLoading = true
        error = nil

        if let cached: TimestampedData<[LibraryViewData]> = await cache.load(
            [LibraryViewData].self,
            from: "viewmodelstate_library_hours.json",
            maxAge: 3600 * 4 // four hours
        ) {
            self.libraryHours = cached.data
            widgetUpdate(cached.data)
            self.lastUpdated = cached.timestamp
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: [LibraryViewData] = try await parseLibraryHours()
            widgetUpdate(data)
            self.lastUpdated = Date()
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
            widgetUpdate(data)
            self.lastUpdated = Date()
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
        self.lastUpdated = nil
    }

}
