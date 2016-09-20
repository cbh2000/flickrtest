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
 *
 * Sadly, there is no pinch to zoom, but you can rotate the phone into landscape.
 */
class ImageViewController: UIViewController {
    let imageView = UIImageView()
    let closeButton = UIButton()
    let spinner = UIActivityIndicatorView()
    
    convenience init(imageURL: URL) {
        self.init(nibName: nil, bundle: nil)
        setImage(with: imageURL)
    }
    
    func setImage(with url: URL) {
        imageView.sd_setImage(with: url)
        imageView.sd_setImage(with: url) { (image: UIImage?, _, _, _) in
            self.imageView.image = image
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: This doesn't work on the iOS 10 simulator, but it looks ok nonetheless.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Makes it fade in instead of sliding in.
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
        
        spinner.activityIndicatorViewStyle = .white
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
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
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "close"), for: [])
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        // Layout close button
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}
