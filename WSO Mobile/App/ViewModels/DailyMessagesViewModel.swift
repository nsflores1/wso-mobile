//
//  DailyMessagesViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI

@MainActor
@Observable
class DailyMessagesViewModel {
    private let cache = CacheManager.shared

    var dailyMessageCategories: [String: [DailyMessagePost]] = [:]
    var isLoading: Bool = false
    var error: WebRequestError?

    private var hasFetched = false

    func loadContent() async {
        isLoading = true

        if let cached: [String: [DailyMessagePost]] = await cache.load(
            [String: [DailyMessagePost]].self,
            from: "viewmodelstate_daily_messages.json",
            maxAge: 3600 * 24
        ) {
            self.dailyMessageCategories = cached
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: [String: [DailyMessagePost]] = try await parseDailyMessages()
            self.dailyMessageCategories = data
            self.error = nil

            try await cache.save(data, to: "viewmodelstate_daily_messages.json")
        } catch let err as WebRequestError {
            self.error = err
            self.dailyMessageCategories = [:]
        } catch {
            self.error = WebRequestError.internalFailure
            self.dailyMessageCategories = [:]
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
            let data: [String: [DailyMessagePost]] = try await parseDailyMessages()
            self.dailyMessageCategories = data
            self.error = nil

            try await cache.save(data, to: "viewmodelstate_daily_messages.json")
        } catch let err as WebRequestError {
            self.error = err
            self.dailyMessageCategories = [:]
        } catch {
            self.error = WebRequestError.internalFailure
            self.dailyMessageCategories = [:]
        }

        isLoading = false
    }

    func clearCache() async {
        await cache.clear(path: "viewmodelstate_daily_messages.json")
        self.dailyMessageCategories = [:]
    }

}
