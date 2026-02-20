//
//  DiningVendorView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-20.
//

import SwiftUI
import Foundation

struct DiningVendorView: View {
    let menu: DiningHall

    var body: some View {
        NavigationStack {
            List {
                ForEach(menu.meals.sorted(), id: \.mealName) { meal in
                    Section("\(meal.mealName.capitalized) (\(meal.openHours.replacingOccurrences(of: ":00", with: "")) - \(meal.closeHours.replacingOccurrences(of: ":00", with: "")))") {
                        DisclosureGroup() {
                            DiningCoursesView(courses: meal.courses)
                        } label: {
                            Text("(Tap to view this course...)").italic()
                        }
                    }
                }
            }
            .navigationTitle(menu.hallName)
        }
    }
}

#Preview {
    DiningView()
}
