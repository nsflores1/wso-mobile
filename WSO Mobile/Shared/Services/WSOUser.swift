//
//  WSOUser.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-16.
//
import Foundation
import HTTPTypes
import HTTPTypesFoundation

// WSO has a concept of a "user" which is present frequently throughout the code.
// so this provides some abstractions by making a User class which is Codable
// and comes with some nice helper methods, so you can figure out how to work with them.

struct WSOUserData: Codable {
    var status: Int
    var data: User
}

struct WSOUserTag: Codable, Hashable {
    let id: Int
    let name: String
}

struct WSOUserDepartment: Codable, Hashable {
    let id: Int
    let name: String
}

struct WSOUserOffice: Codable, Hashable {
    let id: Int
    let number: String
}

struct User: Codable, Equatable, Hashable {
    let admin: Bool
    let factrakAdmin: Bool
    let atWilliams: Bool
    let cellPhone: String?
    let classYear: Int?
    let hasAcceptedDormtrakPolicy: Bool
    let hasAcceptedFactrakPolicy: Bool
    let homeCountry: String?
    let homePhone: String?
    let homeState: String?
    let homeTown: String?
    let homeVisible: Bool
    let id: Int
    let type: String
    let tags: [WSOUserTag]?
    let department: WSOUserDepartment?
    let office: WSOUserOffice?
    let suBox: String?
    let name: String
    let title: String?
    let pronoun: String?
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

// helper method to get a user
func WSOGetUser(userid: Int) async throws -> User {
    let parser = JSONISO8601Parser<WSOUserData>()
    let request = WebRequest<JSONISO8601Parser<WSOUserData>, NoParser>(
        url: URL(string: "https://wso.williams.edu/api/v2/users/\(userid)")!,
        requestType: .get,
        getParser: parser
    )
    return try await request.authGet().data
}

// helper method to get oneself
func WSOGetUserSelf() async throws -> User {
    let parser = JSONISO8601Parser<WSOUserData>()
    let request = WebRequest<JSONISO8601Parser<WSOUserData>, NoParser>(
        url: URL(string: "https://wso.williams.edu/api/v2/users/me")!,
        requestType: .get,
        getParser: parser
    )
    return try await request.authGet().data
}

// helper method to get an image, by size
// extant sizes: large, thumb
func WSOGetUserImage(unix: String, imageSize: String = "large") async throws -> Data {
    let request = WebRequest<RawParser, NoParser>(
        url: URL(string: "https://wso.williams.edu/pic/user/\(imageSize)/\(unix).jpg")!,
        requestType: .get,
        getParser: RawParser()
    )
    return try await request.authGet()
}


