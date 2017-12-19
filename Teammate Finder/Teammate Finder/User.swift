//
//  User.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 11/27/17.
//  Copyright © 2017 Conner Christianson. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject, NSCoding {
    
    static var currentUser: User?
    
    var uid: String?
    
    var email: String?
    
    var platform: String?
    
    var username: String?
    
    init(uid: String) {
        super.init()
        self.uid = uid
    }
    
    func encode(with aCoder: NSCoder) {
        //aCoder.encode(name, forKey: "name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
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
    
    // Save user properties in UserDefaults
    static func archiveCurrentUser() {
        let data = NSKeyedArchiver.archivedData(withRootObject: User.currentUser!)
        UserDefaults.standard.set(data, forKey: "currentUser")
    }
    
    // Load user properties from UserDefaults, returns true if current user exists in storage
    static func unarchiveCurrentUser() -> Bool {
        if let data = UserDefaults.standard.object(forKey: "currentUser") as? NSData {
            User.currentUser = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? User
            return true
        }
        return false
    }
    
    // Remove current user from UserDefaults, called when user logs out
    static func logOutCurrentUser() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        User.currentUser = nil
        
    }
}
