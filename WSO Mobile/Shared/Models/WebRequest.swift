//
//  WebRequest.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-12.
//

// meta-class that handles the oft-annoying task of fetching data over the internet.

import Foundation
import HTTPTypes
import HTTPTypesFoundation

// this defines a parser for some endpoint.
protocol DataParser {
    associatedtype ParsedType: Codable
    // the HTTP header types. so for HTML this is like 'text/html'
    var acceptType: String { get }
    var contentType: String { get }
    // a function which parses the data and returns some Codable type
    func parse(data: Data) async throws -> ParsedType
    // TODO: add an encode() method which allows for pushing data back in PUSH requests
}

enum WebRequestError : Error {
    case noParser(String)
}

// WebRequest is a class that allows you to easily define a whole family of requests.
// when you declare it, you get to basically specify a parser for any given HTTP request type.
// then you can quickly parse the data for any endpoint when you get it back/when you send it,
// so all you need to focus on is SENDING data.

// its biggest advantage is that we get to use auth methods in here,
// massively simplifying the implementation of auth-based services.
// plus it means simplifying the header logic and stuff.

// TODO: implement the various other HTTP request methods as they come up

class WebRequest<GetParser: DataParser, PostParser: DataParser> {
    private var session = URLSession.shared
    private let cache = URLCache.shared

    // bidirectional: WebRequest supports decoding and encoding
    // but, to prevent confusion, we always use the same site,
    // so setting it after intialization is impossible.
    var getParser: GetParser?
    var postParser: PostParser?
    private let internalURL: URL

    var requestType: HTTPRequest.Method

    init(
        url: URL,
        requestType: HTTPRequest.Method,
        getParser: GetParser? = nil,
        postParser: PostParser? = nil,
    ) {
        self.getParser = getParser
        self.postParser = postParser
        self.requestType = requestType
        self.internalURL = url

        // crank the global cache all the way up
        // TODO: find a better place to do this.
        // this is OKAY, but will eventually introduce subtle problems, because like
        // who in god's green earth would expect this code to be HERE of all places?
        if cache.memoryCapacity >= 50_000_000 { cache.memoryCapacity = 50_000_000 }
        if cache.diskCapacity >= 100_000_000 { cache.diskCapacity = 100_000_000 }
    }

    func get() async throws -> GetParser.ParsedType {
        if getParser != nil {
            var request = HTTPRequest(method: .get, url: internalURL)
            request.headerFields[.userAgent] = "New WSO Mobile/1.2.0"
            request.headerFields[.accept] = getParser!.acceptType

            let (data, _) = try await session.data(for: request)
            return try await getParser!.parse(data: data)
        } else {
            throw WebRequestError.noParser("No decode parser yet fetch was requested.")
        }
    }

    // TODO: make this actually make requests with authentication
    func authGet(token: String) async throws -> GetParser.ParsedType {
        if getParser != nil {
            var request = HTTPRequest(method: .get, url: internalURL)
            request.headerFields[.userAgent] = "New WSO Mobile/1.2.0"
            request.headerFields[.accept] = getParser!.acceptType

            let (data, _) = try await session.data(for: request)
            return try await getParser!.parse(data: data)
        } else {
            throw WebRequestError.noParser("No decode parser yet fetch was requested.")
        }
    }

    func post(sendData: Data) async throws -> PostParser.ParsedType {
        if postParser != nil {
            var request = HTTPRequest(method: .post, url: internalURL)
            request.headerFields[.userAgent] = "New WSO Mobile/1.2.0"
            request.headerFields[.accept] = postParser!.acceptType
            request.headerFields[.contentType] = postParser!.contentType

            // TODO: we should handle errors better than this
            let (data, _) = try await session.upload(for: request, from: sendData)

            return try await postParser!.parse(data: data)
        } else {
            throw WebRequestError.noParser("No encode parser yet push was requested.")
        }
    }

    // TODO: make this actually make requests with authentication
    func authPost(token: String) async throws -> GetParser.ParsedType {
        if getParser != nil {
            var request = HTTPRequest(method: .get, url: internalURL)
            request.headerFields[.userAgent] = "New WSO Mobile/1.2.0"
            request.headerFields[.accept] = getParser!.acceptType

            let (data, _) = try await session.data(for: request)
            return try await getParser!.parse(data: data)
        } else {
            throw WebRequestError.noParser("No decode parser yet fetch was requested.")
        }
    }

    // clear cache for all objects.
    func clearGlobalCache() {
        cache.removeAllCachedResponses()
    }

    // this clears the cache for this specific object.
    func clearCache() {
        cache.removeCachedResponse(for: URLRequest(url: internalURL))
    }
}

// a standard parser that deliberately fails.
// this is when you don't want to just use "nil" for a type.
// if you use this and use a method you're not supposed to, you're kind of a moron
struct NoParser: DataParser {
    typealias ParsedType = Never
    let acceptType = ""
    let contentType = ""
    func parse(data: Data) async throws -> Never {
        fatalError("no parser configured")
    }
}

// a standard parser for JSON data.
class JSONParser<T: Codable>: DataParser {
    typealias ParsedType = T

    let acceptType: String = "application/json"
    let contentType: String = "application/json"

    func parse(data: Data) async throws -> T  {
        let str = (String(data: data, encoding: .utf8) ?? "No data")
        print(str)
        let decoder = JSONDecoder()
        let decodedResponse = try decoder.decode(T.self, from: data)
        return decodedResponse
    }
}

// ONLY STANDARD, COMMONLY USED PARSERS SHOULD GO HERE!
// IF YOUR API NEEDS ANOTHER ONE, PUT IT WITH THAT,
// SO PEOPLE CAN QUICKLY DETERMINE WHERE THE ERROR COMES FROM!
