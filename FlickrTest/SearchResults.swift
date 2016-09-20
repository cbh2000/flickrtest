//
//  SearchResults.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import Foundation

struct SearchResults: JSONInstantiatable {
    let photos: [PhotoSearchResult]
    let atEnd: Bool
    
    fileprivate static func parseError(_ reason: String) -> JSONParseError {
        return JSONParseError.failedToParse(type: SearchResults.self, reason: reason)
    }
    
    init(json: [String : Any]) throws {
        guard let photos = json["photos"] as? [String : Any] else {
            throw SearchResults.parseError("Missing photos key in JSON.")
        }
        
        guard let page = photos["page"] as? Int, let pages = photos["pages"] as? Int else {
            throw SearchResults.parseError("Missing page and/or pages in JSON.")
        }
        
        // Can't do page == pages, because if there are no search results, then page == 1 and pages == 0.
        atEnd = page >= pages
        
        guard let photoList = photos["photo"] as? [[String : Any]] else {
            throw SearchResults.parseError("Missing photo list in JSON.")
        }
        
        var parsedPhotos: [PhotoSearchResult] = []
        for photoJSON in photoList {
            let photoItem = try PhotoSearchResult(json: photoJSON)
            parsedPhotos.append(photoItem)
        }
        self.photos = parsedPhotos
    }
}
