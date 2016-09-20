//
//  SearchViewController.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import UIKit

class SearchViewController: UICollectionViewController, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    var searchRequest: URLSessionTask?
    var photos: [PhotoSearchResult] = []
    var hasSetSize = false
    
    var layout: UICollectionViewFlowLayout {
        return collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "photo")
        
        // TODO: Testing needs to be performed on this to make sure it works on all iOS versions.
        // I distinctly remember cases where the size of the view controller's view at this point
        // was 600x600 and not the physical display size until *after* viewDidLoad was called.
        // But this seems to work well on the simulator.
        layout.itemSize = calculatePhotoSize()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // Save the "middle" photo and then scroll to it after rotating to prevent losing the user's position.
        // This is necessary because the photos can change size upon rotation, which messes up the scroll position.
        let pinpoint: IndexPath?
        let visible = collectionView!.indexPathsForVisibleItems
        if !visible.isEmpty {
            pinpoint = visible[Int(visible.count / 2)]
        } else {
            pinpoint = nil
        }
        
        // This animates the transition, but it could be smoother.
        // Ideally, it fades into the newly laid out frames instead of
        // interpolating between the two.
        coordinator.animate(alongsideTransition: { (context) in
            
            // Update the photo size.
            let photoSize = self.calculatePhotoSize()
            if self.layout.itemSize != photoSize {
                self.layout.itemSize = photoSize
            }
            
            // Re-scroll to keep the user's position.
            if let pinpoint = pinpoint {
                self.collectionView!.scrollToItem(at: pinpoint, at: UICollectionViewScrollPosition.centeredVertically, animated: false)
            }
            }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
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
    
    // Given the screen's size, determine the optimal photo size, while taking up all available space.
    // This should work well for both iPhones and iPads.
    //
    // If you wish to tweak the spacing, tweak the collection view layout's insets and inter-item spacing.
    func calculatePhotoSize() -> CGSize {
        let collectionView = self.collectionView!
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let availableWidth = collectionView.frame.width - layout.sectionInset.left - layout.sectionInset.right
        let preferredSize: CGFloat = 250
        
        let maxAcross = floor(availableWidth / (preferredSize + layout.minimumInteritemSpacing))
        if maxAcross <= 1 {
            // Somehow we are running on a device with a screen smaller than a 4s. Just use what space we have.
            return CGSize(width: availableWidth, height: availableWidth)
        }
        
        let availableForPhotos = availableWidth - layout.minimumInteritemSpacing * (maxAcross - 1)
        let widthOfEach = floor(availableForPhotos / maxAcross)
        return CGSize(width: widthOfEach, height: widthOfEach) // 1:1 aspect ratio
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Text did change:", searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button clicked")
        
        // Dismiss the keyboard so that the user can see more photos.
        searchBar.resignFirstResponder()
        
        // Don't allow race conditions if the user spams the search button.
        searchRequest?.cancel()
        
        searchRequest = FlickrAPI.shared.search(text: searchBar.text ?? "") { response in
            switch response {
            case .success(let searchResults):
                self.photos = searchResults.photos
                self.collectionView!.reloadData()
            case .failure(let error):
                // TODO: Display the error.
                print("Search error: \(error)")
            }
        }
    }
}

