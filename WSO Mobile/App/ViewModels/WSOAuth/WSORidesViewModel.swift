//
//  WSORidesViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-15.
//

import SwiftUI

@MainActor
@Observable
class WSORidesViewModel {
    private let cache = CacheManager.shared

    // contains ALL data.
    var data: [WSORidesItem] = []

    var isLoading: Bool = false
    var error: WebRequestError?
    private var hasFetched = false

    func loadList() async {
        isLoading = true
        error = nil

            // only last about an hour
        if let cached: TimestampedData<[WSORidesItem]> = await cache.load(
            [WSORidesItem].self,
            from: "bulletin_rides.json",
            maxAge: 3600
        ) {
            self.data = cached.data
            self.isLoading = false
            self.error = nil
            return
        }

        do {
            let data: [WSORidesItem] = try await WSOListRides()
            // auto drop ones in the future and ones which don't apply
            let futureData = data.filter {
                guard let checkDate = $0.date else { return false }
                return checkDate > Date()
            }
            self.data = futureData
            self.error = nil

            try await cache.save(data, to: "bulletin_rides.json")
        } catch let err as WebRequestError {
            self.error = err
            self.data = []
        } catch {
            self.error = WebRequestError.internalFailure
            self.data = []
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
            let data: [WSORidesItem] = try await WSOListRides()
                // auto drop ones in the future and ones which don't apply
            let futureData = data.filter {
                guard let checkDate = $0.date else { return false }
                return checkDate > Date()
            }
            self.data = futureData
            self.error = nil

            try await cache.save(data, to: "bulletin_rides.json")
        } catch let err as WebRequestError {
            self.error = err
            self.data = []
        } catch {
            self.error = WebRequestError.internalFailure
            self.data = []
        }

        isLoading = false
    }

    func clearCache() async {
        await cache.clear(path: "bulletin_rides.json")
        self.data = []
    }
}
