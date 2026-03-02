//
//  NewsKeyView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-28.
//

import SwiftUI

struct NewsKeyView: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            List {
                let introText = """
                    The Williams Record is a student run newspaper on the Williams College campus that updates on a nearly weekly basis on Wednesdays.
                    For more information, please visit their official site:
                    """
                Text(introText.replacingOccurrences(of: "\n", with: " "))
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    openURL(URL(string: "https://williamsrecord.com")!)
                } label: {
                    Label("Williams Record Official Site", systemImage: "newspaper")
                }
                Section {
                    let explanationText = """
                    Williams Record articles are presented for the current week only in the WSO app; on weeks without a new publication, the app will show the last updated week.
                    """
                    Text(explanationText.replacingOccurrences(of: "\n", with: " "))
                    let explanationText2 = """
                        To share an article with your friends, use the share button on the top right of an article.
                        """
                    Text(explanationText2.replacingOccurrences(of: "\n", with: " "))
                }

            }
            .navigationTitle("News Help")
            .modifier(NavSubtitleIfAvailable(subtitle: "For all your news related needs"))
        }
    }
}

#Preview {
    NewsKeyView()
}
