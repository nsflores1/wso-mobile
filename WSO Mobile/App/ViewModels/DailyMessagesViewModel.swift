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
    var dailyMessageCategories: [String: [DailyMessagePost]] = [:]
    var isLoading: Bool = false
    var error: WebRequestError?
    private var hasFetched = false

    func loadContent() async {
        isLoading = true

        do {
            let data: [String: [DailyMessagePost]] = try await parseDailyMessages()
            self.dailyMessageCategories = data
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
        hasFetched = false
        await fetchIfNeeded()
    }

    func clearCache() async {
        self.dailyMessageCategories = [:]
    }

}
