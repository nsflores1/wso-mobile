//
//  WSOFacTrakOverviewView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-02-04.
//

// this View is the one that users intially see when they click on FacTrak,
// and is paired with the ViewModel of the same name.

import SwiftUI
import Logging

struct WSOFacTrakOverviewView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    // variables for the search box
    @State private var searchText: String = ""
    @State var items: [WSOFacTrakSearch] = []
    @State var itemCount: Int = 0
    @FocusState private var isFocused
    // task handle
    @State private var searchTask: Task<Void, Never>?

    @State private var viewModel = WSOFacTrakOverviewViewModel()

    var body: some View {
        NavigationStack {
            if let err = viewModel.error {
                Group {
                    Text(err.localizedDescription).foregroundStyle(Color.red)
                        .navigationTitle("FacTrak")
                }
            } else {
                List {
                    Section {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search for profs and courses...", text: $searchText)
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
                                                let data = try await WSOFacTrakSearch(query: newValue)
                                                itemCount = data.count
                                                items = data
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
                    if searchText.isEmpty {
                        Section {
                            ForEach(viewModel.data) { department in
                                WSOFacTrakCardView(department: department)
                            }
                        }
                    } else {
                        ForEach(items) { item in
                            WSOFacTrakSearchView(item: item)
                        }
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: searchText.isEmpty)
        .animation(.easeInOut(duration: 0.2), value: items.count)
        .task {
            await viewModel.fetchIfNeeded()
        }
        .refreshable {
            await viewModel.forceRefresh()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    NavigationLink(destination: WSOFacTrakAreaKeyView()) {
                        Image(systemName: "questionmark")
                    }.simultaneousGesture(TapGesture().onEnded {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    })
                }
            }
        }
        .navigationTitle("FacTrak")
        .listStyle(.sidebar)
        .modifier(NavSubtitleIfAvailable(subtitle: "Click a department to see more"))
    }
}
