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

// TODO: Extend ResponseError to conform to LocalizedError.
// TODO: Provide an easy way to display error popups to the user via ResponseError.

enum Response<T> {
    case success(body: T)
    case failure(error: ResponseError)
}
