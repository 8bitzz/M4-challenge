//
//  PhotoCell.swift
//  M4-challenge
//
//  Created by Hang Nguyen on 5/9/19.
//  Copyright © 2019 8bitzz. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    private var imageDataTask: URLSessionDataTask?
    private static var cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "unsplash")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        self.imageView.layer.borderWidth = 2
        self.imageView.layer.cornerRadius = 3
        self.layer.cornerRadius = 7
    }
    
    private func downloadPhoto(_ photo: UnsplashPhoto) {
        self.label.text = "#unsplash"
        guard let url = photo.urls[.regular] else { return }
        
        if let cachedResponse = PhotoCell.cache.cachedResponse(for: URLRequest(url: url)),
            let image = UIImage(data: cachedResponse.data) {
            imageView.image = image
            return
        }
        
        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let strongSelf = self else { return }
            
            strongSelf.imageDataTask = nil
            guard let data = data, let image = UIImage(data: data), error == nil else { return }
            
            DispatchQueue.main.async {
                UIView.transition(with: strongSelf.imageView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    strongSelf.imageView.image = image
                }, completion: nil)
            }
        }
        imageDataTask?.resume()
    }
    
    func configureCell(with photo: Photo) {
        if let unplashPhoto = photo.unplashPhoto {
            self.downloadPhoto(unplashPhoto)
        }
        if let libraryPhoto = photo.libraryPhoto {
            self.label.text = libraryPhoto.name
            let path = getDocumentsDirectory().appendingPathComponent(libraryPhoto.imageName)
            self.imageView.image = UIImage(contentsOfFile: path.path)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
}
