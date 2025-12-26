//
//  WSOUserViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-26.
//

import SwiftUI

@MainActor
@Observable
class WSOUserViewModel {
    var data: User? // this value MUST exist
    let userID: Int
    var isLoading: Bool = false
    var errorMessage: String?
    private var hasFetched = false

    // must be initialized with the proper ID
    init(userID: Int) {
        self.userID = userID
    }

    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    func loadUser() async {
        isLoading = true
        errorMessage = nil

        do {
            // TODO: add loading state from backend
            let fileURL = docDir.appendingPathComponent("viewmodel_state.json")
            let data: User = try await WSOGetUser(userid: userID)
            self.data = data
        } catch {
            self.errorMessage = "Failed to load user."
            print(self.errorMessage!)
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
