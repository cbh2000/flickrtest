//
//  JSONInstantiatable.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import Foundation

// This is more of a developer help tool for debugging than it is a localized error for the user.
// The intention of this error is to not show it directly to the user, but merely print it in the logs.
enum JSONParseError: Error {
    case failedToParse(type: Any.Type, reason: String)
}

// In most apps, you'd have a toJSON() method too, but this app is so simple it doesn't need it.
protocol JSONInstantiatable {
    init(json: [String : Any]) throws
}
