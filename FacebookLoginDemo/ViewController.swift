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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
