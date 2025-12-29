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
    @State private var searchText: String = ""

    // these warnings are for the user because they aren't done yet
    @State private var facTrakWarn = false
    @State private var dormTrakWarn = false
    @State private var bookTrakWarn = false

    @AppStorage("userType") private var userType: UserType = .student

    var body: some View {
        NavigationStack {
            List {
                if userType == .student {
                    Section {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                // TODO: make this do something
                                // TODO: hide this based on auth state
                            TextField("Search for users...", text: $searchText)
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
                } else {
                    Text("App is in nonstudent mode").italic()
                }
                // TODO: this does NOTHING, still need to implement
                if userType == .student {
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
                            Text("Rate professors & courses")
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
                            Text("Rate on-campus dorms")
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
                            Text("Buy and sell textbooks")
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
                }
                LibraryHoursView()
                DailyMessagesView()
            }
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
            .modifier(NavSubtitleIfAvailable(subtitle: userType == .student ? "For students, by students!" : "The official app of WSO!"))
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
                        if userType == .student {
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
