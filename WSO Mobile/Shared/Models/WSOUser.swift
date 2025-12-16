//
//  WSOUser.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-16.
//

import Foundation

// WSO has a concept of a "user" which is present frequently throughout the code.
// so this provides some abstractions by making a User class which is Codable
// and comes with some nice helper methods, so you can figure out how to work with them.

struct User: Codable, Equatable, Hashable {
    let admin: Bool
    let atWilliams: Bool
    let cellPhone: String?
    let classYear: Int
    let hasAcceptedDormtrakPolicy: Bool
    let hasAcceptedFactrakPolicy: Bool
    let homeCountry: String?
    let homePhone: String?
    let homeState: String?
    let homeTown: String?
    let homeVisible: Bool
    let id: Int
    let name: String
    let pronoun: String
    let unixID: String
    let visible: Bool
    let williamsEmail: String
    let williamsID: String
}

// the default comparator for the User class will simply check the names,
// since that's how people usually think about it.
extension User: Comparable {
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.name < rhs.name
    }
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.name == rhs.name
    }
}
