//
//  WebRequest.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-12.
//

// meta-class that handles the oft-annoying task of fetching data over the internet.

import SwiftUI
import Foundation
import HTTPTypes
import HTTPTypesFoundation
import Logging

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
    case notFound                   // resource doesn't exist
    case noInternet                 // network unreachable
    case noToken                    // unable to authenticate
    case invalidResponse            // HTTP code was invalid
    case internalFailure            // parsing/data corruption/etc
    case noParser                   // internal parsing failure, don't show to users
    case parseError(DecodingError)  // error takes place inside the parsing step
    case unknown(Error)             // catch-all wrapper
}

extension WebRequestError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .notFound:
                return "Data not found on server."
            case .noInternet:
                return "No internet connection available."
            case .noToken:
                return "No token found for authentication, or token is invalid."
            case .invalidResponse:
                return "Invalid response from server."
            case .internalFailure:
                return "Failed to process data."
            case .noParser:
                return "Request was made yet no parser avaiable for it."
            case .parseError(let error):
                return "Error occured during parsing of data: \(error.localizedDescription)"
            case .unknown(let error):
                return "Unexpected error: \(error.localizedDescription)"
        }
    }
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
    fileprivate let logger = Logger(label: "com.wso.WebRequest")
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
    }

    func get() async throws -> GetParser.ParsedType {
        if getParser != nil {
            logger.info("Starting GET request to \(internalURL)")
            var request = HTTPRequest(method: .get, url: internalURL)
            request.headerFields[.userAgent] = "New WSO Mobile/1.2.2"
            request.headerFields[.accept] = getParser!.acceptType

            let (data, response) = try await session.data(for: request)
            guard let http = response as HTTPResponse?,
                  (200..<300).contains(http.status.code) else {
                logger.error("GET request to \(internalURL) failed due to invalid HTTP response: \(response.status)")
                throw WebRequestError.invalidResponse
            }
            logger.debug("GET success: the request HTTP status was \(response.status)")
            // don't print image data out to console!
            if !internalURL.absoluteString.contains(".jpg") {
                logger.debug("GET data: \(String(decoding: data, as: UTF8.self))")
            }
            do {
                logger.info("GET request to \(internalURL) completed")
                return try await getParser!.parse(data: data)
            } catch let decoding as DecodingError {
                throw WebRequestError.parseError(decoding)
            }
        } else {
            throw WebRequestError.noParser
        }
    }

    func authGet() async throws -> GetParser.ParsedType {
        if getParser != nil {
            logger.info("Starting GET (auth) request to \(internalURL)")
            var request = HTTPRequest(method: .get, url: internalURL)
            request.headerFields[.userAgent] = "New WSO Mobile/1.2.2"
            request.headerFields[.accept] = getParser!.acceptType

            // note to future maintainers: this is using the singleton,
            // not the environment object
            let token = try AuthManager.shared.getToken()
            //print(token)
            request.headerFields[.authorization] = "Bearer \(token)"

            let (data, response) = try await session.data(for: request)
            guard let http = response as HTTPResponse?,
                  (200..<300).contains(http.status.code) else {
                logger.error("GET (auth) request to \(internalURL) failed due to invalid HTTP response: \(response.status)")
                throw WebRequestError.invalidResponse
            }
            logger.debug("GET (auth) success: the request HTTP status was \(response.status)")
            // don't print image data out to console!
            if !internalURL.absoluteString.contains(".jpg") {
                logger.debug("GET (auth) data: \(String(decoding: data, as: UTF8.self))")
            }
            do {
                logger.info("GET (auth) request to \(internalURL) completed")
                return try await getParser!.parse(data: data)
            } catch let decoding as DecodingError {
                throw WebRequestError.parseError(decoding)
            }
        } else {
            throw WebRequestError.noParser
        }
    }

    func post(sendData: Data? = nil) async throws -> PostParser.ParsedType {
        if postParser != nil {
            logger.info("Starting POST request to \(internalURL)")
            var request = HTTPRequest(method: .post, url: internalURL)
            request.headerFields[.userAgent] = "New WSO Mobile/1.2.2"
            request.headerFields[.accept] = postParser!.acceptType
            request.headerFields[.contentType] = postParser!.contentType

            // for the case where we do have data
            if sendData != nil {
                let (data, response) = try await session.upload(for: request, from: sendData!)
                guard let http = response as HTTPResponse?,
                      (200..<300).contains(http.status.code) else {
                    logger.error("POST request to \(internalURL) failed due to invalid HTTP response: \(response.status)")
                    throw WebRequestError.invalidResponse
                }
                logger.debug("POST success: the request HTTP status was \(response.status)")
                logger.debug("POST data: \(String(decoding: data, as: UTF8.self))")
                do {
                    logger.info("POST request to \(internalURL) completed")
                    return try await postParser!.parse(data: data)
                } catch let decoding as DecodingError {
                    throw WebRequestError.parseError(decoding)
                }
            // we don't have a message body in this case!
            } else {
                let (data, response) = try await session.data(for: request)
                guard let http = response as HTTPResponse?,
                      (200..<300).contains(http.status.code) else {
                    logger.error("POST request to \(internalURL) failed due to invalid HTTP response: \(response.status)")
                    throw WebRequestError.invalidResponse
                }
                logger.debug("POST success: the request HTTP status was \(response.status)")
                logger.debug("POST data: \(String(decoding: data, as: UTF8.self))")
                do {
                    logger.info("POST request to \(internalURL) completed")
                    return try await postParser!.parse(data: data)
                } catch let decoding as DecodingError {
                    throw WebRequestError.parseError(decoding)
                }
            }
        } else {
            throw WebRequestError.noParser
        }
    }

    func authPost(sendData: Data? = nil) async throws -> PostParser.ParsedType {
        if postParser != nil {
            logger.info("Starting POST (auth) request to \(internalURL)")
            var request = HTTPRequest(method: .post, url: internalURL)
            request.headerFields[.userAgent] = "New WSO Mobile/1.2.2"
            request.headerFields[.accept] = postParser!.acceptType
            request.headerFields[.contentType] = postParser!.contentType

            let token = try AuthManager.shared.getToken()
            request.headerFields[.authorization] = "Bearer \(token)"

            // for the case where we do have data
            if sendData != nil {
                let (data, response) = try await session.upload(for: request, from: sendData!)
                guard let http = response as HTTPResponse?,
                      (200..<300).contains(http.status.code) else {
                    logger.error("POST (auth) request to \(internalURL) failed due to invalid HTTP response: \(response.status)")
                    throw WebRequestError.invalidResponse
                }
                logger.debug("POST (auth) success: the request HTTP status was \(response.status)")
                logger.debug("POST (auth) data: \(String(decoding: data, as: UTF8.self))")
                do {
                    logger.info("POST (auth) request to \(internalURL) completed")
                    return try await postParser!.parse(data: data)
                } catch let decoding as DecodingError {
                    throw WebRequestError.parseError(decoding)
                }
            // we don't have a message body in this case!
            } else {
                let (data, response) = try await session.data(for: request)
                guard let http = response as HTTPResponse?,
                      (200..<300).contains(http.status.code) else {
                    logger.error("POST (auth) request to \(internalURL) failed due to invalid HTTP response: \(response.status)")
                    throw WebRequestError.invalidResponse
                }
                logger.debug("POST (auth) success: the request HTTP status was \(response.status)")
                logger.debug("POST (auth) data: \(String(decoding: data, as: UTF8.self))")
                do {
                    logger.info("POST (auth) request to \(internalURL) completed")
                    return try await postParser!.parse(data: data)
                } catch let decoding as DecodingError {
                    throw WebRequestError.parseError(decoding)
                }
            }
        } else {
            throw WebRequestError.noParser
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
@available(macOS 14.0, *)
struct NoParser: DataParser {
    typealias ParsedType = Never
    let acceptType = ""
    let contentType = ""
    func parse(data: Data) async throws -> Never {
        fatalError("no parser configured")
    }
}

// a standard parser that just gives you the raw data.
struct RawParser: DataParser {
    typealias ParsedType = Data
    let acceptType = ""
    let contentType = ""
    func parse(data: Data) async throws -> Data {
        return data
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

// a parser for ISO8601-date JSON
class JSONISO8601Parser<T: Codable>: DataParser {
    typealias ParsedType = T

    let acceptType: String = "application/json"
    let contentType: String = "application/json"

    func parse(data: Data) async throws -> T  {
            //let str = (String(data: data, encoding: .utf8) ?? "No data")
            //print(str)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedResponse = try decoder.decode(T.self, from: data)
        return decodedResponse
    }
}

// ONLY STANDARD, COMMONLY USED PARSERS SHOULD GO HERE!
// IF YOUR API NEEDS ANOTHER ONE, PUT IT WITH THAT,
// SO PEOPLE CAN QUICKLY DETERMINE WHERE THE ERROR COMES FROM!
