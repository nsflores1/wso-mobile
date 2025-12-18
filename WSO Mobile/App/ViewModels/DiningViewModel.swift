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
    var diningMenu: [DiningHall] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var diningURL: URL = URL(string: "https://wso.williams.edu/dining.json")!
    private var hasFetched = false

    func loadMenus() async {
        isLoading = true
        errorMessage = nil

        do {
            let data: [DiningHall] = try await parseWilliamsDining()
            self.diningMenu = data
        } catch {
            self.errorMessage = "Failed to load dining hours."
        }

        isLoading = false
    }

    func fetchIfNeeded() async {
        guard !hasFetched else { return }
        hasFetched = true
        await loadMenus()
    }

    func forceRefresh() async {
        hasFetched = false
        await fetchIfNeeded()
    }

    func clearCache() async {
        self.diningMenu = []
    }

}
