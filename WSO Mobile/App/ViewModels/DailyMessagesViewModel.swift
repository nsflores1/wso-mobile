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

    func loadContent() async {
        isLoading = true
        errorMessage = nil

        do {
            let data: [String: [DailyMessagePost]] = try await parseDailyMessages()
            self.dailyMessageCategories = data
        } catch {
            self.errorMessage = "Failed to load daily messages."
            self.dailyMessageCategories = [:]
        }

        isLoading = false
    }

}
