//
//  SettingsKeyView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-28.
//

import SwiftUI

struct SettingsKeyView: View {
    var body: some View {
        NavigationStack {
            List {
                let explanation = """
                    This page is a short explanation on what the various settings do.
                    
                    Each group of settings is listed below with an explanation per setting:
                    """
                Text(explanation)
                Section {
                    HStack {
                        Text("Enable Notifications: ").bold() + Text("allows you to recieve notifications. If you have disabled notifications for WSO, you will need to enable them in the Settings app on your phone.")
                    }
                    HStack {
                        Text("Test Notifications: ").bold() + Text("sends a test notification. It may not deliver if you are using a Focus mode, such as Do Not Disturb.")
                    }
                } header : {
                    Text("Notifications")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                Section {
                    HStack {
                        Text("User Type: ").bold() + Text("this setting allows non-students to hide/disable interface items which would require a student login.")
                    }
                    HStack {
                        Text("Use Serif Font For Record: ").bold() + Text("changes the font used in the in-app Williams Record reader to the same serif font used in the physical newsprint version (the default is a sans serif font).")
                    }
                    HStack {
                        Text("Hide All Restaurants: ").bold() + Text("hides all non-dining halls from the Dining tab of the app.")
                    }
                    HStack {
                        Text("Enable Beta Options: ").bold() + Text("does exactly what it says it does. If you are a WSO developer or just curious about new features, you can use this to test new features that are not yet available to the general public.")
                    }
                } header : {
                    Text("Toggles")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                Section {
                    HStack {
                        Text("Reset Onboarding: ").bold() + Text("resets the onboarding flow to its original state, if you want to read it again.")
                    }
                    HStack {
                        Text("Force Clear Cache: ").bold() + Text("this button deletes all temporary files that WSO uses on disk except for your login data.")
                    }
                    HStack {
                        Text("Logout of WSO: ").bold() + Text("resets your login. Only visible to students (since only students can login).")
                    }
                } header : {
                    Text("Reset & Cache")
                        .fontWeight(.semibold)
                        .font(.title3)
                }

            }
            .navigationTitle("Settings Help")
            .modifier(NavSubtitleIfAvailable(subtitle: "For all your settings-related questions"))
        }
    }
}

#Preview {
    SettingsKeyView()
}
