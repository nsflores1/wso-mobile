//
//  DiningTypes.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-19.
//

// bundled dining data types, from WilliamsDining.swift in the app.

import SwiftUI
import Foundation

// decoding structs.
// so this is what we get in, and then we're going to use some fancy tools
// to flatten this down, because this is ridiculous.

struct MenuResponse: Codable {
    let vendors: [String: Vendor]
    let updateTime: String
}

struct Vendor: Codable {
    let name: String
    let meals: [String: Meals]
    let onlineOrder: Bool
    let operating: Bool
}

struct Meals: Codable {
    let name: String
    let hours: Hours
    let courses: [String: Course]?
}

struct Hours: Codable {
    let open: String
    let close: String
}

struct Course: Codable {
    let name: String
    let items: [MenuItem]
}

struct MenuItem: Codable {
    let name: String
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
}

// internal structs. use these for the much flatter, actual state.

struct DiningHall: Codable {
    let hallName: String
    let meals: [Meal]
    let onlineOrder: Bool
    let operating: Bool

        // another hack... ugh
    func isOpenNow(now: Int) -> Bool {
        meals.contains { $0.isOpen(now: now) }
    }

        // every course is empty, but there may be many courses for many meals
        // still defined. I hate this API.
    func hasCoursesToday() -> Bool {
        let truth = meals.contains { meal in
            meal.courses.contains { course in
                !course.foodItems.isEmpty
            }
        }
            // we actually want the OPPOSITE, the case where every meal is empty
            // it's just easier to express it above, like so
        return !truth
    }
        // the same for all dining halls. sloppy but it works
    let updateTime: String
}

struct Meal: Codable {
    let mealName: String
    let openHours: String
    let closeHours: String
    let courses: [Courses]

        // some code that lets us handle the openHours and closeHours
    private static let timeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "hh:mma"
        return df
    }()

    func normalizedMinutes(cutoffHour: Int = 5) -> Int {
        guard let date = Meal.timeFormatter.date(from: openHours.lowercased()) else {
            fatalError("invalid time string: \(openHours)")
        }

        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comps.hour!
        let minute = comps.minute!

        let raw = hour * 60 + minute
        let cutoff = cutoffHour * 60

            // anything before cutoff is considered "next day"
        return raw < cutoff ? raw + 24 * 60 : raw
    }

        // check itself and determine from there
    func isOpen(now: Int) -> Bool {
        let open = normalizedMinutes()
        let close = {
            guard let date = Meal.timeFormatter.date(from: closeHours.lowercased()) else {
                fatalError("invalid time string: \(closeHours)")
            }

            let calendar = Calendar(identifier: .gregorian)
            let comps = calendar.dateComponents([.hour, .minute], from: date)
            let raw = comps.hour! * 60 + comps.minute!
            let cutoff = 5 * 60
            return raw < cutoff ? raw + 24 * 60 : raw
        }()

        return now >= open && now < close
    }
}

struct Courses: Codable {
    let courseTitle: String
    let foodItems: [FoodItem]
}

struct FoodItem: Codable {
    let name: String
    let isVegetarian: Bool
    let isVegan: Bool
    let isGlutenFree: Bool
}

// comparable extensions so that we can think about them meaningfully
extension DiningHall: Comparable {
    static func < (lhs: DiningHall, rhs: DiningHall) -> Bool {
            // confusingly, students expect reverse alphabetical so this makes most sense
        return lhs.hallName > rhs.hallName
    }
    static func == (lhs: DiningHall, rhs: DiningHall) -> Bool {
        return lhs.hallName == rhs.hallName
    }
}

extension Courses: Comparable {
    static func < (lhs: Courses, rhs: Courses) -> Bool {
        return lhs.courseTitle < rhs.courseTitle
    }

    static func == (lhs: Courses, rhs: Courses) -> Bool {
        return lhs.courseTitle == rhs.courseTitle
    }
}

extension Meal: Comparable {
    static func < (lhs: Meal, rhs: Meal) -> Bool {
        lhs.normalizedMinutes() < rhs.normalizedMinutes()
    }

    static func == (lhs: Meal, rhs: Meal) -> Bool {
        lhs.normalizedMinutes() == rhs.normalizedMinutes()
    }
}

extension FoodItem: Comparable {
    static func < (lhs: FoodItem, rhs: FoodItem) -> Bool {
        return lhs.name < rhs.name
    }

    static func == (lhs: FoodItem, rhs: FoodItem) -> Bool {
        return lhs.name == rhs.name
    }
}

    // this stops assuming a day around the cutoff, which is important for avoiding
    // all sorts of weird time bugs that would otherwise happen around 4am
func normalizedNowMinutes(cutoffHour: Int = 5) -> Int {
    let calendar = Calendar(identifier: .gregorian)
    let comps = calendar.dateComponents([.hour, .minute], from: Date())
    let hour = comps.hour!
    let minute = comps.minute!

    let raw = hour * 60 + minute
    let cutoff = cutoffHour * 60

    return raw < cutoff ? raw + 24 * 60 : raw
}
