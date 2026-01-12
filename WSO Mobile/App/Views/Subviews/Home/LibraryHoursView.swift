//
//  LibraryHoursView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI
import Logging

struct LibraryHoursView: View {
    @Environment(\.logger) private var logger
    @State private var viewModel = LibraryHoursViewModel()

    var body: some View {
        Section {
            Group {
                if viewModel.isLoading {
                    Text("Loading...")
                        .transition(.opacity)
                } else if let err = viewModel.error {
                    Text(err.localizedDescription)
                        .foregroundStyle(.red)
                        .transition(.opacity)
                } else {
                    ForEach(viewModel.libraryHours) { place in
                        HStack {
                            Text(place.name)
                            HStack {
                                HStack {
                                        // only render hours if there's anything to show in the first place
                                    if !place.open.isEmpty && !place.close.isEmpty {
                                        if !place.open.isEmpty {
                                            Text(place.open.joined(separator: ", "))
                                                .foregroundStyle(.secondary)
                                        } else {
                                            Text("N/A")
                                                .foregroundStyle(.secondary)
                                        }
                                        Text("-").foregroundStyle(.secondary)
                                        if !place.close.isEmpty {
                                            Text(place.close.joined(separator: ", "))
                                                .foregroundStyle(.secondary)
                                        } else {
                                            Text("N/A")
                                                .foregroundStyle(.secondary)
                                        }
                                    } else {
                                        Text("(No hours today)")
                                            .foregroundStyle(.secondary)
                                    }
                                }.padding(.horizontal, 5)
                            }
                        }.transition(.move(edge: .top).combined(with: .opacity))
                    }
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
        }.task {
            logger.trace("Fetching library data...")
            await viewModel.fetchIfNeeded()
            logger.trace("Fetch complete")

        }
    }
}

#Preview {
    HomeView()
}
