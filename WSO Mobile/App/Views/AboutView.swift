//
//  AboutView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-23.
//

import SwiftUI

struct AboutView: View {
    @StateObject private var viewModel = AboutViewModel()

    var body: some View {
        VStack {
            Text("WSO Mobile")
                .font(.title)
                .fontWeight(.bold)
            // TODO: secretly make this a button as an easter egg
            if viewModel.isLoading {
                Text("Rolling dice...")
                    .font(.headline)
                    .fontWeight(.medium)
                    .italic(true)
            } else {
                Text(viewModel.words)
                    .font(.headline)
                    .fontWeight(.medium)
                    .italic(true)

            }
            Divider().tint(Color(.secondarySystemBackground))
            let text = """
                WSO is made possible by the following lovely people,
                 who all contributed greatly:
                """
            Text(text.replacingOccurrences(of: "\n", with: ""))
        }
        List {
            Section("Lead Developers (2026-2027)") {
                Text("Nathaniel Flores - nsf1@williams.edu")
                Text("Charlie Tharas - cmt8@wiliams.edu")
                Text("Nathan Vosburg - nvj1@williams.edu")
            }
            Section("App Artists") {
                Text("Emma Li - ebl2@williams.edu")
            }
            Section("Beta Testers") {
                Text("TODO: To be completed later!")
                    .italic(true)
            }
            Section("Special Mentions") {
                Text("Dylan Safai - das5@williams.edu")
                Text("Ye Shu - https://shuye.dev")
                Text("Matthew Baya - mjb9@williams.edu")
                Text("Aidan Lloyd-Tucker - aidanlloydtucker@gmail.com")
                Text("The many WSO developers of yore").italic(true)
            }
            NavigationLink("WSO is made possible by users like you. Thank you!") {
                EpheliaView()
            }
        }
        .task { await viewModel.loadWords() }
    }
}

#Preview {
    AboutView()
}
