//
//  User.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 11/27/17.
//  Copyright © 2017 Conner Christianson. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    static var currentUser: User?
    
    var uid: String?
    
    var email: String?
    
    var platform: String?
    
    var username: String?
    
    init(uid: String) {
        self.uid = uid
    }
    
    static func loadUser(uid: String) {
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String : Any]
            User.currentUser = User(uid: uid)
            User.currentUser?.email = value?["email"] as? String ?? ""
            User.currentUser?.platform = value?["platform"] as? String ?? ""
            User.currentUser?.username = value?["username"] as? String ?? ""
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func archiveCurrentUser() {
        let data = NSKeyedArchiver.archivedData(withRootObject: User.currentUser!)
        UserDefaults.standard.set(data, forKey: "currentUser")
    }
    
    static func unarchiveCurrentUser() {
        if let data = UserDefaults.standard.object(forKey: "currentUser") as? Data {
            User.currentUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User
        }
    }
}
