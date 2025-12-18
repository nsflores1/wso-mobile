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
                        DiningCoursesView(courses: meal.courses)
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
