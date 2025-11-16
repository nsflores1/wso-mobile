//
//  ImportantLinks.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-16.
//

// TODO: update this from a web JSON rather than being manual
// TODO: also ask different campus orgs what they'd like in the app

import SwiftUI
import Foundation

struct ImportantLinksView: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        Section {
            linkRow("Williams College Homepage", url: "https://williams.edu")
        } header : {
            Text("Important Links")
                .fontWeight(.semibold)
                .font(.title3)
        }
    }

    @ViewBuilder
    private func linkRow(_ title: String, url: String) -> some View {
        Button {
            guard let u = URL(string: url) else { return }
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
    ProfileView().environmentObject(AppSettings.shared)
}
