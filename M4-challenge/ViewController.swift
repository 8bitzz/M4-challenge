//
//  ViewController.swift
//  M4-challenge
//
//  Created by Hang Nguyen on 5/7/19.
//  Copyright © 2019 8bitzz. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

class ViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Gallery"
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        return cell
    }

}

