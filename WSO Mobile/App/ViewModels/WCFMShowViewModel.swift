//
//  WCFMShowViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-03.
//

import SwiftUI
import Combine

@MainActor
class WCFMShowViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentShows: WCFMShow?
    @Published var requestURL = URL(string: "https://spinitron.com/api/shows/")
    private var hasFetched = false

    func loadPlaylists() async {
        isLoading = true
        errorMessage = nil

        do {
            let data: WCFMShow = try await getWCFMShow()
            self.currentShows = data
        } catch {
            self.errorMessage = "Failed to load shows."
            self.currentShows = nil
        }

        isLoading = false
    }

    func fetchIfNeeded() async {
        guard !hasFetched else { return }
        hasFetched = true
        await loadPlaylists()
    }

    func forceRefresh() async {
        hasFetched = false
        await fetchIfNeeded()
    }

    func clearCache() async {
        self.currentShows = nil
    }

}
