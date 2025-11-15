//
//  ContentViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI // TODO: literally just for preview btw
import Combine

class ContentViewModel: ObservableObject {
    private var settings: AppSettings
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var diningIcon: String

    init(settings: AppSettings = .shared) {
        self.settings = settings
        self.diningIcon = "fork.knife"

        settings.$likesMath.sink { [weak self] newValue in
            self?.updateContentBasedOnMathPreference(newValue)
        }
        .store(in: &cancellables)
    }

    private func updateContentBasedOnMathPreference(_ likesMath: Bool) {
        diningIcon = likesMath ? "pi" : "fork.knife"
    }
}

#Preview {
    ContentView().environmentObject(AppSettings.shared)
}
