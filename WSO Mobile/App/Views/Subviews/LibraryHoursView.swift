//
//  LibraryHoursView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI
import Combine

struct LibraryHoursView: View {
    @StateObject private var viewModel = LibraryHoursViewModel()

    var body: some View {
        Section {
            if viewModel.isLoading {
                // TODO: make a nicer ProgressView()
                Text("Loading...")
            } else if let error = viewModel.errorMessage {
                    // THIS STATE MEANS BAD. USERS SHOULD NEVER SEE THIS
                Text(error).foregroundStyle(Color.red)
            } else {
                ForEach(viewModel.libraryHours, id: \.name) { place in
                    HStack {
                        Text(place.name)
                        Spacer()
                        Text(place.hours).foregroundStyle(.secondary)
                    }
                }
            }
        } header : {
            HStack {
                Text("Library Hours")
                    .fontWeight(.semibold)
                    .font(.title3)
                Spacer()
                Image(systemName: "book")
            }

        } .task { await viewModel.loadHours() }
    }
}

#Preview {
    HomeView().environmentObject(AppSettings.shared)
}
