//
//  WSOMobileCLI.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-14.
//

import Foundation
import ArgumentParser

@main
@available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13, watchOS 6, *)
struct AppCLI: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "wsomobilecli",
        abstract: "WSO Mobile CLI",
        usage: "wsomobilecli [options]",
        discussion: "The CLI interface to WSO.",
    )
    // TODO: maybe add more options in the future if needed

    mutating func run() async throws {
        print("### WSO Mobile CLI ###")
        await doDailyMessages()
        await doLibraryHours()
        await doWilliamsRecord()
        await doWilliamsDining()
        print("### EXECUTION OVER ###")
    }
}
