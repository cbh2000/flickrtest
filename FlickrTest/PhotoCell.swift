//
//  PhotoCell.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import UIKit

protocol PhotoCellInterface: class {
    func setImage(_ image: UIImage)
    func setTitle(_ title: String)
}

extension PhotoCellInterface where Self: PhotoCell {
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

class PhotoCell: UICollectionViewCell, PhotoCellInterface {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.shadowColor = .black
        titleLabel.shadowOffset = .zero
        titleLabel.clipsToBounds = false
        titleLabel.layer.shadowRadius = 5
        
        contentView.backgroundColor = .lightGray
    }
}
