//
//  DiningKeyView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-14.
//

import SwiftUI

struct DiningKeyView: View {
    var body: some View {
        NavigationStack {
            List {
                let explanation = """
                    This page is a short explanation on how to read the dining menus.
                    
                    Dining menus contain important symbols which describe the food type:
                    """
                Text(explanation)
                Section {
                    HStack {
                        Image(systemName: "leaf")
                            .foregroundStyle(Color(.green))
                        Text("Vegetarian items")
                    }
                    HStack {
                        Image(systemName: "v.circle")
                            .foregroundStyle(Color(.green))
                        Text("Vegan items")
                    }
                    HStack {
                        Image(systemName: "g.circle")
                        Text("Gluten free items")
                    }
                }
            }
            .navigationTitle("Dining Help")
            .modifier(NavSubtitleIfAvailable(subtitle: "For all your dining questions"))
        }
    }
}

#Preview {
    DiningKeyView()
}
