//
//  Response.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import Foundation

enum ResponseError: Error {
    case unknown
    case networkError
    case flickrError(description: String)
    case parseError(error: JSONInstantiationError)
    case notAuthorized
    case notFound
    case badRequest
}

extension ResponseError: LocalizedError {
    // Ideally, these strings are localized using localized.strings.
    var localizedDescription: String? {
        switch self {
        case .unknown:
            return "An unknown error has occurred."
        case .networkError:
            return "Failed to connect to Flickr. Are you connected to the Internet?"
        case .flickrError(let description):
            return "There was an error communicating with Flickr: \(description)"
        case .parseError(_):
            // The exact error message is likely *too* descriptive for most users.
            return "An error occurred while interpreting Flickr's response."
        case .notAuthorized:
            return "Not authorized."
        case .notFound:
            return "Not found."
        case .badRequest:
            return "Bad request."
        }
    }
}

// TODO: Extend ResponseError to conform to LocalizedError.
// TODO: Provide an easy way to display error popups to the user via ResponseError.

enum Response<T> {
    case success(body: T)
    case failure(error: ResponseError)
}
