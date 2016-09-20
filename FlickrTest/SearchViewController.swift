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
    var photos: [PhotoSearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionView!.register(PhotoCell.self, forCellWithReuseIdentifier: "photo")
        collectionView!.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "photo")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath) as! PhotoCellInterface
        
        let photo = photos[indexPath.row]
        cell.setImage(url: photo.previewImageURL)
        cell.setTitle(photo.title)
        
        return cell as! UICollectionViewCell
    }
    
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
                self.photos = searchResults.photos
                self.collectionView!.reloadData()
            case .failure(let error):
                print("Search error: \(error)")
            }
        }
    }
}

