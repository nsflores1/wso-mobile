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
                    NavigationLink(
                        destination: WSOBulletinPerListView(
                            type: "announcement",
                            prettyString: "Announcements"
                        )
                    ) {
                        Text("View more posts...").italic()
                    }
                } header : {
                    HStack {
                        Text("Announcements")
                            .fontWeight(.semibold)
                            .font(.title3)
                        Spacer()
                        Image(systemName: "megaphone")
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: viewModel.announcementsPreview.count)
                Section {
                    ForEach(viewModel.exchangePreview) { bulletin in
                        WSOBulletinItemView(
                            post: bulletin,
                            viewModel: WSOUserViewModel(userID: bulletin.userID)
                        )
                    }
                    NavigationLink(
                        destination: WSOBulletinPerListView(
                            type: "exchange",
                            prettyString: "Exchanges"
                        )
                    ) {
                        Text("View more posts...").italic()
                    }
                } header : {
                    HStack {
                        Text("Exchanges")
                            .fontWeight(.semibold)
                            .font(.title3)
                        Spacer()
                        Image(systemName: "gift")
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: viewModel.exchangePreview.count)
                Section {
                    ForEach(viewModel.jobsPreview) { bulletin in
                        WSOBulletinItemView(
                            post: bulletin,
                            viewModel: WSOUserViewModel(userID: bulletin.userID)
                        )
                    }
                    NavigationLink(
                        destination: WSOBulletinPerListView(
                            type: "job",
                            prettyString: "Jobs"
                        )
                    ) {
                        Text("View more posts...").italic()
                    }
                } header : {
                    HStack {
                        Text("Jobs")
                            .fontWeight(.semibold)
                            .font(.title3)
                        Spacer()
                        Image(systemName: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: viewModel.jobsPreview.count)
                Section {
                    ForEach(viewModel.lostandfoundPreview) { bulletin in
                        WSOBulletinItemView(
                            post: bulletin,
                            viewModel: WSOUserViewModel(userID: bulletin.userID)
                        )
                    }
                    NavigationLink(
                        destination: WSOBulletinPerListView(
                            type: "lostAndFound",
                            prettyString: "Lost & Found"
                        )
                    ) {
                        Text("View more posts...").italic()
                    }
                } header : {
                    HStack {
                        Text("Lost & Found")
                            .fontWeight(.semibold)
                            .font(.title3)
                        Spacer()
                        Image(systemName: "suitcase")
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: viewModel.lostandfoundPreview.count)
            }
            .task {
                await viewModel.fetchIfNeeded()
            }
            .refreshable {
                await viewModel.forceRefresh()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        NavigationLink(destination: WSOBulletinKeyView()) {
                            Image(systemName: "questionmark")
                        }.simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        })
                    }
                }
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
