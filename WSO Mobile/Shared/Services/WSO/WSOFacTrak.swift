//
//  WSOFacTrak.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-16.
//

// this section contains a bunch of useful methods for handling FacTrak data.

import Foundation
import HTTPTypes
import HTTPTypesFoundation

// firstly: useful data structures.
struct WSOFacTrakResponse: Codable, Equatable, Hashable {
    let status: Int
    let data: [WSOFacTrakAreasOfStudy]
}

struct WSOFacTrakSearchResponse: Codable, Equatable, Hashable {
    let status: Int
    let data: [WSOFacTrakSearch]
}

struct WSOFacTrakAreasOfStudy: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let name: String
    let abbreviation: String
    let departmentID: Int
}

struct WSOFacTrakSearch: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let value: String
    let type: String
}

// gets all current departments from FacTrak.
func WSOFacTrakGetAreasOfStudy() async throws -> [WSOFacTrakAreasOfStudy] {
    let parser = JSONISO8601Parser<WSOFacTrakResponse>()
    let request = WebRequest<JSONISO8601Parser<WSOFacTrakResponse>, NoParser>(
        url: URL(string: "https://wso.williams.edu/api/v2/factrak/areas-of-study")!,
        requestType: .get,
        getParser: parser
    )
    let response = try await request.authGet()
    return response.data
}

// gets a list of profs and classes with a given query string
func WSOFacTrakSearch(query: String) async throws -> [WSOFacTrakSearch] {
    let parser = JSONISO8601Parser<WSOFacTrakSearchResponse>()
    let request = WebRequest<JSONISO8601Parser<WSOFacTrakSearchResponse>, NoParser>(
        url: URL(string: "https://wso.williams.edu/api/v2/autocomplete/factrak?q=\(query)")!,
        requestType: .get,
        getParser: parser
    )
    return try await request.authGet().data
}

struct WSOFacTrakProfResponse: Codable, Equatable, Hashable {
    let status: Int
    let data: WSOFacTrakProf
}

// now: the weird custom user data struct that all profs have.
struct WSOFacTrakProf: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let type: String
    let name: String
    let unixID: String
    let williamsEmail: String
    let title: String
    let factrakSurveys: [WSOFacTrakReview]
}

struct WSOFacTrakReviewResponse: Codable, Equatable, Hashable {
    let status: Int
    let data: [WSOFacTrakReview]
}

struct WSOFacTrakMinimalReviewResponse: Codable, Equatable, Hashable {
    let status: Int
    let data: [WSOFacTrakMinimalReview]
}

// factrak reviews embedded in prof profiles
struct WSOFacTrakReview: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let userID: Int
    let courseID: Int
    let professorID: Int
    let professor: User?
    let course: WSOFacTrakCourseIdentifier
    let comment: String
    let wouldRecommendCourse: Bool?
    let wouldTakeAnother: Bool?
    let semesterYear: Int?
    let semesterSeason: String?
    // numerical scores, can't assume they exist
    let courseWorkload: Int?
    let courseStimulating: Int?
    let approachability: Int?
    let leadLecture: Int?
    let promoteDiscussion: Int?
    let outsideHelpfulness: Int?
    let mentalHealthSupport: Int?
    // agree counters always exist
    let totalAgree: Int
    let totalDisagree: Int
    let flagged: Bool
}

// factrak reviews that exist within survey APIs
struct WSOFacTrakMinimalReview: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let userID: Int
    let courseID: Int
    let professorID: Int
    let professor: User?
    let comment: String
    let wouldRecommendCourse: Bool?
    let wouldTakeAnother: Bool?
    let semesterYear: Int?
    let semesterSeason: String?
    // numerical scores, can't assume they exist
    let courseWorkload: Int?
    let courseStimulating: Int?
    let approachability: Int?
    let leadLecture: Int?
    let promoteDiscussion: Int?
    let outsideHelpfulness: Int?
    let mentalHealthSupport: Int?
    // agree counters always exist
    let totalAgree: Int
    let totalDisagree: Int
    let flagged: Bool
}

struct WSOFacTrakCourseIdentifier: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let number: String
    let areaOfStudy: WSOFacTrakAreaOfStudyIdentifier
}

struct WSOFacTrakAreaOfStudyIdentifier: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let name: String
    let abbreviation: String
}

struct WSOFacTrakProfRatingsResponse: Codable, Equatable, Hashable {
    let status: Int
    let data: WSOFacTrakProfRatings
}

struct WSOFacTrakProfRatings: Codable, Equatable, Hashable {
    let avgApproachability: Float
    let avgCourseStimulating: Float
    let avgCourseWorkload: Float
    let avgLeadLecture: Float
    let avgMentalHealthSupport: Float
    let avgOutsideHelpfulness: Float
    let avgPromoteDiscussion: Float
    let avgWouldRecommendCourse: Float
    let avgWouldTakeAnother: Float
    let numApproachability: Int
    let numCourseStimulating: Int
    let numCourseWorkload: Int
    let numLeadLecture: Int
    let numMentalHealthSupport: Int
    let numOutsideHelpfulness: Int
    let numPromoteDiscussion: Int
    let numWouldRecommendCourse: Int
    let numWouldTakeAnother: Int
}

struct WSOFacTrakAreaOfStudyProfListResponse: Codable, Equatable, Hashable {
    let status: Int
    let data: [User]
}

struct WSOFacTrakAreaOfStudyCourseListResponse: Codable, Equatable, Hashable {
    let status: Int
    let data: [WSOFacTrakAreasOfStudyCourses]
}

struct WSOFacTrakAreasOfStudyCourses: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let number: String
    let areaOfStudyID: Int
    let professors: [User]?
}

// comparator to be able to sort them in the area view
extension WSOFacTrakAreasOfStudyCourses: Comparable {
    static func < (lhs: WSOFacTrakAreasOfStudyCourses, rhs: WSOFacTrakAreasOfStudyCourses) -> Bool {
        return lhs.number < rhs.number
    }
    static func == (lhs: WSOFacTrakAreasOfStudyCourses, rhs: WSOFacTrakAreasOfStudyCourses) -> Bool {
        return lhs.number == rhs.number
    }
}

enum WSOFacTrakTypes {
    case Professor
    case Course
}

// fetches profs by department
func WSOFacTrakAreasOfStudyGetProf(query: Int) async throws -> [User] {
    let parser = JSONISO8601Parser<WSOFacTrakAreaOfStudyProfListResponse>()
    let request = WebRequest<JSONISO8601Parser<WSOFacTrakAreaOfStudyProfListResponse>, NoParser>(
        url: URL(string: "https://wso.williams.edu/api/v2/factrak/professors?areaOfStudyID=\(query)")!,
        requestType: .get,
        getParser: parser
    )
    return try await request.authGet().data
}

// fetches courses by department
func WSOFacTrakAreasOfStudyGetCourses(query: Int) async throws -> [WSOFacTrakAreasOfStudyCourses] {
    let parser = JSONISO8601Parser<WSOFacTrakAreaOfStudyCourseListResponse>()
    let request = WebRequest<JSONISO8601Parser<WSOFacTrakAreaOfStudyCourseListResponse>, NoParser>(
        url: URL(string: "https://wso.williams.edu/api/v2/factrak/courses?areaOfStudyID=\(query)")!,
        requestType: .get,
        getParser: parser
    )
    return try await request.authGet().data
}

// fetches profs by id
func WSOFacTrakGetProf(query: Int) async throws -> WSOFacTrakProf {
    let parser = JSONISO8601Parser<WSOFacTrakProfResponse>()
    let request = WebRequest<JSONISO8601Parser<WSOFacTrakProfResponse>, NoParser>(
        url: URL(string: "https://wso.williams.edu/api/v2/factrak/professors/\(query)")!,
        requestType: .get,
        getParser: parser
    )
    return try await request.authGet().data
}

// fetches prof feedback by id
func WSOFacTrakGetProfRatings(query: Int) async throws -> WSOFacTrakProfRatings {
    let parser = JSONISO8601Parser<WSOFacTrakProfRatingsResponse>()
    let request = WebRequest<JSONISO8601Parser<WSOFacTrakProfRatingsResponse>, NoParser>(
        url: URL(string: "https://wso.williams.edu/api/v2/factrak/professors/\(query)/ratings")!,
        requestType: .get,
        getParser: parser
    )
    return try await request.authGet().data
}

// fetches reviews by type
func WSOFacTrakGetReviews(query: Int, kind: WSOFacTrakTypes) async throws -> [WSOFacTrakMinimalReview] {
    let parser = JSONISO8601Parser<WSOFacTrakMinimalReviewResponse>()
    var url = "https://wso.williams.edu/api/v2/factrak/surveys"
    if kind == .Professor {
        url = "\(url)?professorID=\(query)"
    } else if kind == .Course {
        url = "\(url)?courseID=\(query)"
    }
    let request = WebRequest<JSONISO8601Parser<WSOFacTrakMinimalReviewResponse>, NoParser>(
        url: URL(string: url)!,
        requestType: .get,
        getParser: parser
    )
    return try await request.authGet().data
}

