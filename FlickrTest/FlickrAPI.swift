//
//  FlickrAPI.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import Foundation

fileprivate func validateFlickrAPIKey(_ key: String) -> Bool {
    let wholeString = key.startIndex..<key.endIndex
    let match = key.range(of: "([0-9]|[a-z]){32,32}", options: .regularExpression, range: wholeString, locale: nil)
    return match?.lowerBound == key.startIndex && match?.upperBound == key.endIndex
}

fileprivate func validateFlickrURL(_ url: String) -> Bool {
    // There are probably better ways to validate, but this should catch the egregious errors.
    let url = URL(string: url)
    
    // The scheme must be https, because we haven't configured the app transport security settings yet.
    return url != nil && url?.scheme?.lowercased() == "https" && url?.host != nil
}

class FlickrAPI {
    static let shared = FlickrAPI()
    
    let apiKey: String
    let apiBaseURL: URL
    
    init() {
        do {
            apiKey = try readInfoPlist(key: "FlickrAPIKey", type: String.self, isValid: validateFlickrAPIKey)
            let url = try readInfoPlist(key: "FlickrAPIURL", type: String.self, isValid: validateFlickrURL)
            apiBaseURL = URL(string: url)!
        } catch let error as ReadInfoPlistError {
            fatalError("\(FlickrAPI.self): Failed to instantiate: \(error.localizedDescription), reason: \(error.failureReason)")
        } catch let error {
            fatalError("\(FlickrAPI.self): Failed to instantiate: \(error)")
        }
    }
    
    //private func performMethod<T>(method: String, completion: (response: Response<T>) -> Void) -> URLSessionTask {
    //
    //}
}
