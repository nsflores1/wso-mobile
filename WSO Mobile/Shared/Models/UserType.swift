//
//  UserType.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-28.
//


// unlike the others, this isn't an observable class
// this simply "models" if a user is a Student or non-Student,
// which accordingly hides certain irrelevant information from them

enum UserType: String, CaseIterable, Identifiable {
    case student, nonstudent
    var id: Self { self }
}
