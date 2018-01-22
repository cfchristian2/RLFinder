//
//  PartnerPost.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 5/23/17.
//  Copyright © 2017 Conner Christianson. All rights reserved.
//

import UIKit

class PartnerPost: UITableViewCell {
    

    @IBOutlet weak var postBody: UITextField!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var gameType: UILabel!
    var postId: String!
    var username: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
