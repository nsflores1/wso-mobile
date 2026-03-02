//
//  WSOFacTrakProfKeyView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-03-01.
//

import SwiftUI

struct WSOFacTrakProfKeyView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    let introText = """
                    This page is a Professor view, showing you the contents of a profesor's course reviews.
                    """
                    Text(introText.replacingOccurrences(of: "\n", with: " "))
                }
                Section {
                    let explanationText = """
                    The top of the page contains the overall review scores for a professor, followed by a scrollable list of reviews for you to inspect and read for further information.
                    """
                    Text(explanationText.replacingOccurrences(of: "\n", with: " "))
                    let explanationText2 = """
                    You can tap on any of the reviews to get a more comprehensive view of the entire course's reviews for any given professor.
                    """
                    Text(explanationText2.replacingOccurrences(of: "\n", with: " "))
                    let explanationText3 = """
                    To return to the home page after going many levels deep, tap the "Home" icon in the toolbar at the bottom of the screen.
                    """
                    Text(explanationText3.replacingOccurrences(of: "\n", with: " "))
                }
            }
            .navigationTitle("Professor Page Help")
            .modifier(NavSubtitleIfAvailable(subtitle: "For all your FacTrak related needs"))
        }

    }
}

#Preview {
    WSOFacTrakProfKeyView()
}
