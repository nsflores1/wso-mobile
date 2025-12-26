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
    var error: WebRequestError?
    private var hasFetched = false

    // must be initialized with the proper ID
    init(userID: Int) {
        self.userID = userID
    }

    func loadUser() async {
        isLoading = true
        error = nil

        do {
            let data: User = try await WSOGetUser(userid: userID)
            self.data = data
        } catch let err as WebRequestError {
            self.error = err
            self.data = nil
        } catch {
            self.error = WebRequestError.internalFailure
            self.data = nil
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
