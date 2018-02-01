//
//  FUICustomAuthPickerViewController.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 1/23/18.
//  Copyright © 2018 Conner Christianson. All rights reserved.
//

import UIKit
import FirebaseAuthUI

class FUICustomAuthPickerViewController: FUIAuthPickerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 18, y: 70, width: UIScreen.main.bounds.width - 36, height: UIScreen.main.bounds.width - 36))
        imageView.image = #imageLiteral(resourceName: "grand champion")
        view.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
