//
//  LibraryHoursViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI

@MainActor
class LibraryHoursViewModel {
    var libraryHours: [LibraryHours] = []
    var isLoading: Bool = false
    var errorMessage: String?
    private var hasFetched = false

    func loadHours() async {
        isLoading = true
        errorMessage = nil

        do {
            let data: [LibraryHours] = try await parseLibraryHours()
            self.libraryHours = data
        } catch {
            self.errorMessage = "Failed to load library hours."
            self.libraryHours = []
        }

        isLoading = false
    }

    func fetchIfNeeded() async {
        guard !hasFetched else { return }
        hasFetched = true
        await loadHours()
    }

    func forceRefresh() async {
        hasFetched = false
        await fetchIfNeeded()
    }

    func clearCache() async {
        self.libraryHours = []
    }

}
