//
//  FlickrAPI.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import Foundation

class FlickrAPI {
    struct Methods {
        static let search = "flickr.photos.search"
    }
    
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
    
    // Appends the given items to the URL as query parameters.
    fileprivate func createURL(with items: [String : String]) -> URL {
        var components = URLComponents(url: apiBaseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = items.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        return components.url!
    }
    
    // Hits the search API.
    func search(text: String, completion: @escaping (Response<SearchResults>) -> Void) -> URLSessionTask {
        let url = createURL(with: ["method": Methods.search, "text": text])
        return makeRequest(httpMethod: "GET", url: url, converter: jsonResponseConverter, completion: completion)
    }
    
    fileprivate func jsonResponseConverter<T: JSONInstantiatable>(data: Data?, response: URLResponse?, error: Error?) -> Response<T> {
        // TODO: Work in progress.
        return Response<T>.failure(error: .networkError)
    }
    
    // Does not perform completion handler on main queue.
    fileprivate func makeRequest<T>(httpMethod: String, url: URL, converter: @escaping (Data?, URLResponse?, Error?) -> T, completion: @escaping (T) -> Void) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        // Strictly speaking, we tell Flickr which content type we want via the "format=json" URL param.
        // But this is here anyways just to be safe.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            completion(converter(data, response, error))
        }
        task.resume()
        return task
    }
}
