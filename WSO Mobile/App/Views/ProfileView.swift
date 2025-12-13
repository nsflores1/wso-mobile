//
//  ProfileView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI
import FluidGradient
import System

struct ProfileView: View {
    @Environment(\.openURL) private var openURL
    @StateObject private var notificationManager = NotificationManager.shared

    var body: some View {
        NavigationStack {
            List {
                Section {
                    // TODO: this is pure mockup, you need to make this real later
                    VStack {
                        Image("EpheliaPicture")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .frame(width: 200, height: 200)
                        HStack {
                            Text("Ephelia Ephelia").bold()
                            Text("(Student, Class of '27)").italic()
                        }
                    }.frame(maxWidth: .infinity, alignment: .center)
                    VStack(alignment: .leading) {
                        Section {
                            Text("Unix: ").bold() + Text("eph1").italic() + Text("@williams.edu")
                            Text("Tags: ").bold() + Text("WARP, WSO")
                            Text("SU Box: ").bold() + Text("666 Paresky")
                            Text("Hometown: ").bold() + Text("Williamstown, MA")
                            Text("Pronouns: ").bold() + Text(" she/her/hers")
                        }
                    }
                } header : {
                    Text("Your Profile (MOCKUP)")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                Section {
                    Text("This is a mockup of the final version and does not actually change at present. This is included soley so that you can see what a complete profile will look like.").italic()
                }
                NavigationLink(destination: SettingsView()) {
                    Label("App Settings", systemImage: "gear")
                }
                Button {
                    if let url = URL(string: "https://forms.gle/NqYdAAbZKPQmPq866"){
                        openURL(url)
                    }
                } label: {
                    HStack {
                        Label("Send Feedback", systemImage: "paperplane")
                    }
                }
                .buttonStyle(.plain)
                Button {
                    if let url = URL(string: "https://forms.gle/pJVhoyRU8A2ciDhz5"){
                        openURL(url)
                    }
                } label: {
                    HStack {
                        Label("Suggest Important Link", systemImage: "person.fill.questionmark")
                    }
                }
                .buttonStyle(.plain)
                ImportantLinksView()
            }
            .listStyle(.grouped)
            .navigationTitle(Text("Profile"))
            .modifier(NavSubtitleIfAvailable(subtitle: "WSO Mobile version: 1.2.0"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ProfileView()
}
