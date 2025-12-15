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
    @Published var diningMenu: [DiningHall] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var diningURL: URL = URL(string: "https://wso.williams.edu/dining.json")!

    func loadMenus() async {
        isLoading = true
        errorMessage = nil

        do {
            let data: [DiningHall] = try await parseWilliamsDining()
            self.diningMenu = data
        } catch {
            self.errorMessage = "Failed to load dining hours."
        }

        isLoading = false
    }

}
