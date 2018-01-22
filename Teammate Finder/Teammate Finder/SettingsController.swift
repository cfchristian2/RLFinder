//
//  SettingsControllerLoggedIn.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 12/4/17.
//  Copyright © 2017 Conner Christianson. All rights reserved.
//

import UIKit
import Firebase

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsTable: UITableView!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        navigationController?.title = "Settings"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------------------------------------//
    // MARK: Settings tableview delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch(indexPath.row) {
        case 0:
            cell = settingsTable.dequeueReusableCell(withIdentifier: "username") ?? UITableViewCell()
            cell.detailTextLabel?.text = User.currentUser?.username ?? ""
        case 1:
            cell = settingsTable.dequeueReusableCell(withIdentifier: "email") ?? UITableViewCell()
            cell.detailTextLabel?.text = User.currentUser?.email ?? ""
        case 2:
            if let onboardCell = settingsTable.dequeueReusableCell(withIdentifier: "onboard") as? OnboardTableViewCell {
                onboardCell.cellDelegate = self
                cell = onboardCell
            } else {
                cell = UITableViewCell()
            }
        default:
            cell = UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension SettingsController: OnboardTableViewCellDelegate {
    func didTapLogOut() {
        logOut()
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            User.logOutCurrentUser()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
}
