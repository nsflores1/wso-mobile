//
//  HomeButtonsView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-29.
//

import SwiftUI
import Logging

struct HomeButtonsView: View {
    @Environment(\.logger) private var logger
    @State private var libraryViewModel = LibraryHoursViewModel()
    @State private var dailyMessagesViewModel = DailyMessagesViewModel()
    @Environment(AuthManager.self) private var authManager

    // these warnings are for the user because they aren't done yet
    @State private var facTrakWarn = false
    @State private var dormTrakWarn = false
    @State private var bookTrakWarn = false

    var body: some View {
        Section {
            HStack {
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    bookTrakWarn = true
                } label: {
                    Label("Bulletins", systemImage: "megaphone")
                }.buttonStyle(.borderless)
                    .controlSize(ControlSize.large)
                    .alert(
                                    """
                                    This feature hasn't been implemented yet!
                                    Please check back soon.
                                    """,
                                    isPresented: $bookTrakWarn
                    ) {
                        Button("OK", role: .cancel) { }
                    }
                Spacer()
                Text("Post campus messages")
                    .foregroundStyle(Color(.secondaryLabel)).italic(true)
            }
            HStack {
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    facTrakWarn = true
                } label: {
                    Label("FacTrak", systemImage: "graduationcap")

                }.buttonStyle(.borderless)
                    .controlSize(ControlSize.large)
                    .alert(
                                    """
                                    This feature hasn't been implemented yet!
                                    Please check back soon.
                                    """,
                                    isPresented: $facTrakWarn
                    ) {
                        Button("OK", role: .cancel) { }
                    }
                Spacer()
                Text("Rate professors & courses")
                    .foregroundStyle(Color(.secondaryLabel)).italic(true)
            }
            HStack {
                Button{
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    dormTrakWarn = true
                } label: {
                    Label("DormTrak", systemImage: "house")

                }.buttonStyle(.borderless)
                    .controlSize(ControlSize.large)
                    .alert(
                                    """
                                    This feature hasn't been implemented yet!
                                    Please check back soon.
                                    """,
                                    isPresented: $dormTrakWarn
                    ) {
                        Button("OK", role: .cancel) { }
                    }
                Spacer()
                Text("Rate on-campus dorms")
                    .foregroundStyle(Color(.secondaryLabel)).italic(true)
            }
            HStack {
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    bookTrakWarn = true
                } label: {
                    Label("BookTrak", systemImage: "book.closed")
                }.buttonStyle(.borderless)
                    .controlSize(ControlSize.large)
                    .alert(
                                    """
                                    This feature hasn't been implemented yet!
                                    Please check back soon.
                                    """,
                                    isPresented: $bookTrakWarn
                    ) {
                        Button("OK", role: .cancel) { }
                    }
                Spacer()
                Text("Buy and sell textbooks")
                    .foregroundStyle(Color(.secondaryLabel)).italic(true)
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
    }
}

#Preview {
    HomeView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
