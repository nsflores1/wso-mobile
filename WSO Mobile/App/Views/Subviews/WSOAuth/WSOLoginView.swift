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
                        try await authManager.login(username: username, password: password)
                    }
                }
                .buttonStyle(.borderedProminent)
            }.padding(10)
            .navigationTitle(Text("Login to WSO"))
        }.padding(20)

    }
}

#Preview {
    WSOLoginView()
}
