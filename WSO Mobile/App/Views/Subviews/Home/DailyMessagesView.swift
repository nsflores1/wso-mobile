//
//  DailyMessagesView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI
import Logging

struct DailyMessagesView: View {
    @Environment(\.logger) private var logger
    @State var viewModel = DailyMessagesViewModel.shared

    var body: some View {
        Section {
            if viewModel.isLoading {
                HStack {
                    Text("Loading...")
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .transition(.opacity)
            } else if let err = viewModel.error {
                HStack {
                    Text(err.localizedDescription).foregroundStyle(Color.red)
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .transition(.opacity)
            } else if viewModel.dailyMessageCategories.isEmpty {
                Text("(No daily messages today)")
            } else {
                ForEach(viewModel.dailyMessageCategories.keys.sorted(), id: \.self) { category in
                    Section() {
                        ForEach(viewModel.dailyMessageCategories[category] ?? [], id: \.title) { post in
                            DailyMessagesItemView(post: post)
                        }
                    } header: {
                        HStack() {
                            Image(systemName: "square.fill")
                            Text(category).font(.headline)
                                .multilineTextAlignment(.leading)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        } header : {
            HStack {
                VStack(alignment: .leading) {
                    Text("Daily Messages")
                        .fontWeight(.semibold)
                        .font(.title3)
                    Text("Last updated: \(viewModel.lastUpdated?.shortDisplay ?? "(Not yet updated)")")
                        .fontWeight(.regular)
                        .font(.subheadline)
                }
                Spacer()
                Image(systemName: "envelope.stack")
            }
        } .task {
            logger.trace("Fetching daily messages...")
            await viewModel.fetchIfNeeded()
            logger.trace("Fetch complete")
        }
    }
}

#Preview {
    HomeView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
