//
//  WSOFacTrakAreaKeyView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-03-01.
//

import SwiftUI

struct WSOFacTrakAreaKeyView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    let introText = """
                    This page is an Area view, showing you the contents of an overall course area (either one course or many courses).
                    """
                    Text(introText.replacingOccurrences(of: "\n", with: " "))
                }
                Section {
                    let explanationText = """
                    If this page covers many courses, you can scroll through both a list of professors and courses by department to get to what you're looking for quickly.
                    """
                    Text(explanationText.replacingOccurrences(of: "\n", with: " "))
                    let explanationText2 = """
                    You can tap on any course review to see its cooresponding professor, and vice versa.
                    """
                    Text(explanationText2.replacingOccurrences(of: "\n", with: " "))
                    let explanationText3 = """
                    To return to the home page after going many levels deep, tap the "Home" icon in the toolbar at the bottom of the screen.
                    """
                    Text(explanationText3.replacingOccurrences(of: "\n", with: " "))
                }
            }
            .navigationTitle("Area Page Help")
            .modifier(NavSubtitleIfAvailable(subtitle: "For all your FacTrak related needs"))
        }

    }
}

#Preview {
    WSOFacTrakAreaKeyView()
}
