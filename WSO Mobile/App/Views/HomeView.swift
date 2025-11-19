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
                    Text("Login to view search...").italic(true)
                }
                // TODO: this does NOTHING, still need to implement
                Section {
                    HStack {
                        VStack {
                            Button(action: signIn) {
                                Label("FacTrak", systemImage: "graduationcap")
                                    .foregroundStyle(.white, .accent)
                            }.buttonStyle(.borderedProminent)
                                .controlSize(ControlSize.large)
                            Spacer()
                            Button(action: signIn) {
                                Label("Facebook", systemImage: "person")
                                    .foregroundStyle(.white, .accent)
                            }.buttonStyle(.borderedProminent)
                                .controlSize(ControlSize.large)
                        }
                        VStack {
                            Button(action: signIn) {
                                Label("DormTrak", systemImage: "house")
                                    .foregroundStyle(.white, .accent)
                            }.buttonStyle(.borderedProminent)
                                .controlSize(ControlSize.large)
                            Spacer()
                            Button(action: signIn) {
                                Label("BookTrak", systemImage: "book.closed")
                                    .foregroundStyle(.white, .accent)
                            }.buttonStyle(.borderedProminent)
                                .controlSize(ControlSize.large)
                        }
                    }
                } header: {
                    HStack {
                        Text("WSO Features")
                            .fontWeight(.semibold)
                            .font(.title3)
                        Spacer()
                        Image(systemName: "server.rack")
                    }
                }
                LibraryHoursView()
                DailyMessagesView()
            }
            HStack { } // hidden hstack wraps the text
            .listStyle(.grouped)
            .navigationTitle(Text("WSO Mobile"))
            .navigationSubtitle(Text("For the students, by the students!"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    HomeView().environmentObject(AppSettings.shared)
}
