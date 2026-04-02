//
//  DiningViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-19.
//

import SwiftUI
import Logging
import WidgetKit

@MainActor
@Observable
class DiningHoursViewModel {
    private let cache = CacheManager.shared
    fileprivate let logger = Logger(label: "com.wso.DiningViewModel")

    var diningMenu: [DiningHall] = []
    var lastUpdated: Date? = nil
    var isLoading: Bool = false
    var error: WebRequestError?
    private var hasFetched = false

    // this special function exists for all widget-having ViewModels and allows them
    // to fetch data and stash it into the widget.
    func widgetUpdate(_ data: Codable) {
        if let sharedDefaults = UserDefaults(suiteName: "group.com.WSO") {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(data) {
                sharedDefaults.set(encoded, forKey: "halls")
                // push data out to widgets
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }

    func loadMenus() async {
        isLoading = true
        error = nil

        if let cached: TimestampedData<[DiningHall]> = await cache.load(
            [DiningHall].self,
            from: "viewmodelstate_dining_menus.json",
            maxAge: 3600 * 1 // four hours
        ) {
            self.diningMenu = cached.data
            widgetUpdate(cached.data)
            self.lastUpdated = cached.timestamp
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: [DiningHall] = try await parseWilliamsDining()
            widgetUpdate(data)
            self.lastUpdated = Date()
            self.diningMenu = data
            self.error = nil

            try await cache.save(data, to: "viewmodelstate_dining_menus.json")
        } catch let err as WebRequestError {
            self.error = err
            self.diningMenu = []
        } catch {
            self.error = WebRequestError.internalFailure
            self.diningMenu = []
        }

        isLoading = false
    }

    func fetchIfNeeded() async {
        guard !hasFetched else { return }
        hasFetched = true
        await loadMenus()
    }

    func forceRefresh() async {
        isLoading = true

        do {
            let data: [DiningHall] = try await parseWilliamsDining()
            widgetUpdate(data)
            self.lastUpdated = Date()
            self.diningMenu = data
            self.error = nil

            try await cache.save(data, to: "viewmodelstate_dining_menus.json")
        } catch let err as WebRequestError {
            self.error = err
            self.diningMenu = []
        } catch {
            self.error = WebRequestError.internalFailure
            self.diningMenu = []
        }

        isLoading = false
    }

    func clearCache() async {
        await cache.clear(path: "viewmodelstate_dining_menus.json")
        self.diningMenu = []
        self.lastUpdated = nil
    }
}
