//
//  AuthGate.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-05.
//

// used for gating views.

import SwiftUI

struct AuthGate<Content: View>: View {
    @State var authManager = AuthManager.shared
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        Group {
            if authManager.isAuthenticated {
                content()
            } else {
                WSOLoginView()
            }
        }
    }
}
