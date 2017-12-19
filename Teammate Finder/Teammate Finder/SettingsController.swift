//
//  SettingsControllerLoggedIn.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 12/4/17.
//  Copyright © 2017 Conner Christianson. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, FBSDKLoginButtonDelegate {

    @IBOutlet weak var settingsTable: UITableView!
    var ref: DatabaseReference!
    
    // Facebook login button
    let loginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        navigationController?.title = "Settings"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------------------------------------//
    // MARK: Facebook login/logout
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        if result.isCancelled {
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            let userId = (Auth.auth().currentUser?.uid)!
            self.ref.child("users").observeSingleEvent(of: .value, with: {(snapshot) in
                
                if snapshot.hasChild(userId) {
                    // Already has account, load user and go to posts
                    User.loadUser(uid: userId)
                    print("\n\nUSER EXISTS\n\n")
                }
                else {
                    // Create user in Firebase, set current user and then go to posts page
                    User.currentUser = User(uid: userId)
                    User.currentUser?.email = user?.email
                    User.currentUser?.uid = user?.uid
                    User.archiveCurrentUser()
                    self.ref.child("users").setValue(userId)
                }
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        do {
            try Auth.auth().signOut()
            User.logOutCurrentUser()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    //-------------------------------------------------------------------------------------------//
    // MARK: Settings tableview delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
