//
//  DiningViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-19.
//

import SwiftUI
import Combine

@MainActor
class DiningHoursViewModel: ObservableObject {
    @Published var diningMenu: [String: Vendor] = [:]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func loadMenus() async {
        isLoading = true
        errorMessage = nil

        do {
                //URLCache.shared.removeAllCachedResponses() // nuke all caches
                // TODO: UNCOMMENT ABOVE BEFORE PROD RELEASE
            let data: MenuResponse = try await parseWilliamsDining()
            self.diningMenu = data.vendors
        } catch {
            self.errorMessage = "Failed to load dining hours."
            self.diningMenu = [:]
        }

        isLoading = false
    }

}
