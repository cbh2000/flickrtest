//
//  ReadInfoPlist.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import Foundation

enum ReadInfoPlistError: Error {
    case missingInfoDictionary
    case missingInfoKey(key: String)
    case infoKeyIsInvalidType(key: String)
    case infoKeyFailedValidation(key: String)
}

extension ReadInfoPlistError: LocalizedError {
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

func readInfoPlist<T>(key: String, type: T.Type, isValid: (T) -> Bool = { _ in true }) throws -> T {
    guard let infoDictionary = Bundle.main.infoDictionary else {
        throw ReadInfoPlistError.missingInfoDictionary
    }
    guard infoDictionary[key] != nil else {
        throw ReadInfoPlistError.missingInfoKey(key: key)
    }
    guard let value = infoDictionary[key] as? T else {
        throw ReadInfoPlistError.infoKeyIsInvalidType(key: key)
    }
    guard isValid(value) else {
        throw ReadInfoPlistError.infoKeyFailedValidation(key: key)
    }
    return value
}
