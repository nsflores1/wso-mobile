//
//  LibraryHoursViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI
import Combine

@MainActor
class LibraryHoursViewModel: ObservableObject {
    @Published var libraryHours: [LibraryHours] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func loadHours() async {
        isLoading = true
        errorMessage = nil

        do {
            let data: [LibraryHours] = try await parseLibraryHours()
            self.libraryHours = data
        } catch {
            self.errorMessage = "Failed to load library hours."
        }

        isLoading = false
    }

}
