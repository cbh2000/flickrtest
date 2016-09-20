//
//  SearchViewController.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import UIKit

class SearchViewController: UICollectionViewController, UISearchBarDelegate {
    var searchRequest: URLSessionTask?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Text did change:", searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button clicked")
        
        // Don't allow race conditions if the user spams the search button.
        searchRequest?.cancel()
        
        searchRequest = FlickrAPI.shared.search(text: searchBar.text ?? "") { response in
            switch response {
            case .success(let searchResults):
                print("Search success: \(searchResults)")
            case .failure(let error):
                print("Search error: \(error)")
            }
        }
    }
}

