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
        
        updatePhotoSize()
    }
    
    // NOTE: This is a workaround for when the image viewer rotates after being presented. That means
    // when we re-appear our item size will be wrong.
    //
    // TODO: Make this a smoother transition.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updatePhotoSize()
    }
    
    func updatePhotoSize() {
        let size = calculatePhotoSize()
        if layout.itemSize != size {
            layout.itemSize = size
            layout.invalidateLayout()
        }
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
            
            self.updatePhotoSize()
            
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
        cell.setImage(with: photo.previewImageURL)
        cell.setTitle(photo.title)
        
        return cell as! UICollectionViewCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let imageViewer = ImageViewController(imageURL: photo.fullSizeImageURL)
        present(imageViewer, animated: true)
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
                self.present(error.createAlert(title: "Search Error"), animated: true)
            }
        }
    }
}

