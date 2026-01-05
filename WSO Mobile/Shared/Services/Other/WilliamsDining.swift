//
//  WilliamsDining.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-19.
//

// dining is LITERALLY the devil.
// if this breaks, you're on your own. sorry.
// we parse the WSO backend, that needs to be kept stable,
// since it's easier to patch backend than the app.

import SwiftUI
import Foundation
import HTTPTypes
import HTTPTypesFoundation

// decoding structs.
// so this is what we get in, and then we're going to use some fancy tools
// to flatten this down, because this is ridiculous.

struct MenuResponse: Codable {
    let vendors: [String: Vendor]
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

// this helper function makes it substantially easier to handle the data
// you are not expected to understand this. I chose to do it with some very
// strange functional programming magic... don't be bothered by it.
func flattenMenuResponse(_ response: MenuResponse) -> [DiningHall] {
    response.vendors.values.map { vendor in
        DiningHall(
            hallName: vendor.name,
            meals: vendor.meals.values.map { meal in
                Meal(
                    mealName: meal.name,
                    openHours: meal.hours.open,
                    closeHours: meal.hours.close,
                    courses: (meal.courses ?? [:]).values.map { course in
                        Courses(
                            courseTitle: course.name,
                            foodItems: course.items.map { item in
                                FoodItem(
                                    name: item.name,
                                    isVegetarian: item.vegetarian,
                                    isVegan: item.vegan,
                                    isGlutenFree: item.glutenFree
                                )
                            }
                        )
                    }
                )
            },
            onlineOrder: vendor.onlineOrder,
            operating: vendor.operating
        )
    }
}

func parseWilliamsDining() async throws -> [DiningHall] {
    let parser = JSONParser<MenuResponse>()
    let request = WebRequest<JSONParser, NoParser>(
        url: URL(string: "https://wso.williams.edu/dining.json")!,
        requestType: .get,
        getParser: parser
    )
    let data = try await request.get()
    return flattenMenuResponse(data)
}

struct DateFile: Codable, Hashable, Identifiable {
    let date: Date

    var id: Date { date }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)

        guard raw.hasSuffix(".json") else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "expected .json suffix, got something else"
            )
        }

        let dateString = String(raw.dropLast(5))

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"

        guard let date = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "invalid date format"
            )
        }

        self.date = date
    }
}

func getListPastWilliamsDiningMenus() async throws -> [Date] {
    let parser = JSONParser<[DateFile]>()
    let request = WebRequest<JSONParser, NoParser>(
        url: URL(string: "https://wso.williams.edu/past_menus.json")!,
        requestType: .get,
        getParser: parser
    )
    return try await request.get().map { $0.date } // return date, not this weird type
}

func getSinglePastWilliamsDiningMenus(date: Date) async throws -> [DiningHall] {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd"
    // the thing we'll pass in
    let string = formatter.string(from: date)

    let parser = JSONParser<MenuResponse>()
    let request = WebRequest<JSONParser, NoParser>(
        url: URL(string: "https://wso.williams.edu/menus/\(string).json")!,
        requestType: .get,
        getParser: parser
    )
    let data = try await request.get()
    return flattenMenuResponse(data)
}

func doWilliamsDining() async {
    do {
        let response = try await parseWilliamsDining()
        for hall in response {
            print(hall.hallName, "is serving \(hall.meals.count) meals")
            for meal in hall.meals {
                print("  meal: ", meal.mealName, "runs from hours \(meal.openHours) - \(meal.closeHours)")
                for course in meal.courses {
                    print("  course:", course.courseTitle)
                    for item in course.foodItems {
                        print("    - ", item.name)
                    }
                }
            }
        }
    } catch {
        print("No menu contents")
    }
}
