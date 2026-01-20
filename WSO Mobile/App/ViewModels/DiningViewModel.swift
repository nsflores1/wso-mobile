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
    var pastList: [Date] = []
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

    // this can load in the background, it's fine. no need to block
    // this isn't critical, so we don't err if it explodes
    func loadDays() async {
        if let cached: TimestampedData<[Date]> = await cache.load(
            [Date].self,
            from: "viewmodelstate_dining_menus_past_list.json",
            maxAge: 3600 * 4 // four hours
        ) {
            self.pastList = cached.data
            self.lastUpdated = cached.timestamp
            return
        }

        do {
            let data: [Date] = try await getListPastWilliamsDiningMenus()
            self.lastUpdated = Date()
            try await cache.save(data, to: "viewmodelstate_dining_menus_past_list.json")
        } catch let err as WebRequestError {
            logger.error("Error on fetching past days: \(err)")
            self.pastList = []
        } catch {
            // this should never execute
            logger.critical("Something has gone horribly wrong with fetching past menu days, and WebRequest died!")
            self.pastList = []
        }
    }

    func fetchIfNeeded() async {
        guard !hasFetched else { return }
        hasFetched = true
        await loadMenus()
        // realistically, nobody should be using this, but we'll put it here anyways
        await loadDays()
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

        // then, once we've got the main menu, then fetch last ones
        // this isn't critical, so we don't err if it explodes
        do {
            let dateData: [Date] = try await getListPastWilliamsDiningMenus()
            try await cache.save(dateData, to: "viewmodelstate_dining_menus_past_list.json")
        } catch let err as WebRequestError {
            logger.error("Error on fetching past days: \(err)")
            self.pastList = []
        } catch {
            logger.critical("Something has gone horribly wrong with fetching past menu days, and WebRequest died!")
            self.pastList = []
        }

        isLoading = false
    }

    func clearCache() async {
        await cache.clear(path: "viewmodelstate_dining_menus.json")
        // now go and delete all past menus
        let cacheURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("cache")
        let filesToDelete = (try? FileManager.default.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil))?.filter {
            $0.lastPathComponent.contains("past_menu")
        } ?? []

        for file in filesToDelete {
            try? FileManager.default.removeItem(at: file)
        }
        self.diningMenu = []
        self.lastUpdated = nil
    }
}
