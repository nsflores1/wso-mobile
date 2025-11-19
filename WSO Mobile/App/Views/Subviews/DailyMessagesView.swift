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
                    // TODO: make a nicer ProgressView()
                Text("Loading...")
            } else if let error = viewModel.errorMessage {
                    // THIS STATE MEANS BAD. USERS SHOULD NEVER SEE THIS
                Text(error).foregroundStyle(Color.red)
            } else {
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
                                    // the .frame() trick is Dark Arts
                                    Text(post.title)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    HStack() {
                                        Image(systemName: "person")
                                        Text("\(post.author) (\(post.authorEmail))").italic()
                                            .multilineTextAlignment(.leading)
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                }
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
        } .task { await viewModel.loadContent() }
    }
    // Important note: clearly you need to attach the task
    // to a consistent and stable view. Group {} is not one of them.
}

#Preview {
    HomeView().environmentObject(AppSettings.shared)
}
