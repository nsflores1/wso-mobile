//
//  DiningViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-19.
//

import SwiftUI

@MainActor
@Observable
class DiningHoursViewModel {
    private let cache = CacheManager.shared

    var diningMenu: [DiningHall] = []
    var isLoading: Bool = false
    var error: WebRequestError?
    private var hasFetched = false

    // TODO: this needs a rewrite as follows:
    // - loadMenus() should take an optional argument for fetching a specific day
    // - new function loadDays() should fetch the list of days. if that fails,
    //   gracefully degrade to normal one-day performance.
    // - we need a way to compare dates. by looking at them, we should be able to
    //   determine if the date is over a week old and then purge it from user cache,
    //   which clearCache() should do with a wildcard file operation since
    //   enumerating the days is too hard
    func loadMenus() async {
        isLoading = true
        error = nil

        if let cached: [DiningHall] = await cache.load(
            [DiningHall].self,
            from: "viewmodelstate_dining_menus.json",
            maxAge: 3600 * 24 // one day is probably fine
        ) {
            self.diningMenu = cached
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: [DiningHall] = try await parseWilliamsDining()
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
    }

}
