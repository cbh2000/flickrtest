//
//  PhotoCell.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import UIKit
import WebImage

// This interface is here to isolate the cell from the view controller.
// It makes refactoring and reuse a bit easier since we can minimize
// what is used by the outside world.
protocol PhotoCellInterface: class {
    func setImage(url: URL)
    func setTitle(_ title: String)
}

extension PhotoCellInterface where Self: PhotoCell {
    func setImage(url: URL) {
        imageView.image = nil // In case it takes a while to come back, don't show the wrong one in the mean-time.
        imageView.sd_setImage(with: url)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

class PhotoCell: UICollectionViewCell, PhotoCellInterface {
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layer = titleLabel.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
    }
}
