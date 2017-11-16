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
    @IBOutlet weak var postBody: UITextView!
    var hasEditedText = false
    let placeholder = "Body of post"
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        postButton.tintColor = view.tintColor
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = .lightGray
        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        
        postBody.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        postBody.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        postBody.textColor = .lightGray
        
        rankChooser.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    //-------------------------------------------------------------------------------------------//
    // Posting
    
    func postPost() {
        print(ranks[rankChooser.currentSegment].title)
        let newPostReference = ref.child("ps4").child(ranks[rankChooser.currentSegment].postType).childByAutoId()
        newPostReference.setValue(["gameType" : "doubles", "textPost" : postBody.text ?? "", "username" : "bestUser69"])
        
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
        return 7
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          attributedTitleForSegmentAtIndex index: Int) -> NSAttributedString? {
        let attachment = NSTextAttachment()
        attachment.image = ranks[index].icon
        attachment.bounds = CGRect(x: attachment.bounds.minX, y: attachment.bounds.minY, width: 35, height: 35)
        return NSAttributedString(attachment: attachment)
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, gradientColorsForSelectedSegmentAtIndex index: Int) -> [UIColor] {
        var colors = [UIColor]()
        for rank in ranks {
            colors.append(rank.color)
        }
        return [ranks[index].color]
    }
    
    // Might not use this
    func hexStringToUIColor (hex:String) -> UIColor {
        let cString:String = hex.uppercased()
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
