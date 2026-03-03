//
//  LinksView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-18.
//

import SwiftUI

struct LinksView: View {
    @State private var viewModel = LinksViewModel()

    var body: some View {
        NavigationStack {
            List {
                if viewModel.isLoading {
                    ProgressView()
                } else if let err = viewModel.error {
                    Group {
                        Text(err.localizedDescription)
                            .foregroundStyle(Color.red)
                        Text("""
                        
                        The Web site you seek
                        cannot be located but
                        endless more exist.
                        """)
                    }.refreshable {
                        await viewModel.forceRefresh()
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }.padding(20)
                } else {
                    ForEach(viewModel.data, id: \.id) { section in
                        NavigationLink(destination: LinksSectionView(links: section)) {
                            HStack {
                                if let objectSymbol = section.header.sfSymbol {
                                    Label(section.header.title, systemImage: objectSymbol)
                                } else {
                                    Text(section.header.title)
                                }
                            }
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchIfNeeded()
            }
            .refreshable {
                await viewModel.forceRefresh()
            }
            .navigationBarTitle("Important Links")
            .modifier(NavSubtitleIfAvailable(subtitle: "Last updated: \(viewModel.lastUpdated?.shortDisplay ?? "(Not yet updated)")"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        NavigationLink(destination: LinksKeyView()) {
                            Image(systemName: "questionmark")
                        }.simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    LinksView()
}
