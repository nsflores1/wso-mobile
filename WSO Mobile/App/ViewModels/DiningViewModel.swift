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
    var error: WebRequestError?
    private var hasFetched = false

    func loadMenus() async {
        isLoading = true
        error = nil

        do {
            let data: [DiningHall] = try await parseWilliamsDining()
            self.diningMenu = data
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
        hasFetched = false
        await fetchIfNeeded()
    }

    func clearCache() async {
        self.diningMenu = []
    }

}
