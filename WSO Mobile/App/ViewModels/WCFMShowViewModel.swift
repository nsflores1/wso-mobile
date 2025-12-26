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
    var error: WebRequestError?
    var currentShows: WCFMShow?
    private var hasFetched = false

    func loadPlaylists() async {
        isLoading = true
        error = nil

        do {
            let data: WCFMShow = try await getWCFMShow()
            self.currentShows = data
        }  catch let err as WebRequestError {
            self.error = err
            self.currentShows = nil
        } catch {
            self.error = WebRequestError.internalFailure
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
