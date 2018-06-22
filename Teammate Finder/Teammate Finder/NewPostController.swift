//
//  NewPostController.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 5/25/17.
//  Copyright © 2017 Conner Christianson. All rights reserved.
//

import UIKit
import SJFluidSegmentedControl
import Firebase

class NewPostController: UIViewController, UITextViewDelegate, SJFluidSegmentedControlDataSource {
    @IBAction func buttonPushed(_ sender: Any) {
        // Handle user posting
        postPost()
    }
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    @IBOutlet weak var rankChooser: SJFluidSegmentedControl!
    
    @IBOutlet weak var gameTypeChooser: SJFluidSegmentedControl!
    
    @IBOutlet weak var postBody: UITextView!
    
    let gameTypes = ["solo", "doubles", "standard", "soloStandard"]
    
    var hasEditedText = false
    
    let placeholder = "Body of post"
    
    var ref: DatabaseReference!
    
    var currentSelectedSystem: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        postButton.tintColor = view.tintColor
        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        
        postBody.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        postBody.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        postBody.textColor = .lightGray
        
        rankChooser.dataSource = self
        gameTypeChooser.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------------------------------------//
    // Posting
    
    func postPost() {
        print(ranks[rankChooser.currentSegment].title)
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
        
        guard let chosenRank = ranks[rankChooser.currentSegment].postType else {
            return
        }
        let chosenGameType = gameTypes[gameTypeChooser.currentSegment]
        
        print(system)
        print(chosenRank)
        print(chosenGameType)
        
        let newPostReference = ref.child(system).child(chosenGameType).child(chosenRank).childByAutoId()
        newPostReference.setValue(["gameType" : chosenGameType, "postBody" : postBody.text ?? "", "username" : "bestUser69"])
    }
    
    //-------------------------------------------------------------------------------------------//
    // Text view
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.text == placeholder && textView.textColor == .lightGray {
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.selectedRange = NSRange(location: 0, length: 0)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count != 0 && textView.text.substring(from: textView.text.startIndex) == placeholder && textView.textColor == .lightGray {
            textView.text = textView.text.substring(to: textView.text.startIndex)
            textView.textColor = .white
        } else if textView.text.count == 0 {
            textView.text = placeholder
            textView.textColor = .lightGray
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
        
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.count > 0 && textView.text == placeholder && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .white
        }
        
        return true
    }
    
    //-------------------------------------------------------------------------------------------//
    // SJFluidSegmentedControl
    
    let ranks: [Rank] = [Rank(title: "Bronze", icon: UIImage(named: "bronze3")!, color: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0), postType: "bronzePosts"),
                         Rank(title: "Silver", icon: UIImage(named: "silver3")!, color: UIColor.lightGray, postType: "silverPosts"),
                         Rank(title: "Gold", icon: UIImage(named: "gold3")!, color: UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.5), postType: "goldPosts"),
                         Rank(title: "Platinum", icon: UIImage(named: "platinum3")!, color: UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.3), postType: "platinumPosts"),
                         Rank(title: "Diamond", icon: UIImage(named: "diamond3")!, color: UIColor(red: 0.1, green: 0.1, blue: 1.0, alpha: 0.5), postType: "diamondPosts"),
                         Rank(title: "Champion", icon: UIImage(named: "champion3")!, color: UIColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 0.5), postType: "championPosts"),
                         Rank(title: "Grand Champion", icon: UIImage(named: "grand champion")!, color: UIColor(red: 1.0, green: 0.3, blue: 1.0, alpha: 0.7), postType: "grandChampionPosts")]

    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {
        if segmentedControl == rankChooser {
            return 7
        } else if segmentedControl == gameTypeChooser {
            return 4
        } else {
            return 1
        }
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          attributedTitleForSegmentAtIndex index: Int) -> NSAttributedString? {
        if segmentedControl == rankChooser {
            let attachment = NSTextAttachment()
            attachment.image = ranks[index].icon
            attachment.bounds = CGRect(x: attachment.bounds.minX, y: attachment.bounds.minY, width: 35, height: 35)
            
            return NSAttributedString(attachment: attachment)
        } else if segmentedControl == gameTypeChooser {
            let gameTypes = ["Singles", "Doubles", "Standard", "Solo Standard"]
            let attrString = NSAttributedString(string: gameTypes[index])
            
            return attrString
        } else {
            return NSAttributedString()
        }
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, gradientColorsForSelectedSegmentAtIndex index: Int) -> [UIColor] {
        if segmentedControl == rankChooser {
            var colors = [UIColor]()
            for rank in ranks {
                colors.append(rank.color)
            }
            return [ranks[index].color]
        } else if segmentedControl == gameTypeChooser {
            return [UIColor(red: 0.1, green: 0.1, blue: 1.0, alpha: 0.5)]
        } else {
            return [UIColor.black]
        }
    }
}
