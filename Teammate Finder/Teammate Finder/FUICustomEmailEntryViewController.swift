//
//  FUICustomEmailEntryViewController.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 1/17/18.
//  Copyright © 2018 Conner Christianson. All rights reserved.
//

import UIKit
import FirebaseAuthUI

class FUICustomEmailEntryViewController: FUIEmailEntryViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onNext(_ emailText: String) {
        print(emailText)
    }
}

