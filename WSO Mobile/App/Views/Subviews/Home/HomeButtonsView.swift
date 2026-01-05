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

    // this warning is for the user because they aren't done yet
    @State private var notImplementedWarn = false

    var body: some View {
        Section {
            HStack {
                NavigationLink(destination: AuthGate { WSOBulletinListView() }) {
                    Label("Bulletins", systemImage: "megaphone")
                        .foregroundStyle(Color.accent)
                    Spacer()
                    Text("Post campus messages")
                        .foregroundStyle(Color(.secondaryLabel)).italic(true)
                }
            }
            HStack {
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    notImplementedWarn = true
                } label: {
                    Label("Discussions", systemImage: "message")

                }.buttonStyle(.borderless)
                    .controlSize(ControlSize.large)
                    .alert(
                                    """
                                    This feature hasn't been implemented yet!
                                    Please check back soon.
                                    """,
                                    isPresented: $notImplementedWarn
                    ) {
                        Button("OK", role: .cancel) { }
                    }
                Spacer()
                Text("Chat about topics")
                    .foregroundStyle(Color(.secondaryLabel)).italic(true)
            }
            HStack {
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    notImplementedWarn = true
                } label: {
                    Label("Rides", systemImage: "car.side")

                }.buttonStyle(.borderless)
                    .controlSize(ControlSize.large)
                    .alert(
                                    """
                                    This feature hasn't been implemented yet!
                                    Please check back soon.
                                    """,
                                    isPresented: $notImplementedWarn
                    ) {
                        Button("OK", role: .cancel) { }
                    }
                Spacer()
                Text("Carpool with peers")
                    .foregroundStyle(Color(.secondaryLabel)).italic(true)
            }
            HStack {
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    notImplementedWarn = true
                } label: {
                    Label("FacTrak", systemImage: "graduationcap")

                }.buttonStyle(.borderless)
                    .controlSize(ControlSize.large)
                    .alert(
                                    """
                                    This feature hasn't been implemented yet!
                                    Please check back soon.
                                    """,
                                    isPresented: $notImplementedWarn
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
                    notImplementedWarn = true
                } label: {
                    Label("DormTrak", systemImage: "house")

                }.buttonStyle(.borderless)
                    .controlSize(ControlSize.large)
                    .alert(
                                    """
                                    This feature hasn't been implemented yet!
                                    Please check back soon.
                                    """,
                                    isPresented: $notImplementedWarn
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
                    notImplementedWarn = true
                } label: {
                    Label("BookTrak", systemImage: "book.closed")
                }.buttonStyle(.borderless)
                    .controlSize(ControlSize.large)
                    .alert(
                                    """
                                    This feature hasn't been implemented yet!
                                    Please check back soon.
                                    """,
                                    isPresented: $notImplementedWarn
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
