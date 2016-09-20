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
    
    let apiKey = InfoPlistReader.flickrAPIKey
    let apiBaseURL = InfoPlistReader.flickrURL
    
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
        let url = createURL(with: ["method": Methods.search, "text": text, "format": "json", "api_key": apiKey, "per_page": "25", "nojsoncallback": "1"])
        return makeRequest(httpMethod: "GET", url: url, converter: jsonResponseConverter, completion: completion)
    }
    
    // Given a raw data response from URLSession, creates a Response<T> object and serializes into a proper object.
    fileprivate func jsonResponseConverter<T: JSONInstantiatable>(data: Data?, response: URLResponse?, error: Error?) -> Response<T> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(error: .networkError)
        }
        
        switch httpResponse.statusCode {
        case 100...199:
            return .failure(error: .unknown)
        case 200...299:
            guard let data = data else {
                return .failure(error: .flickrError(description: "Missing data response."))
            }
            
            // JSON into Any
            let jsonObject: Any
            do {
                jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            } catch let error {
                return .failure(error: .flickrError(description: "Invalid JSON: \(error)"))
            }
            
            // Any into [String : Any]
            guard let jsonDictionary = jsonObject as? [String : Any] else {
                return .failure(error: .flickrError(description: "Expected JSON dictionary, got \(type(of: jsonObject)) instead."))
            }
            
            // [String : Any] into T
            let serialized: T
            do {
                serialized = try T.init(json: jsonDictionary)
            } catch let error as JSONInstantiationError {
                return .failure(error: .parseError(error: error))
            } catch let error {
                return .failure(error: .parseError(error: JSONInstantiationError.failedToParse(type: T.self, reason: error.localizedDescription)))
            }
            
            return .success(body: serialized)
        case 300...399:
            return .failure(error: .unknown)
        case 401:
            return .failure(error: .notAuthorized)
        case 404:
            return .failure(error: .notFound)
        case 400...499:
            return .failure(error: .badRequest)
        case 500...599:
            return .failure(error: .flickrError(description: "Server error."))
        default:
            return .failure(error: .unknown)
        }
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
            // If the request is cancelled, don't execute the completion handler at all.
            guard (error as? NSError)?.code != NSURLErrorCancelled else {
                return
            }
            
            // Convert now while we're still on a worker queue.
            let converted = converter(data, response, error)
            
            // This is likely being consumed by a UIKit class, so we should put it on the main queue.
            DispatchQueue.main.async {
                completion(converted)
            }
        }
        task.resume()
        return task
    }
}
