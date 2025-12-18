//
//  WCFMShowViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-03.
//

import SwiftUI

@MainActor
@Observable
class WCFMShowViewModel {
    var isLoading: Bool = false
    var errorMessage: String?
    var currentShows: WCFMShow?
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
