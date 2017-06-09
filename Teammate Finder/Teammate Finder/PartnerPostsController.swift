//
//  UserController.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 5/19/17.
//  Copyright © 2017 Conner Christianson. All rights reserved.
//
//  Images of ranks created by reddit.com/u/Davato
//

import UIKit
import Firebase

class PartnerPostsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var postsTable: UITableView!
    var platform: String!
    var username: String!
    var ref: FIRDatabaseReference!
    
    // This storage will probably change once database is implemented
    var bronzePosts: Dictionary<String, Any> = [:]
    var silverPosts: Dictionary<String, Any> = [:]
    var goldPosts: Dictionary<String, Any> = [:]
    var platinumPosts: Dictionary<String, Any> = [:]
    var diamondPosts: Dictionary<String, Any> = [:]
    var championPosts: Dictionary<String, Any> = [:]
    var grandChampPosts: Dictionary<String, Any> = [:]
    
    // Addressing post dicts by section number
    var sections: [Dictionary<String, Any>]!
    
    // Section collapsed or not
    var isHidden = [true, true, true, true, true, true, true]
    
    // Floating button used when user wants to make a post
    var floatingButtonIsVisible = true
    var floatingButtonView: UIImageView!
    var lastContentOffset: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.isHidden = true
        ref = FIRDatabase.database().reference()
        
        // TEST
        bronzePosts["Post1"] = "I NEED PARTNER"
        bronzePosts["Post2"] = "I NEED PARTNER"
        bronzePosts["Post3"] = "I NEED PARTNER"
        
        
        postsTable.delegate = self
        postsTable.dataSource = self
        
        sections = [bronzePosts, silverPosts, goldPosts, platinumPosts, diamondPosts, championPosts, grandChampPosts]
        
        floatingButtonView = UIImageView(frame: CGRect(x:self.view.frame.maxX-90, y:self.view.frame.maxY-90, width:70, height:70))
        floatingButtonView.image = #imageLiteral(resourceName: "addButton")
        floatingButtonView.layer.cornerRadius = floatingButtonView.frame.size.height/2
        floatingButtonView.clipsToBounds = true
        floatingButtonView.isUserInteractionEnabled = true
        floatingButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toCreatePost)))
        view.addSubview(floatingButtonView)
        
        getRocketLeagueStats()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            if isHidden[section] {
                return 0
            } else {
                return bronzePosts.count
            }
        case 1:
            if isHidden[section] {
                return 0
            } else {
                return silverPosts.count
            }
        case 2:
            if isHidden[section] {
                return 0
            } else {
                return goldPosts.count
            }
        case 3:
            if isHidden[section] {
                return 0
            } else {
                return platinumPosts.count
            }
        case 4:
            if isHidden[section] {
                return 0
            } else {
                return diamondPosts.count
            }
        case 5:
            if isHidden[section] {
                return 0
            } else {
                return championPosts.count
            }
        case 6:
            if isHidden[section] {
                return 0
            } else {
                return grandChampPosts.count
            }
        default:
            return 4
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122.0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = postsTable.dequeueReusableCell(withIdentifier: "PostHeader") as! PartnerPostHeader
        
        switch (section) {
        case 0:
            headerCell.tierName.text = "BRONZE TIER"
            headerCell.tierIcon.image = #imageLiteral(resourceName: "bronze3")
        case 1:
            headerCell.tierName.text = "SILVER TIER"
            headerCell.tierIcon.image = #imageLiteral(resourceName: "silver3")
        case 2:
            headerCell.tierName.text = "GOLD TIER"
            headerCell.tierIcon.image = #imageLiteral(resourceName: "gold3")
        case 3:
            headerCell.tierName.text = "PLATINUM TIER"
            headerCell.tierIcon.image = #imageLiteral(resourceName: "platinum3")
        case 4:
            headerCell.tierName.text = "DIAMOND TIER"
            headerCell.tierIcon.image = #imageLiteral(resourceName: "diamond3")
        case 5:
            headerCell.tierName.text = "CHAMPION TIER"
            headerCell.tierIcon.image = #imageLiteral(resourceName: "champion3")
        case 6:
            headerCell.tierName.text = "GRAND CHAMPION"
            headerCell.tierIcon.image = #imageLiteral(resourceName: "grand champion")
        default:
            headerCell.tierName.text = "Uh Oh"
        }
        
        let headerTap = SectionHeaderTap(target: self, action: #selector(expandPosts(gestureRecognizer:)))
        headerTap.section = section
        headerCell.contentView.addGestureRecognizer(headerTap)
        headerCell.contentView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        
        return headerCell.contentView
        
        //
        // Test for design reference
        //
        /*
        let testCell = postsTable.dequeueReusableCell(withIdentifier: "test") as! TestCell
        testCell.headerImage.image = #imageLiteral(resourceName: "testPhoto.jpg")
        let headerTap = SectionHeaderTap(target: self, action: #selector(expandPosts(gestureRecognizer:)))
        headerTap.section = section
        testCell.contentView.addGestureRecognizer(headerTap)
        testCell.contentView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        
        return testCell.contentView
        */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = postsTable.dequeueReusableCell(withIdentifier: "Post") as! PartnerPost
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func expandPosts(gestureRecognizer: SectionHeaderTap)
    {
        isHidden[gestureRecognizer.section!] = !isHidden[gestureRecognizer.section!]
        
        if sections[gestureRecognizer.section!].count == 0 {
            return
        }
        
        var indexPaths:[IndexPath] = []
        
        for i in 0..<bronzePosts.count {
            indexPaths.append(IndexPath(row: i, section: gestureRecognizer.section!))
        }
        
        if !isHidden[gestureRecognizer.section!] {
            postsTable.insertRows(at: indexPaths, with: .top)
        } else {
            postsTable.deleteRows(at: indexPaths, with: .top)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset.y < scrollView.contentOffset.y {
            if floatingButtonIsVisible {
                movePostButton()
            }
        } else if lastContentOffset.y > scrollView.contentOffset.y {
            if !floatingButtonIsVisible {
                movePostButton()
            }
        }
    }
    
    func toCreatePost() {
        let storyboard: UIStoryboard = UIStoryboard(name: "NewPost", bundle: nil)
        
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "NewPostController")
        //self.present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func movePostButton() {
        UIView.animate(withDuration: 0.3) { () -> Void in
            let superViewHeight = self.floatingButtonView.superview!.bounds.size.height
            let buttonHeight = self.floatingButtonView.frame.size.height
            
            if self.floatingButtonIsVisible { // move it off of the view (towards right)
                self.floatingButtonView.frame.origin.y = superViewHeight + buttonHeight
                self.floatingButtonIsVisible = false
            }
            else { // bring it back to it's position
                self.floatingButtonView.frame.origin.y = self.view.frame.maxY-90
                self.floatingButtonIsVisible = true
            }
        }
    }
    
    func getRocketLeagueStats() {
        let string = "https://api.rocketleaguestats.com/v1/player"
        getPlatform()
        
        let url = NSURL(string: string)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("Bearer api_key", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let playerData = response as? HTTPURLResponse {
                let code = playerData.statusCode
                print(code)
            }
        }
        task.resume()
    }
    
    func getPlatform () {
        let string = "https://api.rocketleaguestats.com/v1/data/platforms"
        let url = NSURL(string: string)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("Bearer api_key", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let platforms = response as? HTTPURLResponse {
                let code = platforms.statusCode
                print(code)
                
                if code == 200 {
                    dump(platforms.allHeaderFields)
                }
            }
        }
        task.resume()
    }
}

class SectionHeaderTap: UITapGestureRecognizer {
    var section: Int!
}
