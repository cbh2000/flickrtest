//
//  FlickrAPI.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import Foundation

class FlickrAPI {
    static let shared = FlickrAPI()
    
    let apiKey: String
    let apiBaseURL: URL
    
    init() {
        do {
            apiKey = try InfoPlistReader.getValue(key: "FlickrAPIKey", type: String.self, isValid: InfoPlistReader.flickrAPIKeyValidator)
            let url = try InfoPlistReader.getValue(key: "FlickrAPIURL", type: String.self, isValid: InfoPlistReader.flickerURLValidator)
            apiBaseURL = URL(string: url)!
        } catch let error as InfoPlistReaderError {
            fatalError("\(FlickrAPI.self): Failed to instantiate: \(error.localizedDescription), reason: \(error.failureReason)")
        } catch let error {
            fatalError("\(FlickrAPI.self): Failed to instantiate: \(error)")
        }
    }
    
    //private func performMethod<T>(method: String, completion: (response: Response<T>) -> Void) -> URLSessionTask {
    //
    //}
}
