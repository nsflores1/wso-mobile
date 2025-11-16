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
                Text("Content will go here soon")
            }
        } header : {
            Text("Daily Messages")
                .fontWeight(.semibold)
                .font(.title3)
        } .task { await viewModel.loadContent() }
    }
    // Important note: clearly you need to attach the task
    // to a consistent and stable view. Group {} is not one of them.
}

#Preview {
    HomeView().environmentObject(AppSettings.shared)
}
