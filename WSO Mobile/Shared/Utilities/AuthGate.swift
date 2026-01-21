//
//  AuthGate.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-05.
//

// used for gating views.

import SwiftUI
import Logging

struct AuthGate<Content: View>: View {
    @State var authManager = AuthManager.shared
    @State var isLoading: Bool = true
    @Environment(\.logger) private var logger

    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        if isLoading {
            ProgressView()
                .task {
                    await attemptAuth()
                }
        } else {
            // we authed either through token or login
            if authManager.isAuthenticated {
                content()
                    .transition(.opacity.animation(.easeInOut(duration: 0.25)))
            } else {
                WSOLoginView()
            }
        }
    }

    private func attemptAuth() async {
        do {
            _ = try await authManager.getToken()
            withAnimation(.easeInOut(duration: 0.25)) {
                isLoading = false
            }
        } catch {
            // if we fail that's ok, just note that we're done trying
            withAnimation(.easeInOut(duration: 0.25)) {
                isLoading = false
            }
            logger.error("Failed to get token: \(error.localizedDescription)")
        }
    }
}
