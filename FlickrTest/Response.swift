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
    case permissionError
    case flickrError
}

// TODO: Extend ResponseError to conform to LocalizedError.

enum Response<T> {
    case success(body: T)
    case failure(error: ResponseError)
}
