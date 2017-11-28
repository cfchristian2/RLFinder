//
//  ViewController.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 5/10/17.
//  Copyright © 2017 Conner Christianson. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class WelcomeController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, FBSDKLoginButtonDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    let systems = ["PS4", "Xbox", "PC"]
    var currentRow = 0
    let loginButton = FBSDKLoginButton()
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        picker.delegate = self
        picker.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil) {
            let storyboard: UIStoryboard = UIStoryboard(name: "PartnerPosts", bundle: nil)
            let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "PostsNavigation") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        if result.isCancelled {
            return
        }
        
        ref = Database.database().reference()
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            let userId = (Auth.auth().currentUser?.uid)!
            self.ref.child("Login").observeSingleEvent(of: .value, with: {(snapshot) in
                
                if snapshot.hasChild(userId) {
                    // Already has account, go to posts
                    
                }
                else {
                    // Potentially go to a user edit page?
                    // For now, every user new or existing will go to posts page
                    self.ref.child("users").setValue(userId)
                }
                
                let storyboard: UIStoryboard = UIStoryboard(name: "PartnerPosts", bundle: nil)
                let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "PostsNavigation") as! UINavigationController
                self.present(vc, animated: true, completion: nil)
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return systems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currentRow = row
        return systems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPartnerPosts" {
            if let nextVC = segue.destination as? PartnerPostsController {
                nextVC.platform = systems[currentRow]
                nextVC.username = username.text
            }
        }
    }
}

