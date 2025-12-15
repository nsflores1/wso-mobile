//
//  LinksKeyView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-15.
//

import SwiftUI

struct LinksKeyView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    let introText = """
                    Links is a feature which displays useful links for the Williams College campus community.
                    """
                    Text(introText.replacingOccurrences(of: "\n", with: " "))
                }
                Section {
                    let explanationText = """
                    If you think of something you'd like to add, simply contact WSO by using the form listed on the previous page. New links will be added as soon as we get to them!
                    """
                    Text(explanationText.replacingOccurrences(of: "\n", with: " "))
                    let explanationText2 = """
                        Please note that submission of a link does not guarantee its inclusion. All links will be categorized by WSO. The links are sorted in the order in which they were added, although we reserve the right to change that in the future.
                        """
                    Text(explanationText2.replacingOccurrences(of: "\n", with: " "))
                }

            }
            .navigationTitle("Links Help")
            .modifier(NavSubtitleIfAvailable(subtitle: "For all your Link related needs"))
        }
    }
}

#Preview {
    LinksKeyView()
}
