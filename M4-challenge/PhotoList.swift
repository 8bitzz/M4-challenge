//
//  PhotoList.swift
//  M4-challenge
//
//  Created by Hang Nguyen on 5/9/19.
//  Copyright © 2019 8bitzz. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker

class PhotoList: Codable {
    private(set) var list = [Photo]()
    
    func add(newphoto: Photo) {
        list.append(newphoto)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedPhotos = try? jsonEncoder.encode(self) {
            let defaults = UserDefaults.standard
            defaults.set(savedPhotos, forKey: "savedPhotos")
            defaults.synchronize()
        }
    }
}
