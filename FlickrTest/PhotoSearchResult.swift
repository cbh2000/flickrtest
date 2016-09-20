//
//  PhotoSearchResult.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import Foundation

// Represents an individual photo in a search response.
struct PhotoSearchResult: JSONInstantiatable {
    let id: String
    let owner: String
    let title: String
    let previewImageURL: URL
    let fullSizeImageURL: URL
    
    fileprivate static func parseError(_ reason: String) -> JSONInstantiationError {
        return JSONInstantiationError.failedToParse(type: PhotoSearchResult.self, reason: reason)
    }
    
    init(json: [String : Any]) throws {
        //
        // For large apps, this approach to class serialization is tedious. But since this app is simple, it'll do.
        //
        
        guard let id = json["id"] as? String else {
            throw PhotoSearchResult.parseError("Failed to parse id.")
        }
        
        guard let owner = json["owner"] as? String else {
            throw PhotoSearchResult.parseError("Failed to parse owner.")
        }
        
        guard let title = json["title"] as? String else {
            throw PhotoSearchResult.parseError("Failed to parse title.")
        }
        
        self.id = id
        self.owner = owner
        self.title = title
        
        // Now, get the image URLs
        guard let farmID = json["farm"] as? Int, let serverID = json["server"] as? String else {
            throw PhotoSearchResult.parseError("Failed to parse farm or server.")
        }
        guard let secret = json["secret"] as? String else {
            throw PhotoSearchResult.parseError("Failed to parse secret.")
        }
        
        self.previewImageURL = URL(string: "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret)_q.jpg")!
        self.fullSizeImageURL = URL(string: "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret).jpg")!
    }
}
