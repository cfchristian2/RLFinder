//
//  TableViewCell.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 5/21/17.
//  Copyright © 2017 Conner Christianson. All rights reserved.
//

import UIKit

class PartnerPostHeader: UITableViewCell {

    @IBOutlet weak var tierIcon: UIImageView!
    @IBOutlet weak var tierName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
