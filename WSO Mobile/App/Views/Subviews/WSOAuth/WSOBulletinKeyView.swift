//
//  WSOBulletinKeyView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-31.
//

import SwiftUI

struct WSOBulletinKeyView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    let introText = """
                    Bulletins is a feature which displays useful messages for the Williams College campus community.
                    """
                    Text(introText.replacingOccurrences(of: "\n", with: " "))
                }
                Section {
                    let explanationText = """
                    Each section reflects a different kind of bulletin that you can access. Rides and discussions have special properties and thus are not shown here, despite being presented alongside all the other bulletins on the web version.
                    """
                    Text(explanationText.replacingOccurrences(of: "\n", with: " "))
                    let explanationText2 = """
                    Bulletins may take a second to load as the app fetches all bulletins available on the server (so that you can browse them offline if you would like). The same applies for search; it may take a second or two to load search results, depending on how old your iPhone is along with other factors.
                    """
                    Text(explanationText2.replacingOccurrences(of: "\n", with: " "))
                }
            }
            .navigationTitle("Bulletins Help")
            .modifier(NavSubtitleIfAvailable(subtitle: "For all your bulletin related needs"))
        }

    }
}

#Preview {
    WSOBulletinKeyView()
}
