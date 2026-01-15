//
//  WSORidesView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-15.
//

import SwiftUI

struct WSORidesView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    @State private var viewModel = WSORidesViewModel()

    var body: some View {
        NavigationStack {
            if let err = viewModel.error {
                Group {
                    Text(err.localizedDescription).foregroundStyle(Color.red)
                        .navigationTitle("Rides")
                }
            } else {
                List {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        ForEach(viewModel.data) { item in
                            WSORidesItemView(
                                post: item,
                                viewModel: WSOUserViewModel(userID: item.userID)
                            )
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: viewModel.data.count)
            }
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
        .navigationTitle("Rides")
        .listStyle(.sidebar)
        .modifier(NavSubtitleIfAvailable(subtitle: "College ridesharing"))
    }
}
