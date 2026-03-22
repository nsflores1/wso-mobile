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

struct LinksSectionView: View {
    let links: WSOImportantLinksSections
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            List {
                ForEach (links.links, id: \.id) { link in
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        openURL(URL(string: link.url)!)
                    } label: {
                        if let objectSymbol = link.sfSymbol {
                            Label(link.title, systemImage: objectSymbol)
                        } else {
                            Text(link.title)
                        }
                    }
                }
            }
            .navigationTitle(links.header.shortTitle)
        }
    }
}

struct LinksKeyView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    let introText = """
                    Links is a feature which displays useful links for the Williams College campus community.
                    """
                    Text(introText.replacingOccurrences(of: "\n", with: " "))
                }
                Section {
                    let explanationText = """
                    If you think of something you'd like to add, simply contact WSO by using the form listed on the previous page. New links will be added as soon as we get to them!
                    """
                    Text(explanationText.replacingOccurrences(of: "\n", with: " "))
                    let explanationText2 = """
                        Please note that submission of a link does not guarantee its inclusion. All links will be categorized by WSO. The links are sorted in the order in which they were added, although we reserve the right to change that in the future.
                        """
                    Text(explanationText2.replacingOccurrences(of: "\n", with: " "))
                }

            }
            .navigationTitle("Links Help")
            .modifier(NavSubtitleIfAvailable(subtitle: "For all your Link related needs"))
        }
    }
}

#Preview {
    LinksView()
}
