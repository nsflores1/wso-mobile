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

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Login to view search...").italic(true)
                }
                // TODO: this does NOTHING, still need to implement
                Section {
                    HStack {
                        VStack {
                            Button(action: signIn) {
                                Label("FacTrak", systemImage: "graduationcap")
                                    .foregroundStyle(.white, .accent)
                            }.buttonStyle(.borderedProminent)
                                .controlSize(ControlSize.large)
                            Spacer()
                            Button(action: signIn) {
                                Label("Facebook", systemImage: "person")
                                    .foregroundStyle(.white, .accent)
                            }.buttonStyle(.borderedProminent)
                                .controlSize(ControlSize.large)
                        }
                        VStack {
                            Button(action: signIn) {
                                Label("DormTrak", systemImage: "house")
                                    .foregroundStyle(.white, .accent)
                            }.buttonStyle(.borderedProminent)
                                .controlSize(ControlSize.large)
                            Spacer()
                            Button(action: signIn) {
                                Label("BookTrak", systemImage: "book.closed")
                                    .foregroundStyle(.white, .accent)
                            }.buttonStyle(.borderedProminent)
                                .controlSize(ControlSize.large)
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
            .navigationSubtitle(Text("For students, by students!"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                            // TODO: add profile/login page view
                    } label: {
                        Image(systemName: "person")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: AboutView()) {
                        Image(systemName: "wand.and.rays")
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
