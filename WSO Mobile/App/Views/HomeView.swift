//
//  HomeView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {

            List {
                Section {
                    Text("search goes here")
                }
                LibraryHoursView()
                DailyMessagesView()
            }
            .listStyle(.grouped)
            .navigationTitle(Text("WSO Mobile"))
            .navigationBarTitleDisplayMode(.large)

        }
    }
}

#Preview {
    HomeView().environmentObject(AppSettings.shared)
}
