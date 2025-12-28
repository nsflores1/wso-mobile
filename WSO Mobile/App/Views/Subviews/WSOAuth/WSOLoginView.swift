//
//  WSOLoginView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI

struct WSOLoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    // wondering how the user goes back to the correct screen?
    // this is a NavigationStack{}, so when we see our state updated at the
    // higher-level HomeView(), we pop this off the stack
    var body: some View {
        NavigationStack {
            VStack {
                Text("Enter your Unix login (no email):")
                TextField("Username", text: $username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.username)
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.password)
                    .lineLimit(1)
                Button("Login") {
                    Task {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        try await authManager.login(username: username, password: password)
                    }
                }
                .buttonStyle(.borderedProminent)
            }.padding(10)
                .navigationTitle(Text("Login to WSO"))
                .modifier(NavSubtitleIfAvailable(subtitle: "If you meant to use FaceID, enable it in settings"))
        }.padding(20)
    }
}

#Preview {
    WSOLoginView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
