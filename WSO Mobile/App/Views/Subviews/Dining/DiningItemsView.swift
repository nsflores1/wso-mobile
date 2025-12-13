//
//  DiningItemsView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-20.
//

import SwiftUI
import Foundation
import Combine

struct DiningItemsView: View {
    let items: [MenuItem]

    var body: some View {
        ForEach(items, id: \.name) { item in
            HStack {
                Text(item.name)
                // TODO: add halal (need to scrape it)
                if (item.vegetarian) {
                    Image(systemName: "leaf")
                        .foregroundStyle(Color.green)
                }
                if (item.vegan) {
                    Image(systemName: "v.circle")
                        .foregroundStyle(Color.green)
                }
                if (item.glutenFree) {
                    Image(systemName: "g.circle")
                }
            }
        }
    }
}

#Preview {
    DiningView()
}
