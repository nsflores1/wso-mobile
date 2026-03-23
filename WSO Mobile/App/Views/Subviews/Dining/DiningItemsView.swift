//
//  DiningItemsView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-20.
//

import SwiftUI
import Foundation

struct DiningItemsView: View {
    let items: [FoodItem]

    var body: some View {
        if items.isEmpty {
            Text("(No items in course)").italic()
        } else {
            ForEach(items.sorted(), id: \.name) { item in
                HStack {
                    Text(item.name)
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
}

#Preview {
    DiningView()
}
