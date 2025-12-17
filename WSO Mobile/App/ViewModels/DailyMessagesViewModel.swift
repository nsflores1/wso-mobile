//
//  DailyMessagesViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI
import Combine

@MainActor
class DailyMessagesViewModel: ObservableObject {
    @Published var dailyMessageCategories: [String: [DailyMessagePost]] = [:]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var requestURL: URL = URL(string: "https://events.williams.edu/wp-json/wms/events/v1/list/dm")!
    private var hasFetched = false

    func loadContent() async {
        isLoading = true
        errorMessage = nil

        do {
            let data: [String: [DailyMessagePost]] = try await parseDailyMessages()
            self.dailyMessageCategories = data
        } catch {
            let date = Date()
            let calendar = Calendar.current
            if (calendar.component(.weekday, from: date) == 1 || calendar.component(.weekday, from: date) == 7) {
                self.errorMessage = "No daily messages available on a weekend."
                self.dailyMessageCategories = [:]
                
            }
            else {
                self.errorMessage = "Failed to load daily messages."
                self.dailyMessageCategories = [:]
            }
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
