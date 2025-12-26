//
//  ProfileMockupView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-25.
//

import SwiftUI
import System

struct ProfileMockupView: View {
    @Environment(\.openURL) private var openURL
    @Environment(NotificationManager.self) private var notificationManager

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
                    Text("This is a mockup of the final version and does not actually change at the moment. This is included just so that you can see what a complete profile will look like.").italic()
                }
            }
            .listStyle(.grouped)
            .navigationTitle(Text("Profile"))
            .modifier(NavSubtitleIfAvailable(subtitle: "WSO Mobile version: 1.2.1"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ProfileMockupView()
}
