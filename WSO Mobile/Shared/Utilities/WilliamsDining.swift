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

struct DiningHall {
    let hallName: String
    let meals: [Meal]
    let onlineOrder: Bool
    let operating: Bool
}

struct Meal {
    let mealName: String
    let openHours: String
    let closeHours: String
    let courses: [Courses]
}

struct Courses {
    let courseTitle: String
    let foodItems: [FoodItem]
}

struct FoodItem {
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

// meals are the trickest.
// technically, no meal starts on the next calendar date,
// so we compare JUST by that first date.

// TODO: this is still weirdly bugged.
// you probably need to parse this somewhat.

extension Meal: Comparable {
    static func < (lhs: Meal, rhs: Meal) -> Bool {
        if lhs.openHours.contains("am") && rhs.openHours.contains("am") {
            // thing with the lower hours wins
            return lhs.openHours < rhs.openHours
        }
        if lhs.openHours.contains("am") && (!rhs.openHours.contains("am")) {
            return true
        }
        if lhs.openHours.contains("pm") && rhs.openHours.contains("pm") {
            // thing with the lower hours wins
            return lhs.openHours < rhs.openHours
        }
        if lhs.openHours.contains("pm") && (!rhs.openHours.contains("am")) {
            return false
        }
        // if somehow none of these cases are satisfied, then fallback to normal comparison
        // TODO: maybe we should throw an error here instead?
        return lhs.openHours < rhs.openHours
    }

    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.openHours == rhs.openHours
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

struct WilliamsDiningParseError : Error {}

func oldParseWilliamsDining() async throws -> MenuResponse {
    let url = URL(string: "https://wso.williams.edu/dining.json")!
    do {
        let (data, _) = try await URLSession.shared.data(from: url)

        let response = try JSONDecoder().decode(MenuResponse.self, from: data)

        return response
    } catch {
        throw WilliamsDiningParseError()
    }
}

func oldDoWilliamsDining() async {
    do {
        let response = try await oldParseWilliamsDining()

        for (_, vendor) in response.vendors {
            print("vendor: \(vendor.name)")

            for (_, meal) in vendor.meals {
                print("  meal: \(meal.name) (\(meal.hours.open) - \(meal.hours.close))")

                if let courses = meal.courses {
                    for (_, course) in courses {
                        print("    course: \(course.name)")
                        for item in course.items {
                            print("      - \(item.name)")
                        }
                    }
                }
            }
        }
    } catch {
        print("No menu contents")
    }
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
