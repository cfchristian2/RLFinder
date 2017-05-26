//
//  ViewController.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 5/10/17.
//  Copyright © 2017 Conner Christianson. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    let systems = ["PS4", "Xbox", "PC"]
    var currentRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return systems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currentRow = row
        return systems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPartnerPosts" {
            if let nextVC = segue.destination as? PartnerPostsController {
                nextVC.platform = systems[currentRow]
                nextVC.username = username.text
            }
        }
    }
}

