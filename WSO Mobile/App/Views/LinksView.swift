//
//  LinksView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-13.
//

import SwiftUI

struct LinksView: View {
    @Environment(\.openURL) private var openURL

    let impact = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: SettingsView()) {
                        Label("App Settings", systemImage: "gear")
                    }
                    Button {
                        if let url = URL(string: "https://forms.gle/NqYdAAbZKPQmPq866"){
                            impact.impactOccurred()
                            openURL(url)
                        }
                    } label: {
                        HStack {
                            Label("Send Feedback", systemImage: "paperplane")
                        }
                    }
                    .buttonStyle(.plain)
                    Button {
                        if let url = URL(string: "https://forms.gle/pJVhoyRU8A2ciDhz5"){
                            impact.impactOccurred()
                            openURL(url)
                        }
                    } label: {
                        HStack {
                            Label("Suggest Important Link", systemImage: "link.badge.plus")
                        }
                    }
                    .buttonStyle(.plain)
                }
                ImportantLinksView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        NavigationLink(destination: LinksKeyView()) {
                            Image(systemName: "questionmark")
                        }.onTapGesture {
                            impact.impactOccurred()
                        }
                    }
                }
            }
            .navigationTitle(Text("Links"))
            .modifier(NavSubtitleIfAvailable(subtitle: "Important campus resources"))
        }
    }
}

#Preview {
    LinksView()
}
