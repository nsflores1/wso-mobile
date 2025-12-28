//
//  LibraryHoursViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI

@MainActor
@Observable
class LibraryHoursViewModel {
    var libraryHours: [LibraryViewData] = []
    var isLoading: Bool = false
    var error: WebRequestError?
    private var hasFetched = false

    func loadHours() async {
        isLoading = true
        error = nil

        do {
            let data: [LibraryViewData] = try await parseLibraryHours()
            self.libraryHours = data
        } catch let err as WebRequestError {
            self.error = err
            self.libraryHours = []
        } catch {
            self.error = WebRequestError.internalFailure
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
