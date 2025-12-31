//
//  WSOBulletinListView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-30.
//

import SwiftUI
import Logging

struct WSOBulletinListView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    @State private var viewModel = WSOBulletinViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.announcementsPreview) { bulletin in
                        WSOBulletinItemView(
                            post: bulletin,
                            viewModel: WSOUserViewModel(userID: bulletin.userID)
                        )
                    }
                    NavigationLink(destination: WSOBulletinPerListView(type: "announcement")) {
                        Text("View more posts...").italic()
                    }
                } header : {
                    HStack {
                        Text("Announcements")
                            .fontWeight(.semibold)
                            .font(.title3)
                        Spacer()
                        Image(systemName: "book")
                    }
                }
                Section {
                    ForEach(viewModel.exchangePreview) { bulletin in
                        WSOBulletinItemView(
                            post: bulletin,
                            viewModel: WSOUserViewModel(userID: bulletin.userID)
                        )
                    }
                    NavigationLink(destination: WSOBulletinPerListView(type: "exchange")) {
                        Text("View more posts...").italic()
                    }
                } header : {
                    HStack {
                        Text("Exchanges")
                            .fontWeight(.semibold)
                            .font(.title3)
                        Spacer()
                        Image(systemName: "book")
                    }
                }
                Section {
                    ForEach(viewModel.jobsPreview) { bulletin in
                        WSOBulletinItemView(
                            post: bulletin,
                            viewModel: WSOUserViewModel(userID: bulletin.userID)
                        )
                    }
                    NavigationLink(destination: WSOBulletinPerListView(type: "job")) {
                        Text("View more posts...").italic()
                    }
                } header : {
                    HStack {
                        Text("Jobs")
                            .fontWeight(.semibold)
                            .font(.title3)
                        Spacer()
                        Image(systemName: "book")
                    }
                }
                Section {
                    ForEach(viewModel.lostandfoundPreview) { bulletin in
                        WSOBulletinItemView(
                            post: bulletin,
                            viewModel: WSOUserViewModel(userID: bulletin.userID)
                        )
                    }
                    NavigationLink(destination: WSOBulletinPerListView(type: "lostAndFound")) {
                        Text("View more posts...").italic()
                    }
                } header : {
                    HStack {
                        Text("Lost & Found")
                            .fontWeight(.semibold)
                            .font(.title3)
                        Spacer()
                        Image(systemName: "book")
                    }
                }
            }
            .task {
                await viewModel.fetchIfNeeded()
            }
            .refreshable {
                await viewModel.forceRefresh()
            }
            .listStyle(.sidebar)
            .navigationTitle("Bulletins")
            .modifier(NavSubtitleIfAvailable(subtitle: "College discussion lists"))
        }
    }
}

#Preview {
    WSOBulletinListView()
}
