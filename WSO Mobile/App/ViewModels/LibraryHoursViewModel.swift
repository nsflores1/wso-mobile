//
//  LibraryHoursViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI
import Combine

@MainActor
class LibraryHoursViewModel: ObservableObject {
    @Published var libraryHours: [LibraryHours] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var requestURL: URL = URL(string: "https://libcal.williams.edu/api_hours_today.php")!
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
