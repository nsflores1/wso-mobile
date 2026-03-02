//
//  WSOFacTrakAreaView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-02-20.
//

import SwiftUI

@MainActor
@Observable
class WSOFacTrakAreaViewModel {
    private let cache = CacheManager.shared

    // cache per-id.
    let id: Int

    init(id: Int) {
        self.id = id
    }

    // contains ALL data.
    var professors: [User]? = nil
    var courses: [WSOFacTrakAreasOfStudyCourses]? = nil

    var isLoading: Bool = false
    var error: WebRequestError?
    private var hasFetched = false

    func loadList() async {
        isLoading = true
        error = nil

        // only last about an hour
        if let cachedProfs: TimestampedData<[User]> = await cache.load(
            [User].self,
            from: "factrak_dept_profs_\(self.id).json",
            maxAge: 3600
        ) {
            self.professors = cachedProfs.data
        }

        if let cachedCourses: TimestampedData<[WSOFacTrakAreasOfStudyCourses]> = await cache.load(
            [WSOFacTrakAreasOfStudyCourses].self,
            from: "factrak_dept_courses_\(self.id).json",
            maxAge: 3600
        ) {
            self.courses = cachedCourses.data
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let professors: [User] = try await WSOFacTrakAreasOfStudyGetProf(
                query: self.id
            )
            self.professors = professors

            try await cache.save(professors, to: "factrak_dept_profs_\(self.id).json")

            let courses: [WSOFacTrakAreasOfStudyCourses] = try await WSOFacTrakAreasOfStudyGetCourses(
                query: self.id
            )
            self.courses = courses
            self.error = nil

            try await cache.save(courses, to: "factrak_dept_courses_\(self.id).json")
        } catch let err as WebRequestError {
            self.error = err
            self.professors = nil
            self.courses = nil
        } catch {
            self.error = WebRequestError.internalFailure
            self.professors = nil
            self.courses = nil
        }

        isLoading = false
    }

    func fetchIfNeeded() async {
        guard !hasFetched else { return }
        hasFetched = true
        await loadList()
    }

    func forceRefresh() async {
        isLoading = true

        do {
            let professors: [User] = try await WSOFacTrakAreasOfStudyGetProf(
                query: self.id
            )
            self.professors = professors

            try await cache.save(professors, to: "factrak_dept_profs_\(self.id).json")

            let courses: [WSOFacTrakAreasOfStudyCourses] = try await WSOFacTrakAreasOfStudyGetCourses(
                query: self.id
            )
            self.courses = courses
            self.error = nil

            try await cache.save(courses, to: "factrak_dept_courses_\(self.id).json")
        } catch let err as WebRequestError {
            self.error = err
            self.professors = nil
            self.courses = nil
        } catch {
            self.error = WebRequestError.internalFailure
            self.professors = nil
            self.courses = nil
        }

        isLoading = false
    }

    func clearCache() async {
        await cache.clear(path: "factrak_dept_courses_\(self.id).json")
        await cache.clear(path: "factrak_dept_profs_\(self.id).json")
        self.professors = nil
        self.courses = nil
    }
}
