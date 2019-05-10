//
//  ViewController.swift
//  M4-challenge
//
//  Created by Hang Nguyen on 5/7/19.
//  Copyright © 2019 8bitzz. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UnsplashPhotoPickerDelegate {
    
    private(set) var photos = PhotoList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Gallery"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        let defaults = UserDefaults.standard
        if let savedPhotos = defaults.object(forKey: "savedPhotos") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                photos = try jsonDecoder.decode(PhotoList.self, from: savedPhotos)
            } catch {
                print("Unable to load data")
            }
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.list.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        let photo = photos.list[indexPath.item]
        cell.configureCell(with: photo)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete photo", message: "This photo will be no longer in your Gallery.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { [weak self] action in
            self?.photos.remove(at: indexPath.item)
            self?.photos.save()
            self?.collectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc func addButtonTapped() {
        let alert = UIAlertController(title: "", message: "Add new photos from", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Unsplash", style: .default, handler: {(action: UIAlertAction) in
            self.getUnsplashImage()
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let pickerController = UIImagePickerController()
            pickerController.allowsEditing = true
            pickerController.delegate = self
            pickerController.sourceType = sourceType
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func getUnsplashImage() {
        let configuration = UnsplashPhotoPickerConfiguration(
            accessKey: "24ef216305fa0581533212861ad725e739a7892330907ddd52a8a34a08e69125",
            secretKey: "de8b3b6cf74bec62b2d24a3a23c665eb3c2ba4ee7d56ace6fbfb5300109d5221"
        )
        let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
        unsplashPhotoPicker.photoPickerDelegate = self
        present(unsplashPhotoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let libraryPhoto = LibraryPhoto(name: "#collection", imageName: imageName)
        let newphoto = Photo(libraryPhoto: libraryPhoto, unplashPhoto: nil)
        self.photos.add(newphoto: newphoto)
        photos.save()
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //// MARK: - UnsplashPhotoPickerDelegate
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        print("Unsplash photo picker did select photo(s)")
        guard let unsplashPhoto = photos.first else {return}
        let newphoto = Photo(libraryPhoto: nil, unplashPhoto: unsplashPhoto)
        self.photos.add(newphoto: newphoto)
        self.photos.save()
        self.collectionView.reloadData()
    }
    
    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        print("Unsplash photo picker did cancel")
    }

}




