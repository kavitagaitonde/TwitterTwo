//
//  ComposeViewController.swift
//  TwitterTwo
//
//  Created by Kavita Gaitonde on 9/25/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBOutlet weak var characterCountLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var isPlaceholderText: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImageView.layer.cornerRadius = 5.0
        self.profileImageView.clipsToBounds = true
        if (User.currentUser?.profileUrl != nil) {
            self.profileImageView.setImageWith((User.currentUser?.profileUrl!)!)
        } else {
            self.profileImageView.image = nil
        }
        self.nameLabel.text = User.currentUser?.name
        self.screenNameLabel.text = "@\((User.currentUser?.screenName)!)"
        self.characterCountLabel.text = "140"
        self.tweetTextView.text = "What's on your mind today?"
        self.tweetTextView.textColor = UIColor.lightGray
        self.tweetTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TextView Delegate
    
    func textViewDidBeginEditing(_: UITextView) {
        if self.isPlaceholderText {
            self.tweetTextView.text = nil
            self.tweetTextView.textColor = UIColor.darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.tweetTextView.text.isEmpty {
            self.tweetTextView.text = "What would you like to tweet today?"
            self.tweetTextView.textColor = UIColor.lightGray
            self.isPlaceholderText = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.isPlaceholderText = false
        let count = self.tweetTextView.text.characters.count
        self.characterCountLabel.text = "\(140 - count)"
        if (count >= 140) {
            return false
        } else {            
            return true
        }
    }
    
    /*func textViewDidChange(_: UITextView) {
        let count = self.tweetTextView.text.characters.count
        if (count >= 140) {
            self.te
        } else {
            self.characterCountLabel.text = "\(140 - count)"
        }
        
    }*/


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onTweet(_ sender: AnyObject) {
        
        self.onClose(sender)
        
    }
    
}
