//
//  PostDetailsViewController.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 1/31/18.
//  Copyright © 2018 Conner Christianson. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    var gameType: String!
    var date: TimeInterval!
    var postBody: String!
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
