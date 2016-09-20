//
//  InfoPlistReader.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import Foundation

/**
 Swift 3 merged NSError and Swift's native Error protocol.
 
 Here, I experiment with the new Error protocol, LocalizedError, to provide better error reporting. Specifically,
 to allow for better localization.
 
 Normally, you'd do this for classes that interface with the user, like UIKit subclasses, so perhaps
 the benefit is limited in this particular file.
 */

enum InfoPlistReaderError: Error {
    case missingInfoDictionary
    case missingInfoKey(key: String)
    case infoKeyIsInvalidType(key: String)
    case infoKeyFailedValidation(key: String)
}

extension InfoPlistReaderError: LocalizedError {
    var errorDescription: String? {
        return "The Info.plist is not configured properly."
    }
    
    var failureReason: String? {
        switch self {
        case .missingInfoDictionary:
            return "The Info.plist is missing. The project is misconfigured."
        case .missingInfoKey(let key):
            return "The key, \(key), is missing from the Info.plist, and is required for this app to function properly."
        case .infoKeyIsInvalidType(let key):
            return "The key, \(key), in the Info.plist, is the wrong type."
        case .infoKeyFailedValidation(let key):
            return "The key, \(key), in the Info.plist, failed validation (is in wrong format)."
        }
    }
}

class InfoPlistReader {
    static func flickrAPIKeyValidator(_ key: String) -> Bool {
        let wholeString = key.startIndex..<key.endIndex
        let match = key.range(of: "([0-9]|[a-z]){32,32}", options: .regularExpression, range: wholeString, locale: nil)
        return match?.lowerBound == key.startIndex && match?.upperBound == key.endIndex
    }
    
    static func flickerURLValidator(_ url: String) -> Bool {
        // There are probably better ways to validate, but this should catch the egregious errors.
        let url = URL(string: url)
        
        // The scheme must be https, because we haven't configured the app transport security settings yet.
        return url != nil && url?.scheme?.lowercased() == "https" && url?.host != nil
    }
    
    static func getValue<T>(key: String, type: T.Type, isValid: (T) -> Bool = { _ in true }) throws -> T {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            throw InfoPlistReaderError.missingInfoDictionary
        }
        guard infoDictionary[key] != nil else {
            throw InfoPlistReaderError.missingInfoKey(key: key)
        }
        guard let value = infoDictionary[key] as? T else {
            throw InfoPlistReaderError.infoKeyIsInvalidType(key: key)
        }
        guard isValid(value) else {
            throw InfoPlistReaderError.infoKeyFailedValidation(key: key)
        }
        return value
    }
}
