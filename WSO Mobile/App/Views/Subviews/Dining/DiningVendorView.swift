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
        ForEach(menu.meals.sorted(), id: \.mealName) { meal in
            let totalString = "\(meal.mealName.capitalized) (\(meal.openHours.replacingOccurrences(of: ":00", with: "")) - \(meal.closeHours.replacingOccurrences(of: ":00", with: "")))"

            let mealString = "\(meal.mealName.capitalized)"

            let timeString = "(\(meal.openHours.replacingOccurrences(of: ":00", with: "")) - \(meal.closeHours.replacingOccurrences(of: ":00", with: "")))"

            if !(meal.courses.isEmpty) {
                NavigationLink(destination: DiningCoursesView(courses: meal.courses, name: menu.hallName, time: totalString)) {
                    HStack {
                        Text(mealString)
                        Text(timeString)
                            .foregroundStyle(Color(.secondaryLabel))
                        Spacer()
                        if menu.isOpenNow(now: normalizedNowMinutes()) {
                            Image(systemName: "hands.and.sparkles")
                                .foregroundStyle(Color(.accent))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DiningView()
}
