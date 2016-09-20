//
//  ImageViewController.swift
//  FlickrTest
//
//  Created by Christopher Bryan Henderson on 9/20/16.
//  Copyright © 2016 Christopher Bryan Henderson. All rights reserved.
//

import UIKit

/**
 * Here, I decided to create the view controller programmatically, without the use of Storyboard.
 */
class ImageViewController: UIViewController {
    let imageView = UIImageView()
    let closeButton = UIButton()
    
    convenience init(imageURL: URL) {
        self.init(nibName: nil, bundle: nil)
        setImage(with: imageURL)
    }
    
    func setImage(with url: URL) {
        imageView.sd_setImage(with: url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: This doesn't work on the iOS 10 simulator, but it looks ok nonetheless.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Makes it fade in instead of sliding in.
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
        
        // Configure the image view.
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        // Required for programmatically created views or else auto-generated constrants will conflict with ours.
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Alternatively, you can create the NSLayoutConstraints directly, or just set the frames in view(Did|Will)LayoutSubviews.
        imageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // Configure the button.
        closeButton.setImage(UIImage(named: "close"), for: [])
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
    }
    
    func closeTapped() {
        
    }
}
