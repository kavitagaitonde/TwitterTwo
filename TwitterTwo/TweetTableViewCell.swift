//
//  TweetTableViewCell.swift
//  TwitterTwo
//
//  Created by Kavita Gaitonde on 9/25/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!    
    @IBOutlet weak var activityTimestampLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    var updateTweet : (Tweet) -> Void = { (tweet: Tweet) in }
    var tweet: Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.cornerRadius = 5.0
        self.profileImageView.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func retweetClicked(_ sender: Any) {
        if(tweet?.retweeted)! {
            TwitterClient.sharedInstance?.unretweet(tweetId: (tweet?.id)!, success: {(tweet: Tweet) -> () in
                print ("success unfavoriting")
                self.updateTweet(tweet)
            }, failure: { (error: Error) in
                print ("error unfavoriting")
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweetId: (tweet?.id)!, success: {(tweet: Tweet) -> () in
                print ("success favoriting")
                self.updateTweet(tweet)
            }, failure: { (error: Error) in
                print ("error favoriting")
            })
        }
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        if(tweet?.favorited)! {
            TwitterClient.sharedInstance?.unFavorite(tweetId: (tweet?.id)!, success: {(tweet: Tweet) -> () in
                print ("success unfavoriting")
                self.updateTweet(tweet)
            }, failure: { (error: Error) in
                print ("error unfavoriting")
            })
        } else {
            TwitterClient.sharedInstance?.favorite(tweetId: (tweet?.id)!, success: {(tweet: Tweet) -> () in
                print ("success favoriting")
                self.updateTweet(tweet)
            }, failure: { (error: Error) in
                print ("error favoriting")
            })
        }
        
    }
    
    
}
