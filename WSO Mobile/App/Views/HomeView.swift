//
//  HomeView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var libraryViewModel = LibraryHoursViewModel()
    @StateObject private var dailyMessagesViewModel = DailyMessagesViewModel()
    @State private var searchText: String = ""

    // these warnings are for the user when they're not logged in
    @State private var facTrakWarn = false
    @State private var dormTrakWarn = false
    @State private var bookTrakWarn = false
    @State private var facebookWarn = false


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
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 8),
                        GridItem(.flexible(), spacing: 8)
                    ], spacing: 12) {
                            Button {
                                facTrakWarn = true
                            } label: {
                                Label("FacTrak", systemImage: "graduationcap")
                                    .foregroundStyle(.white, .accent)
                            }.buttonStyle(.borderedProminent)
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
                            Button{
                                facebookWarn = true
                            } label: {
                                Label("Facebook", systemImage: "person")
                                    .foregroundStyle(.white, .accent)
                            }.buttonStyle(.borderedProminent)
                                .controlSize(ControlSize.large)
                                .alert(
                                    """
                                    This feature hasn't been implemented yet!
                                    Please check back soon.
                                    """,
                                    isPresented: $facebookWarn
                                ) {
                                    Button("OK", role: .cancel) { }
                                }
                            Button{
                                dormTrakWarn = true
                            } label: {
                                Label("DormTrak", systemImage: "house")
                                    .foregroundStyle(.white, .accent)
                            }.buttonStyle(.borderedProminent)
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
                            Button {
                                bookTrakWarn = true
                            } label: {
                                Label("BookTrak", systemImage: "book.closed")
                                    .foregroundStyle(.white, .accent)
                            }.buttonStyle(.borderedProminent)
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
            }.refreshable {
                URLCache.shared
                    .removeCachedResponse(
                        for: URLRequest(url: libraryViewModel.requestURL)
                    )
                URLCache.shared
                    .removeCachedResponse(
                        for: URLRequest(url: dailyMessagesViewModel.requestURL)
                    )
                print("Refreshed!")
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
                            }
                        }
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person")
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        NavigationLink(destination: AboutView()) {
                            Image(systemName: "wand.and.rays")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
