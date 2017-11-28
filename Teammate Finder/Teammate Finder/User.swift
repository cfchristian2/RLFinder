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
    
    let uid: String
    
    var email: String?
    
    var platforms: [String : String]?
    
    var usernames: [String : String]?
    
    init(uid: String) {
        self.uid = uid
    }
    
    static func loadUser(uid: String) {
        let ref = Database.database().reference()
        //ref.child("users").child(uid).observeSingleEvent(of: .value, with: <#T##(DataSnapshot) -> Void#>)
    }
}
