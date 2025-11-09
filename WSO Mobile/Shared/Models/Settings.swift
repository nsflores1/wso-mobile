//
//  Settings.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import Combine
import Foundation

class AppSettings: ObservableObject {
    static let shared = AppSettings()

    @Published var likesMath: Bool {
        didSet { UserDefaults.standard.set(likesMath, forKey: "likesMath") }
    }

    private init() {
        likesMath = UserDefaults.standard.bool(forKey: "likesMath")
    }
}
