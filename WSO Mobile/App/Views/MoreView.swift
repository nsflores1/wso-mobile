//
//  LinksView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-13.
//

import SwiftUI

struct MoreView: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: SettingsView()) {
                        Label("App Settings", systemImage: "gear")
                    }
                    NavigationLink(destination: ImportantPhoneNumView()) {
                        Label("Emergency Numbers", systemImage: "phone")
                    }
                    Button {
                        if let url = URL(string: "https://forms.gle/NqYdAAbZKPQmPq866"){
                            openURL(url)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    } label: {
                        HStack {
                            Label("Send Feedback", systemImage: "paperplane")
                        }
                    }
                    .buttonStyle(.plain)
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Label("Privacy Policy", systemImage: "document")
                    }
                    NavigationLink(destination: SoftwareLicenseView()) {
                        Label("Software License", systemImage: "document")
                    }
                    NavigationLink(destination: LinksView()) {
                        Label("Important Links", systemImage: "link")
                    }
                    Button {
                        if let url = URL(string: "https://forms.gle/pJVhoyRU8A2ciDhz5"){
                            openURL(url)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    } label: {
                        HStack {
                            Label("Suggest Important Link", systemImage: "link.badge.plus")
                        }
                    }
                    .buttonStyle(.plain)
                }
                Section {
                    Text("""
                        You're using WSO Mobile Rewritten, version 1.2.0 (beta build 95)!
                        
                        Please send all feedback to the developers via the "Send Feedback" button.
                        
                        Thank you as always for using the app!
                        """)
                }
            }
            .navigationTitle(Text("More Stuff"))
            .modifier(NavSubtitleIfAvailable(subtitle: "Campus resources & settings"))
        }
    }
}

#Preview {
    MoreView()
}
