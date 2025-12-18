//
//  WCFMKeyView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-15.
//


// This page is some short explanatory text for those unfamiliar with WCFM.

import SwiftUI

struct WCFMKeyView: View {
    @Environment(\.openURL) private var openURL
    

    var body: some View {
        NavigationStack {
            List {
                let introText = """
                    WCFM is a student-run radio station which plays live at Williams College.
                    You can see more details on the official WCFM site, linked below.
                    """
                Text(introText.replacingOccurrences(of: "\n", with: " "))
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    openURL(URL(string: "https://laurenkhall.nekoweb.org/website/index.html")!)
                } label: {
                    Label("WCFM Official Site", systemImage: "antenna.radiowaves.left.and.right")
                }
                let explanationText = """
                    You may notice that WCFM is not playing at all hours.
                    This is normal and to be expected. This radio player only works when a DJ is in the station and playing music live.
                    """
                Section {
                    Text(explanationText.replacingOccurrences(of: "\n", with: " "))
                }
                Section {
                    Text("Some other pertinent information:")
                    Section {
                        Text("-  The station metadata refreshes only once every 30 seconds, so if a song seems to not be listed even though it is playing, please be patient!")
                        Text("-  Sometimes, WCFM has a special event, and the cooresponding metadata you see is not what they are playing. Unfortunately, we cannot cover this special edge case. Player metadata is no guarantee of what's actually playing, but simply a best guess.")
                        Text("-  If you click on a song, you can open it in Apple Music if that's available. To change this to Spotify, look at the app settings.")
                    }
                }
            }
            .navigationTitle("WCFM Help")
            .modifier(NavSubtitleIfAvailable(subtitle: "For all your WCFM related needs"))
        }
    }
}

#Preview {
    WCFMKeyView()
}
