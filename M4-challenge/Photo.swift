//
//  Photo.swift
//  M4-challenge
//
//  Created by Hang Nguyen on 5/9/19.
//  Copyright © 2019 8bitzz. All rights reserved.
//

import Foundation

class Photo: Codable {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
