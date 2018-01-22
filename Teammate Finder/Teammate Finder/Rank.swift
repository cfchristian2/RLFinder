//
//  Rank.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 11/15/17.
//  Copyright © 2017 Conner Christianson. All rights reserved.
//

import UIKit

class Rank: NSObject {
    var title: String!
    var icon: UIImage!
    var color: UIColor!
    var postType: String!
    
    init(title: String, icon: UIImage, color: UIColor, postType: String) {
        self.title = title
        self.icon = icon
        self.color = color
        self.postType = postType
    }
}
