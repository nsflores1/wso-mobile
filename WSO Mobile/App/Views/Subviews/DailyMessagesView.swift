//
//  DailyMessagesView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI
import Combine

struct DailyMessagesView: View {
    @ObservedObject var viewModel = DailyMessagesViewModel()
    
    var body: some View {
        Section {
            if viewModel.isLoading {
                HStack {
                    Text("Loading...")
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .transition(.opacity)
            } else if let error = viewModel.errorMessage {
                    // THIS STATE MEANS BAD. USERS SHOULD NEVER SEE THIS
                HStack {
                    Text(error).foregroundStyle(Color.red)
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .transition(.opacity)
            } else {
                // TODO: this can't be animated until you flatten this into something less painful
                // maybe make it a simple flat array?
                ForEach(viewModel.dailyMessageCategories.keys.sorted(), id: \.self) { category in
                    Section() {
                        ForEach(viewModel.dailyMessageCategories[category] ?? [], id: \.title) { post in
                            DisclosureGroup {
                                VStack {
                                    Text(post.content)
                                        .font(.subheadline)
                                        .foregroundStyle(Color.secondary)
                                        .multilineTextAlignment(.leading)
                                }
                            } label: {
                                VStack() {
                                    Text(post.title)
                                        .multilineTextAlignment(.leading)
                                } .swipeActions(edge: .trailing) {
                                    // TODO: test this with working daily messages
                                    ShareLink(item: post.url) {
                                        Label("Share", systemImage: "square.and.arrow.up")
                                    }
                                    .tint(.blue)
                                    // the .frame() trick is Dark Arts
                                }.frame(maxWidth: .infinity, alignment: .leading)
                            }
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
                Text("Daily Messages")
                    .fontWeight(.semibold)
                    .font(.title3)
                Spacer()
                Image(systemName: "list.bullet.clipboard")
            }
        } .task { await viewModel.fetchIfNeeded() }
    }
}

#Preview {
    HomeView()
}
