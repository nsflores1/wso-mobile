//
//  AboutViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI
import Combine

@MainActor
class AboutViewModel: ObservableObject {
    @Published var words: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private var hasFetched = false

    func loadWords() async {
        isLoading = true
        errorMessage = nil

        do {
                //URLCache.shared.removeAllCachedResponses() // nuke all caches
                // TODO: UNCOMMENT ABOVE BEFORE PROD RELEASE
            let data: String = try await WSOGetWords()
            self.words = data
        } catch {
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

}
