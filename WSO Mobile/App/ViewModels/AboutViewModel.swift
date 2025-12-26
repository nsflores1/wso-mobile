//
//  AboutViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI

@MainActor
@Observable
class AboutViewModel {
    var words: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    private var hasFetched = false

    func loadWords() async {
        isLoading = true
        errorMessage = nil

        do {
            let data: String = try await WSOGetWords()
            self.words = data
        } catch {
            // we don't need robust error handling for this
            // if it fails, it fails
            self.errorMessage = "Failed to load WSO words."
            self.words = "Williams Students Online"
        }

        isLoading = false
    }

    func fetchIfNeeded() async {
        guard !hasFetched else { return }
        hasFetched = true
        await loadWords()
    }

    func forceRefresh() async {
        hasFetched = false
        await fetchIfNeeded()
    }

    func clearCache() async {
        self.words = ""
    }

}
