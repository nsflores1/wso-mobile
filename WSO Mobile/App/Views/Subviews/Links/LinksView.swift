//
//  LinksView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-18.
//

    // TODO: update this from a web JSON rather than being manual
    // TODO: also ask different campus orgs what they'd like in the app
    // Orgs who are interested:
    // - check your messages with jack allen (he has a bunch)
    // - woc board
    // - the record
    // - wso (duh)
    // - ephelia's roots
    // - alexander hamilton society (check thianna dms)
    // - black student union
    // - williams colleeg jewish association
    // TODO: people want to hide sections they don't want to see.
    // TODO: you need to have a way to hide these if people don't want to see them, and have the app remember that

import SwiftUI

struct LinksView: View {
    @State private var viewModel = LinksViewModel()

    var body: some View {
        NavigationStack {
            List {
                if viewModel.isLoading {
                    ProgressView()
                } else if let err = viewModel.error {
                    Text(err.localizedDescription).foregroundStyle(Color.red)
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
