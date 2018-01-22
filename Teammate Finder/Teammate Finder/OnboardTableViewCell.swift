//
//  OnboardTableViewCell.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 1/8/18.
//  Copyright © 2018 Conner Christianson. All rights reserved.
//

import UIKit
import Firebase

protocol OnboardTableViewCellDelegate: class {
    func didTapLogOut()
}

class OnboardTableViewCell: UITableViewCell {
    
    weak var cellDelegate: OnboardTableViewCellDelegate?
    
    @IBAction func onboardAction(_ sender: Any) {
        cellDelegate?.didTapLogOut()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
