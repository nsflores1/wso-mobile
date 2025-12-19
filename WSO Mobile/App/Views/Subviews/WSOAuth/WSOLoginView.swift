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
    @State private var authManager = AuthManager()
    @State private var notificationManager = NotificationManager.shared

    var body: some View {
        NavigationStack {
            VStack {
                Text("Enter your Unix login (no email):")
                TextField("Username", text: $username)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.username)
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.password)
                    .lineLimit(1)
                Button("Login") {
                    Task {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        if try await authManager.login(
                            username: username,
                            password: password
                        ) == true {
                            await notificationManager.scheduleLocal(
                                title: "Hurray!",
                                body: "You have logged in successfully!",
                                date: Date().addingTimeInterval(1)
                            )
                        }
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
}
