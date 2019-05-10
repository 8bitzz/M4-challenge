//
//  Photo.swift
//  M4-challenge
//
//  Created by Hang Nguyen on 5/9/19.
//  Copyright © 2019 8bitzz. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker

class Photo: Codable {
    
    let libraryPhoto: LibraryPhoto?
    private(set) var unplashPhoto: UnsplashPhoto?
    
    init(libraryPhoto: LibraryPhoto?, unplashPhoto: UnsplashPhoto?) {
        self.libraryPhoto = libraryPhoto
        self.unplashPhoto = unplashPhoto
    }
    
    func update(newphoto: UnsplashPhoto) {
        unplashPhoto = newphoto
    }
    
}


