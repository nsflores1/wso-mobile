//
//  ImportantLinks.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-16.
//

// TODO: update this from a web JSON rather than being manual
// TODO: also ask different campus orgs what they'd like in the app
// Orgs who are interested:
// - check your messages with jack allen (he has a bunch)
// - woc board
// - the record
// - wso (duh)
// - ephelia's roots
// - alexander hamilton society (check thianna dms)
// - black student union
// - williams colleeg jewish association
// TODO: people want to hide sections they don't want to see.
// TODO: you need to have a way to hide these if people don't want to see them, and have the app remember that

import SwiftUI
import Foundation

struct ImportantLinksView: View {
    @Environment(\.openURL) private var openURL
    
    // TODO: once we JSON this, you want a way to ForEach
    // through every single object, then have a dict of state ints
    // and then use that to determine if the views are expanded.
    // save them to @AppStorage or whatever. mmkay?

    var body: some View {
        Section {
            linkRow("Williams College Homepage", url: "https://williams.edu")
            linkRow("Williams College Sports", url: "https://ephsports.williams.edu/")
            linkRow("Academic Calendar", url: "https://catalog.williams.edu/academic-calendar/")
            linkRow("Course Catalog", url: "https://catalog.williams.edu")
        } header : {
            HStack {
                Image(systemName: "crown")
                Text("Official Stuff")
            }
        }
        Section {
            linkRow("WSO Homepage", url: "https://wso.williams.edu")
            linkRow("Willipedia Student Wiki", url: "https://wiki-wso.williams.edu")
            linkRow("Listserv Interface", url: "https://listserv-wso.williams.edu")
            linkRow("WSO GitHub ", url: "https://github.com/WilliamsStudentsOnline")
            linkRow("WSO Server Status ", url: "https://status-wso.williams.edu/")
        } header : {
            HStack {
                Image(systemName: "network")
                Text("Williams Students Online")
            }
        }
        Section {
            linkRow("Department Homepage", url: "https://geosciences.williams.edu")
            linkRow("Future Course Planner", url: "https://geosciences.williams.edu/the-major/major-requirements/")
        } header: {
            HStack {
                Image(systemName: "fossil.shell")
                Text("Geosciences Department")
            }
        }
    }

    @ViewBuilder
    private func linkRow(_ title: String, url: String) -> some View {
        Button {
            guard let u = URL(string: url) else { return }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            openURL(u)
        } label: {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
    }
}

#Preview {
    LinksView()
}
