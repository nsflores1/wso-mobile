//
//  HomeView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI

struct HomeView: View {
    @State private var libraryViewModel = LibraryHoursViewModel()
    @State private var dailyMessagesViewModel = DailyMessagesViewModel()
    @Environment(AuthManager.self) private var authManager
    @State private var searchText: String = ""

    // these warnings are for the user when they're not logged in
    @State private var facTrakWarn = false
    @State private var dormTrakWarn = false
    @State private var bookTrakWarn = false

    // impact used for all haptic actions

    // TODO: this can jump around when scrolling
    // To fix this, find some way to make a skeleton that you fill in,
    // or just don't show the page until it's done loading

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        // TODO: make this do something
                        // TODO: hide this based on auth state
                        TextField("Search users...", text: $searchText)
                            .textInputAutocapitalization(.never)
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                                // TODO: clear search model if pressed
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                // TODO: this does NOTHING, still need to implement
                Section {
                    HStack {
                        Button {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            facTrakWarn = true
                        } label: {
                            Label("FacTrak", systemImage: "graduationcap")

                        }.buttonStyle(.borderless)
                            .controlSize(ControlSize.large)
                            .alert(
                                    """
                                    This feature hasn't been implemented yet!
                                    Please check back soon.
                                    """,
                                    isPresented: $facTrakWarn
                            ) {
                                Button("OK", role: .cancel) { }
                        }
                        Spacer()
                        Text("Sell and buy textbooks")
                            .foregroundStyle(Color(.secondaryLabel)).italic(true)
                    }
                    HStack {
                        Button{
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            dormTrakWarn = true
                        } label: {
                            Label("DormTrak", systemImage: "house")

                        }.buttonStyle(.borderless)
                            .controlSize(ControlSize.large)
                            .alert(
                                    """
                                    This feature hasn't been implemented yet!
                                    Please check back soon.
                                    """,
                                    isPresented: $dormTrakWarn
                            ) {
                                Button("OK", role: .cancel) { }
                        }
                        Spacer()
                        Text("Rate on campus dorms")
                            .foregroundStyle(Color(.secondaryLabel)).italic(true)
                    }
                    HStack {
                        Button {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            bookTrakWarn = true
                        } label: {
                            Label("BookTrak", systemImage: "book.closed")
                        }.buttonStyle(.borderless)
                            .controlSize(ControlSize.large)
                            .alert(
                                    """
                                    This feature hasn't been implemented yet!
                                    Please check back soon.
                                    """,
                                    isPresented: $bookTrakWarn
                            ) {
                                Button("OK", role: .cancel) { }
                        }
                        Spacer()
                        Text("Sell and buy textbooks")
                            .foregroundStyle(Color(.secondaryLabel)).italic(true)
                    }
                } header: {
                    HStack {
                        Text("WSO Features")
                            .fontWeight(.semibold)
                            .font(.title3)
                        Spacer()
                        Image(systemName: "server.rack")
                    }
                }
                LibraryHoursView()
                DailyMessagesView()
            }
            .task {
                await libraryViewModel.fetchIfNeeded()
                await dailyMessagesViewModel.fetchIfNeeded()
            }
            .refreshable {
                await libraryViewModel.forceRefresh()
                await dailyMessagesViewModel.forceRefresh()
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
            HStack { } // hidden hstack wraps the text
            .listStyle(.grouped)
            .navigationTitle(Text("WSO Mobile"))
            .modifier(NavSubtitleIfAvailable(subtitle: "For students, by students!"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // TODO: replace with WSOLoginView() later,
                    // this is to placate Apple reviewers
                    HStack {
                        if #available(iOS 26.0, *) {
                            NavigationLink(destination: MapPageView()) {
                                Image(systemName: "map")
                            }.simultaneousGesture(TapGesture().onEnded {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            })
                        }
                        NavigationLink(destination: {
                            if authManager.isAuthenticated {
                                ProfileView()
                            } else {
                                WSOLoginView()
                            }
                        }) {
                            Image(systemName: "person")
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        })
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
                ToolbarItem(placement: .keyboard) {
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
