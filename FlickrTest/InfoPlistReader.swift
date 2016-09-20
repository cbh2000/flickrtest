//
//  InfoPlistReader.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import Foundation

class InfoPlistReader {
    static let flickrAPIKey: String = {
        return getValue(key: "FlickrAPIKey", type: String.self, isValid: flickrAPIKeyValidator)
    }()
    
    static let flickrURL: URL = {
        let path = getValue(key: "FlickrAPIURL", type: String.self, isValid: flickerURLValidator)
        return URL(string: path)!
    }()
    
    fileprivate static func flickrAPIKeyValidator(_ key: String) -> Bool {
        let wholeString = key.startIndex..<key.endIndex
        let match = key.range(of: "([0-9]|[a-z]){32,32}", options: .regularExpression, range: wholeString, locale: nil)
        return match?.lowerBound == key.startIndex && match?.upperBound == key.endIndex
    }
    
    fileprivate static func flickerURLValidator(_ url: String) -> Bool {
        // There are probably better ways to validate, but this should catch the egregious errors.
        let url = URL(string: url)
        
        // The scheme must be https, because we haven't configured the app transport security settings yet.
        return url != nil && url?.scheme?.lowercased() == "https" && url?.host != nil
    }
    
    fileprivate static func getValue<T>(key: String, type: T.Type, isValid: (T) -> Bool = { _ in true }) -> T {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("The Info.plist is missing. The project is misconfigured.")
        }
        guard infoDictionary[key] != nil else {
            fatalError("The key, \(key), is missing from the Info.plist.")
        }
        guard let value = infoDictionary[key] as? T else {
            fatalError("The key, \(key), in the Info.plist, is the wrong type.")
        }
        guard isValid(value) else {
            fatalError("The key, \(key), in the Info.plist, failed validation (is in wrong format).")
        }
        return value
    }
}
