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

    @StateObject private var authManager = AuthManager()

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
                        let result = try await authManager.login(username: username, password: password)
                        if result == true {
                            print("yay success!!!")
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
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
