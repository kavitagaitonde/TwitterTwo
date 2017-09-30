//
//  DetailViewController.swift
//  TwitterTwo
//
//  Created by Kavita Gaitonde on 9/25/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var tweet: Tweet?
    var updateTweet : (Tweet) -> Void = { (tweet: Tweet) in }
    var shouldUpdateTweet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = tweet?.user
        self.nameLabel.text = user?.name
        self.screenLabel.text = "@\((user?.screenName)!)"
        self.tweetLabel.text = tweet?.text
        self.timeLabel.text = tweet?.getFriendlyDateString()
        self.retweetCountLabel.text = "\((tweet?.retweetCount)!)"
        self.favoriteCountLabel.text = "\((tweet?.favoriteCount)!)"
        self.profileImageView.layer.cornerRadius = 5.0
        self.profileImageView.clipsToBounds = true
        if (user?.profileUrl != nil) {
            self.profileImageView.setImageWith((user?.profileUrl!)!)
        } else {
            self.profileImageView.image = nil
        }
        let retweetedByUser = self.tweet?.retweetedByUser
        if retweetedByUser != nil {
            if User.currentUser?.id == retweetedByUser?.id {
                self.retweetLabel.text = "You Retweeted"
            } else {
                self.retweetLabel.text = "\((retweetedByUser?.name)!) Retweeted"
            }
            self.retweetLabel.isHidden = false
            self.retweetImageView.isHidden = false
        } else {
            self.retweetLabel.isHidden = true
            self.retweetImageView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.updateTweet(self.tweet!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        if (self.tweet?.favorited)! {
            TwitterClient.sharedInstance?.unFavorite(tweetId: (self.tweet?.id)!, success: {(tweet: Tweet) -> () in
                print ("success unfavoriting")
                self.tweet = tweet
                self.shouldUpdateTweet = true
                self.favoriteButton.isSelected = false
                self.favoriteCountLabel.text = "\(tweet.favoriteCount)"
            }, failure: { (error: Error) in
                print ("error unfavoriting")
            })
        } else {
            TwitterClient.sharedInstance?.favorite(tweetId: (self.tweet?.id)!, success: {(tweet: Tweet) -> () in
                print ("success favoriting")
                self.tweet = tweet
                self.shouldUpdateTweet = true
                self.favoriteButton.isSelected = true
                self.favoriteCountLabel.text = "\(tweet.favoriteCount)"
            }, failure: { (error: Error) in
                print ("error favoriting")
            })
        }
    }
    
    
    @IBAction func retweetAction(_ sender: Any) {
        if (self.tweet?.retweeted)! {
            TwitterClient.sharedInstance?.unretweet(tweetId: (self.tweet?.id)!, success: {(tweet: Tweet) -> () in
                print ("success unretweeting")
                //BUGBUG: Bug in Twitter its not redcing the retweet count upon unretweeting
                tweet.retweetCount = tweet.retweetCount - 1
                tweet.retweeted = false
                self.tweet = tweet
                self.shouldUpdateTweet = true
                self.retweetButton.isSelected = false
                self.retweetCountLabel.text = "\(tweet.retweetCount-1)"
            }, failure: { (error: Error) in
                print ("error unretweeting")
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweetId: (self.tweet?.id)!, success: {(tweet: Tweet) -> () in
                print ("success retweeting")
                self.tweet = tweet
                self.shouldUpdateTweet = true
                self.retweetButton.isSelected = true
                self.retweetCountLabel.text = "\(tweet.retweetCount)"
            }, failure: { (error: Error) in
                print ("error retweeting")
            })
        }

    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailReplySegue") {
            let composeController = segue.destination as! ComposeViewController
            composeController.composeMode = .reply
            composeController.replyToTweet = self.tweet
            composeController.addTweet = { (addedTweet: Tweet) in
                self.tweet = addedTweet
                self.shouldUpdateTweet = true
            }
        }
    }

}
