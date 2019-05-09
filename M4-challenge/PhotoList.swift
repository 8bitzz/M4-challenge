//
//  PhotoList.swift
//  M4-challenge
//
//  Created by Hang Nguyen on 5/9/19.
//  Copyright © 2019 8bitzz. All rights reserved.
//

import Foundation

class PhotoList {
    private(set) var list: [Photo] = []
    
    func add(newPhoto: Photo) {
        list.append(newPhoto)
    }
}
