//
//  LinksSectionView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-18.
//

import SwiftUI

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
