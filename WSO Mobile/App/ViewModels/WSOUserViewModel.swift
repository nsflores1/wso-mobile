//
//  WSOUserViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-25.
//

import SwiftUI

@MainActor
@Observable
class WSOUserViewModel {
    var data: User? // this value MUST exist
    var isLoading: Bool = false
    var errorMessage: String?
    private var hasFetched = false

    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    func loadUser() async {
        isLoading = true
        errorMessage = nil

        do {
            // TODO: add loading state from backend
            let fileURL = docDir.appendingPathComponent("viewmodel_state.json")
            let data: User = try await WSOGetUserSelf()
            self.data = data
        } catch {
            self.errorMessage = "Failed to load user."
        }

        isLoading = false
    }

    func fetchIfNeeded() async {
        guard !hasFetched else { return }
        hasFetched = true
        await loadUser()
    }

    func forceRefresh() async {
        hasFetched = false
        await fetchIfNeeded()
    }

    func clearCache() async {
        self.data = nil
    }
}
