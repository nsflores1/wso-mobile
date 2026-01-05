//
//  PastMenuViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-05.
//

// this view model is a constructor for a specific PAST MENU.

import SwiftUI
import Logging

@MainActor
@Observable
class PastMenuViewModel {
    private let cache = CacheManager.shared

    var diningMenu: [DiningHall] = []
    var isLoading: Bool = false
    var error: WebRequestError?
    private var hasFetched = false

    let pastDay: Date

    init(_ date: Date) {
        self.pastDay = date
    }

    // gonna need this a lot
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        let string = formatter.string(from: date)
        return string
    }

    func loadMenus() async {
        isLoading = true
        error = nil

        if let cached: [DiningHall] = await cache.load(
            [DiningHall].self,
            from: "viewmodelstate_dining_menu_past_menu_\(dateToString(pastDay)).json",
            maxAge: 3600 * 24 // one day is probably fine
        ) {
            self.diningMenu = cached
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: [DiningHall] = try await getSinglePastWilliamsDiningMenus(date: pastDay)
            self.diningMenu = data
            self.error = nil

            try await cache.save(data, to: "viewmodelstate_dining_menu_past_menu_\(dateToString(pastDay)).json")
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
            let data: [DiningHall] = try await getSinglePastWilliamsDiningMenus(date: pastDay)
            self.diningMenu = data
            self.error = nil

            try await cache.save(data, to: "viewmodelstate_dining_menu_past_menu_\(dateToString(pastDay)).json")
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
        await cache.clear(path: "viewmodelstate_dining_menu_past_menu_\(dateToString(pastDay)).json")
        self.diningMenu = []
    }

}
