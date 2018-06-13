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
import FirebaseAuthUI
import FirebaseFacebookAuthUI

class PartnerPostsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, FUIAuthDelegate, ButtonReloadsTable {

    @IBAction func toSettings(_ sender: Any) {
        toSettings()
    }
    
    @IBOutlet weak var postsTable: UITableView!
    
    var dropDown: DropDownButton!
    
    var ref: DatabaseReference!
    
    var currentSelectedSystem = "PS4"
    
    // This storage will probably change once database is implemented
    var bronzePosts: [String] = []
    var silverPosts: [String] = []
    var goldPosts: [String] = []
    var platinumPosts: [String] = []
    var diamondPosts: [String] = []
    var championPosts: [String] = []
    var grandChampionPosts: [String] = []
    
    // Section collapsed or not
    var isHidden = [true, true, true, true, true, true, true]
    
    // Floating button used when user wants to make a post
    var floatingButtonIsVisible = true
    var floatingButtonView: UIImageView!
    var lastContentOffset: CGPoint!
    
    // Firebase UI options
    var authUI: FUIAuth?
    let providers: [FUIAuthProvider] = [
        FUIFacebookAuth()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FirebaseUI auth delegate setup
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        authUI?.providers = providers
        
        ref = Database.database().reference()
        
        postsTable.delegate = self
        postsTable.dataSource = self
        
        floatingButtonView = UIImageView(frame: CGRect(x:self.view.frame.maxX-100, y:self.view.frame.maxY-120, width:76, height:76))
        floatingButtonView.image = #imageLiteral(resourceName: "addButton")
        floatingButtonView.layer.cornerRadius = floatingButtonView.frame.size.height/2
        floatingButtonView.clipsToBounds = true
        floatingButtonView.isUserInteractionEnabled = true
        floatingButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toCreatePost)))
        view.addSubview(floatingButtonView)
        
        automaticallyAdjustsScrollViewInsets = false
        
        //navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = .lightGray
        
        dropDown = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        dropDown.setTitle("PS4", for: .normal)
        dropDown.dropDownView.dropDownOptions = ["PS4", "PC", "Xbox One"]
        
        self.view.addSubview(dropDown)
        
        dropDown.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dropDown.centerYAnchor.constraint(equalTo: self.postsTable.topAnchor, constant: -10).isActive = true
        dropDown.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dropDown.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dropDown.delegate = self
        
        getRocketLeagueStats()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        readDatabase()
    }
    
    //-------------------------------------------------------------------------------------------//
    // MARK: Firebase
    
    func readDatabase() {
        bronzePosts = []
        silverPosts = []
        goldPosts = []
        platinumPosts = []
        diamondPosts = []
        championPosts = []
        grandChampionPosts = []
        
        var system = ""
        switch currentSelectedSystem {
        case "PS4":
            system = "ps4"
        case "PC":
            system = "pc"
        case "Xbox One":
            system = "xboxOne"
        default:
            system = ""
        }
                
        ref.child(system).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String : Any]
            for (postType, posts) in value! {
                for (postId, post) in posts as! [String : [String : String]] {
                    switch (postType) {
                    case "bronzePosts":
                        self.bronzePosts.append(post["postBody"] ?? postId)
                    case "silverPosts":
                        self.silverPosts.append(post["postBody"] ?? postId)
                    case "goldPosts":
                        self.goldPosts.append(post["postBody"] ?? postId)
                    case "platinumPosts":
                        self.platinumPosts.append(post["postBody"] ?? postId)
                    case "diamondPosts":
                        self.diamondPosts.append(post["postBody"] ?? postId)
                    case "championPosts":
                        self.championPosts.append(post["postBody"] ?? postId)
                    case "grandChampionPosts":
                        self.grandChampionPosts.append(post["postBody"] ?? postId)
                    default:
                        print("Post type was not recorded correctly in Firebase")
                    }
                }
            }
            
            // Reload table with animation
            let range = NSMakeRange(0, self.postsTable.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.postsTable.reloadSections(sections as IndexSet, with: .fade)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //-------------------------------------------------------------------------------------------//
    // MARK: Table View
    
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
                return grandChampionPosts.count
            }
        default:
            print("Defaulted on number of posts in tableview")
            return 0
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122.0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 85.0
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
            headerCell.tierName.text = "GRAND CHAMP"
            headerCell.tierIcon.image = #imageLiteral(resourceName: "grand champion")
        default:
            headerCell.tierName.text = "Uh Oh"
        }
        
        let headerTap = SectionHeaderTap(target: self, action: #selector(expandPosts(gestureRecognizer:)))
        headerTap.section = section
        headerTap.cell = headerCell
        headerCell.contentView.addGestureRecognizer(headerTap)
        headerCell.contentView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var selectedPostArray = [String]()
        
        switch (indexPath.section) {
        case 0:
            selectedPostArray = bronzePosts
        case 1:
            selectedPostArray = silverPosts
        case 2:
            selectedPostArray = goldPosts
        case 3:
            selectedPostArray = platinumPosts
        case 4:
            selectedPostArray = diamondPosts
        case 5:
            selectedPostArray = championPosts
        case 6:
            selectedPostArray = grandChampionPosts
        default:
            print("User selected section of postsTable that doesn't exist")
        }
        
        let cell = postsTable.dequeueReusableCell(withIdentifier: "Post") as! PartnerPost
        cell.postBody.text = selectedPostArray[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.masksToBounds = true
        return cell
    }
    
    func expandPosts(gestureRecognizer: SectionHeaderTap) {
        isHidden[gestureRecognizer.section!] = !isHidden[gestureRecognizer.section!]
        
        var selectedPostArray = [String]()
        
        switch (gestureRecognizer.section) {
        case 0:
            selectedPostArray = bronzePosts
        case 1:
            selectedPostArray = silverPosts
        case 2:
            selectedPostArray = goldPosts
        case 3:
            selectedPostArray = platinumPosts
        case 4:
            selectedPostArray = diamondPosts
        case 5:
            selectedPostArray = championPosts
        case 6:
            selectedPostArray = grandChampionPosts
        default:
            print("User selected section of postsTable that doesn't exist")
        }
        
        if selectedPostArray.count == 0 {
            return
        }
        
        var indexPaths:[IndexPath] = []
        
        for i in 0..<selectedPostArray.count {
            indexPaths.append(IndexPath(row: i, section: gestureRecognizer.section!))
        }
        
        if !isHidden[gestureRecognizer.section!] {
            postsTable.insertRows(at: indexPaths, with: .fade)
            gestureRecognizer.cell.caret.image = #imageLiteral(resourceName: "angle-up")
            
        } else {
            postsTable.deleteRows(at: indexPaths, with: .fade)
            gestureRecognizer.cell.caret.image = #imageLiteral(resourceName: "angle-down")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Section: \(indexPath.section)\nRow: \(indexPath.row)")
        if let cell = postsTable.cellForRow(at: indexPath) as? PartnerPost {
            toPostDetails(post: cell)
        }
    }
    
    //-------------------------------------------------------------------------------------------//
    // MARK: Scroll View
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset != nil {
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
                self.floatingButtonView.frame.origin.y = self.view.frame.maxY-120
                self.floatingButtonIsVisible = true
            }
        }
    }
    
    //-------------------------------------------------------------------------------------------//
    // MARK: Screen Navigation
    
    func toPostDetails(post: PartnerPost) {
        
        let vc = PostDetailsViewController()
        vc.view.backgroundColor = .blue
        //self.present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
        print(post.postBody.text ?? "")
    }
    
    func toCreatePost() {
        if User.currentUser == nil {
            presentAlertController(withTitle: "Please Log In", message: "You need to log in in order to post")
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "NewPost", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "NewPostController") as? NewPostController else {
            return
        }
        vc.currentSelectedSystem = currentSelectedSystem
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func toSettings() {
        if User.currentUser == nil {
            let authViewController = authUI?.authViewController()
            authViewController?.navigationBar.barStyle = .black
            authViewController?.navigationBar.tintColor = .white
            self.present(authViewController!, animated: true, completion: nil)
        } else {
            let storyboard: UIStoryboard = UIStoryboard(name: "Settings", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SettingsController")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //-------------------------------------------------------------------------------------------//
    // MARK: Firebase UI
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FirebaseAuth.User?, error: Error?) {
        if error == nil {
            if user != nil {
                User.currentUser = User(uid: user!.uid)
                User.currentUser?.email = user!.email
                User.currentUser?.uid = user!.uid
                User.archiveCurrentUser()
                self.ref.child("users").setValue(user!.uid)
            }
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return FUICustomAuthPickerViewController(nibName: "FUICustomAuthPickerViewController", bundle: Bundle.main, authUI: authUI)
    }
    
    func emailEntryViewController(forAuthUI authUI: FUIAuth) -> FUIEmailEntryViewController {
        return FUICustomEmailEntryViewController(nibName: "FUICustomEmailEntryViewController", bundle: Bundle.main, authUI: authUI)
    }
    
    //-------------------------------------------------------------------------------------------//
    // MARK: Alert Creation
    
    func presentAlertController(withTitle title: String?, message: String?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------------------------------------//
    // MARK: Rocket League API
    
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
    
    //-------------------------------------------------------------------------------------------//
    // MARK: Drop Down Functionality
    func reloadTable(system: String) {
        currentSelectedSystem = system
        readDatabase()
    }
}

class SectionHeaderTap: UITapGestureRecognizer {
    var section: Int!
    var cell: PartnerPostHeader!
}

class DropDownButton: UIButton, DropDownProtocol {
    
    var dropDownView = DropDownView()
    
    var height = NSLayoutConstraint()
    
    var isOpen = false
    
    var delegate: ButtonReloadsTable!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitleColor(.white, for: .normal)
        
        dropDownView = DropDownView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.delegate = self
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropDownView)
        self.superview?.bringSubview(toFront: dropDownView)
        dropDownView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropDownView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropDownView.widthAnchor.constraint(equalTo: (self.superview?.widthAnchor)!).isActive = true
        height = dropDownView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropDownView.center.y -= self.dropDownView.frame.height / 2
                self.dropDownView.layoutIfNeeded()
            }, completion: nil)
        } else {
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = self.dropDownView.tableView.contentSize.height
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                self.dropDownView.layoutIfNeeded()
                self.dropDownView.center.y += self.dropDownView.frame.height / 2
            }, completion: nil)
        }
    }
    
    func dropDownClicked(string: String) {
        self.setTitle(string, for: .normal)
        self.delegate.reloadTable(system: string)
        
        isOpen = false
        
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropDownView.center.y -= self.dropDownView.frame.height / 2
            self.dropDownView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate: DropDownProtocol!
    
    let globalDarkColor = UIColor(displayP3Red: 0.11, green: 0.11, blue: 0.11, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isUserInteractionEnabled = true

        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        tableView.backgroundColor = globalDarkColor
        self.backgroundColor = globalDarkColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = globalDarkColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownClicked(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

protocol DropDownProtocol {
    func dropDownClicked(string: String)
}

protocol ButtonReloadsTable {
    func reloadTable(system: String)
}




















