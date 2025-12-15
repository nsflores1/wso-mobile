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
                if !viewModel.isLoading && viewModel.errorMessage == nil {
                    ForEach(viewModel.libraryHours, id: \.name) { place in
                        HStack {
                            Text(place.name.capitalized)
                            Spacer()
                            Text("\(place.openHours.joined()), \(place.closeHours.joined())")
                                .foregroundStyle(.secondary)
                        }
                    }.transition(.move(edge: .top).combined(with: .opacity))
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

        } .task { await viewModel.loadHours() }
    }
}

#Preview {
    HomeView()
}
