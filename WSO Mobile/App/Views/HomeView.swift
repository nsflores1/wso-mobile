//
//  HomeView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI
import Logging

struct HomeView: View {
    @Environment(\.logger) private var logger
    @State private var libraryViewModel = LibraryHoursViewModel()
    @State private var dailyMessagesViewModel = DailyMessagesViewModel()
    @Environment(AuthManager.self) private var authManager

    // variables for the home screen search box
    @State private var searchText: String = ""
    @State var users: [User] = []
    @State var userCount: Int = 0
    @FocusState private var isFocused
    // task handle
    @State private var searchTask: Task<Void, Never>?

    @AppStorage("userType") private var userType: UserType = .student

    var body: some View {
        NavigationStack {
            List {
                if userType == .student && authManager.isAuthenticated {
                    Section {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search for users...", text: $searchText)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .onChange(of: searchText) { _, newValue in
                                    searchTask?.cancel()
                                    searchTask = Task {
                                        try? await Task.sleep(for: .milliseconds(300))
                                        guard !Task.isCancelled else { return }
                                            // an empty result will always fail so don't do it
                                        if !searchText.isEmpty {
                                            do {
                                                let data = try await WSOFacebookSearch(query: newValue)
                                                userCount = data.paginationTotal
                                                users = data.data
                                            } catch {
                                                logger.error("Failed to update search results: \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                }
                                .focused($isFocused)
                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                    isFocused = false
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            if isFocused {
                                Button {
                                    isFocused = false
                                } label: {
                                    Image(systemName: "keyboard.chevron.compact.down")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                } else if userType == .student && !authManager.isAuthenticated {
                    NavigationLink {
                        AuthGate {
                            ProfileView()
                        }
                    } label: {
                        Text("Login to use WSO features...")
                            .italic()
                    }
                } else {
                    Text("App is in nonstudent mode").italic()
                }
                if searchText.isEmpty {
                    if userType == .student && authManager.isAuthenticated {
                        HomeButtonsView()
                    }
                    LibraryHoursView()
                    BookingLinkView()
                    DailyMessagesView()
                } else {
                    ForEach(users) { user in
                        HomeCardView(user: user)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.25), value: searchText.isEmpty)
            .animation(.easeInOut(duration: 0.2), value: users.count)
            .task {
                logger.trace("Fetching library data")
                await libraryViewModel.fetchIfNeeded()
                logger.trace("Fetch complete")
                logger.trace("Fetching daily messages data")
                await dailyMessagesViewModel.fetchIfNeeded()
                logger.trace("Fetch complete")
            }
            .refreshable {
                logger.trace("Library hours data is being forcibly refreshed...")
                await libraryViewModel.forceRefresh()
                logger.trace("Library hours data forcibly refreshed")
                logger.trace("Daily messages data is being forcibly refreshed...")
                await dailyMessagesViewModel.forceRefresh()
                logger.trace("Daily messages data forcibly refreshed")
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
            HStack { } // hidden hstack wraps the text
            .listStyle(.grouped)
            .navigationTitle(Text("WSO Mobile"))
            .modifier(NavSubtitleIfAvailable(subtitle: searchText.isEmpty ? "For students, by students!" : "Total results: \(userCount)"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        if #available(iOS 26.0, *) {
                            NavigationLink(destination: MapPageView()) {
                                Image(systemName: "map")
                            }.simultaneousGesture(TapGesture().onEnded {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            })
                        }
                        if userType == .student {
                            NavigationLink(destination: {
                                AuthGate {
                                    ProfileView()
                                }
                            }) {
                                Image(systemName: "person")
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            })
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        NavigationLink(destination: AboutView()) {
                            Image(systemName: "questionmark")
                        }.simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
