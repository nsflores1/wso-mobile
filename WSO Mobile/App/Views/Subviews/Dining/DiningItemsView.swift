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
    let items: [FoodItem]

    var body: some View {
        ForEach(items.sorted(), id: \.name) { item in
            HStack {
                Text(item.name)
                // TODO: add halal (need to scrape it)
                if (item.isVegetarian) {
                    Image(systemName: "leaf")
                        .foregroundStyle(Color.green)
                }
                if (item.isVegan) {
                    Image(systemName: "v.circle")
                        .foregroundStyle(Color.green)
                }
                if (item.isGlutenFree) {
                    Image(systemName: "g.circle")
                }
            }
        }
    }
}

#Preview {
    DiningView()
}
