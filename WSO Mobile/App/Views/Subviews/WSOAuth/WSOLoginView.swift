//
//  WSOLoginView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI
import Logging

struct WSOLoginView: View {
    @Environment(\.logger) private var logger
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false

    // a handle to show the fail login screen, in case the user keeps retapping
    @State private var errorString: String = ""
    @State private var showError: Bool = false
    @State private var hideTask: Task<Void, Never>?

    // wondering how the user goes back to the correct screen?
    // this is a NavigationStack{}, so when we see our state updated at the
    // higher-level HomeView(), we pop this off the stack
    var body: some View {
        NavigationStack {
            VStack {
                if showError && errorString.contains("401") {
                    Text("Your password is wrong, please try again...")
                        .foregroundStyle(.red)
                        .transition(.opacity)
                        .padding(.vertical, 20)
                } else if showError {
                    Text(errorString)
                        .foregroundStyle(.red)
                        .transition(.opacity)
                        .padding(.vertical, 20)
                }
                Text("Enter your Unix login (no email):")
                TextField("Username", text: $username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.username)

                Group {
                    if showPassword {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .textFieldStyle(.roundedBorder)
                .textContentType(.password)
                .lineLimit(1)
                .overlay(alignment: .trailing) {
                    HStack(spacing: 8) {
                        if !password.isEmpty {
                            Button {
                                password = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(6)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                }

                Button("Login") {
                    Task {
                        logger.trace("Login is being attempted...")
                        let generator = UINotificationFeedbackGenerator()
                        generator.prepare()
                        do {
                            try await authManager.login(username: username, password: password)
                            logger.info("Login succeeded")
                            generator.notificationOccurred(.success)
                        } catch {
                            logger.error("Login failed: \(error.localizedDescription)")
                            generator.notificationOccurred(.error)
                            failedLogin(error.localizedDescription)
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .animation(.easeInOut(duration: 0.2), value: showError)
            .padding(10)
            .navigationTitle(Text("Login to WSO"))
            .modifier(NavSubtitleIfAvailable(subtitle: "If you meant to use FaceID, enable it in settings"))
        }.padding(20)
    }

    // I don't normally like to attach functions to views,
    // but this one is so small it really should just go here
    func failedLogin(_ text: String) {
        showError = true
        errorString = text

        hideTask?.cancel()
        hideTask = Task {
            try? await Task.sleep(for: .seconds(5))
            guard !Task.isCancelled else { return }
            await MainActor.run {
                showError = false
                errorString = ""
            }
        }
    }
}

#Preview {
    WSOLoginView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
