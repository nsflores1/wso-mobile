//
//  LibraryHoursView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI

struct LibraryHoursView: View {
    @State var viewModel = LibraryHoursViewModel()

    var body: some View {
        Section {
            VStack {
                if viewModel.isLoading {
                    Text("Loading...")
                        .transition(.opacity)
                }
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .transition(.opacity)
                }
                if !viewModel.isLoading && viewModel.errorMessage == nil && viewModel.libraryHours.count > 0 {
                    ForEach(viewModel.libraryHours, id: \.name) { place in
                        HStack {
                            Text(place.name)
                            Spacer()
                            Text(place.hours).foregroundStyle(.secondary)
                        }
                    }.transition(.move(edge: .top).combined(with: .opacity))
                } else {
                    Text("(Library hours not posted for today)")
                        .italic()
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.isLoading)
        } header : {
            HStack {
                Text("Library Hours")
                    .fontWeight(.semibold)
                    .font(.title3)
                Spacer()
                Image(systemName: "book")
            }

        } .task { await viewModel.fetchIfNeeded() }
    }
}

#Preview {
    HomeView()
}
