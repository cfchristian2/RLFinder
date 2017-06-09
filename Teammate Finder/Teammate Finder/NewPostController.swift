//
//  NewPostController.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 5/25/17.
//  Copyright © 2017 Conner Christianson. All rights reserved.
//

import UIKit

class NewPostController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var barButtons: UISegmentedControl!
    @IBOutlet weak var postBody: UITextView!
    var hasEditedText = false
    let placeholder = "Body of post"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = .lightGray
        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        
        postBody.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        postBody.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        postBody.textColor = .lightGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.text == placeholder && textView.textColor == .lightGray {
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.selectedRange = NSRange(location: 0, length: 0)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count != 0 && textView.text.substring(from: textView.text.startIndex) == placeholder && textView.textColor == .lightGray {
            textView.text = textView.text.substring(to: textView.text.startIndex)
            textView.textColor = .white
        } else if textView.text.characters.count == 0 {
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
        if text.characters.count > 0 && textView.text == placeholder && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .white
        }
        
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
