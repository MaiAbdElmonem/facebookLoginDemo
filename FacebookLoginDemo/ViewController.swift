//
//  ViewController.swift
//  FacebookLoginDemo
//
//  Created by Mai Abd Elmonem on 11/24/19.
//  Copyright © 2019 Mai Abd Elmonem. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SDWebImage


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     var db: Firestore!
    var imagePickerController = UIImagePickerController()
    var selected : Int?
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
         db = Firestore.firestore()
        profilePhoto.makeRounded()
        getCollection()
        coverimageGesture()
        profileimageGesture()
    }
    
    func coverimageGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverPhototapped))
        coverPhoto.addGestureRecognizer(tap)
    }
    
    func profileimageGesture() {
           let tap = UITapGestureRecognizer(target: self, action: #selector(profilePhototapped))
           profilePhoto.addGestureRecognizer(tap)
       }
    
    @objc func profilePhototapped()
       {
           self.showAlert()
       }
    
    func showAlert() {
        imagePickerController.delegate = self
               let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
               alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
                   self.openCamera()
               }))
               alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
                   self.openGallery()
               }))
               alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
    }
    
    @objc func coverPhototapped()
    {
        selected = 1
        self.showAlert()
    }
    
    func openCamera(){
        self.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func openGallery(){
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
           imagePickerController.sourceType = .savedPhotosAlbum
           imagePickerController.allowsEditing = true
           
           present(imagePickerController, animated: true, completion: nil)
       }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           picker.dismiss(animated: true, completion: nil)
           let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if selected == 1 {
            coverPhoto.image = image
            self.uploadImage(self.coverPhoto.image!)
        }else {
            profilePhoto.image = image
            self.uploadImage(self.profilePhoto.image!)
        }
          dismiss(animated: true, completion: nil)
       }
    
     func getCollection() {
           db.collection("Profiles").getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                
                if let snapshot = querySnapshot {

                               for document in snapshot.documents {

                                   let data = document.data()
                                   let name = data["name"] as? String ?? ""
                                   let email = data["email"] as? String ?? ""
                                   let coverImage = data["coverPhoto"] as? String ?? ""
                                   let profilePhoto = data["profileImage"] as? String ?? ""
                                self.nameLabel.text = name
                                self.emailLabel.text = email
                                let placeholderimage = #imageLiteral(resourceName: "apple")
                                self.coverPhoto.sd_setImage(with: URL(string: coverImage), placeholderImage: placeholderimage)
                                self.coverPhoto.roundCorners(corners: [.topLeft, .topRight], radius: 25)
                                self.profilePhoto.sd_setImage(with: URL(string: profilePhoto), placeholderImage: placeholderimage)
                               }
               }
           }
       }
    }
    
   
    
    @IBAction func loginAction(_ sender: UIButton) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
               if let error = error {
                   print("Failed to login: \(error.localizedDescription)")
                   return
               }
               
            guard let accessToken = AccessToken.current else {
                   print("Failed to get access token")
                   return
               }
        
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
               
               // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                   if let error = error {
                       print("Login error: \(error.localizedDescription)")
                       let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                       let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                       alertController.addAction(okayAction)
                       self.present(alertController, animated: true, completion: nil)
                       
                       return
                   
    }
    
//if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
//                UIApplication.shared.keyWindow?.rootViewController = viewController
//                self.dismiss(animated: true, completion: nil)
//            }
            
        })
 
    }
  }
}

extension ViewController {
    func uploadImage(_ image: UIImage) {
       
        let storageRef = Storage.storage().reference().child("images")
        guard let imageData = coverPhoto.image?.jpegData(compressionQuality: 0.8)! else { return }
        storageRef.putData(imageData, metadata: nil) { (metaData, error) in
            guard metaData != nil else {
               return
             }
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("error")
                        return
                    }
                    print(downloadURL.absoluteString)

        }
    }
  }
}

