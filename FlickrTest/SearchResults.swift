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
    let pagesLeft: Int
    
    fileprivate static func parseError(_ reason: String) -> JSONInstantiationError {
        return JSONInstantiationError.failedToParse(type: SearchResults.self, reason: reason)
    }
    
    init(json: [String : Any]) throws {
        //
        // For large apps, this approach to class serialization is tedious. But since this app is simple, it'll do.
        //
        
        guard let photos = json["photos"] as? [String : Any] else {
            throw SearchResults.parseError("Missing photos key in JSON.")
        }
        
        guard let page = photos["page"] as? Int, let pages = photos["pages"] as? Int else {
            throw SearchResults.parseError("Missing page and/or pages in JSON.")
        }
        
        // If there are no search results, then page == 1 and pages == 0.
        pagesLeft = max(0, pages - page)
        
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
