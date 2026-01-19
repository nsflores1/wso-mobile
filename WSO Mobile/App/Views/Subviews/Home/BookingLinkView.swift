//
//  BookingLinkView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-18.
//

import SwiftUI
import Logging

struct BookingLinkView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL

    var body: some View {
        Section {
            VStack {
                Link(destination: URL(string: "https://libcal.williams.edu/")!) {
                    HStack {
                        Image(systemName: "books.vertical")
                        Text("Library Study Rooms")
                    }
                }
            }
            VStack {
                Link(destination: URL(string: "https://williams.emscloudservice.com/web/Default.aspx")!) {
                    HStack {
                        Image(systemName: "globe.desk")
                        Text("EMS Room Scheduler")
                    }
                }
            }
            VStack {
                Link(destination: URL(string: "https://music.williams.edu/room-schedules/")!) {
                    // these icons are left out in iOS 18
                    if #unavailable(iOS 26) {
                        HStack {
                            Image(systemName: "music.note")
                            Text("Music Hall Booking")
                        }
                    } else {
                        HStack {
                            Image(systemName: "music.pages")
                            Text("Music Hall Booking")
                        }
                    }
                }
            }
        } header : {
            HStack {
                Text("Room Reservations")
                    .fontWeight(.semibold)
                    .font(.title3)
                Spacer()
                // these icons are left out in iOS 18
                if #unavailable(iOS 26) {
                    Image(systemName: "calendar")
                } else {
                    Image(systemName: "ellipsis.calendar")
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
