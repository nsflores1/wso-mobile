//
//  DiningView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI

struct DiningView: View {
    var body: some View {
        NavigationStack {
            List {
                Text("a menu item")
                Text("another menu item")

            }

            .navigationTitle(Text("Dining"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    DiningView().environmentObject(AppSettings.shared)
}
