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
    @Published var localEater: Bool

    init(settings: AppSettings = .shared) {
        self.settings = settings
        self.diningIcon = "fork.knife"
        self.localEater = false

        settings.$likesMath.sink { [weak self] newValue in
            self?.updateContentBasedOnMathPreference(newValue)
        }
        .store(in: &cancellables)

        settings.$hatesEatingOut.sink { [weak self] newValue in
            self?.updateContentBasedOnEatingOutPreference(newValue)
        }
        .store(in: &cancellables)
    }

    private func updateContentBasedOnMathPreference(_ likesMath: Bool) {
        diningIcon = likesMath ? "pi" : "fork.knife"
    }

    private func updateContentBasedOnEatingOutPreference(_ hatesEatingOut: Bool) {
        localEater = hatesEatingOut
    }
}

#Preview {
    ContentView().environmentObject(AppSettings.shared)
}
