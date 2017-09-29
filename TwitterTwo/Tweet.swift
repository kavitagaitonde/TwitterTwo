//
//  Tweet.swift
//  TwitterTwo
//
//  Created by Kavita Gaitonde on 9/25/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    
    var id: Int
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var favorited: Bool
    var user: User?
    
    static let formatter = DateFormatter()
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as! Int
        text = dictionary["text"] as? String
        favorited = dictionary["favorited"] as! Bool
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        let timeString = dictionary["created_at"] as? String
        if let timeString = timeString {
            Tweet.formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = Tweet.formatter.date(from: timeString)
        }
        let userDict = dictionary["user"] as? NSDictionary
        user = User(dictionary: userDict!)
        
    }
    
    class func tweetsArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
    func getElapsedTimeString() -> String {
        let interval = (timestamp?.timeIntervalSinceNow)!
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        let timeString = formatter.string(from: abs(interval))!
        let times = timeString.components(separatedBy: ":")
        switch times.count {
        case 1:
            return "\(times[0])s"
        case 2:
            return "\(times[0])m"
        case 3:
            if Int(times[0])! >= 24 {
                Tweet.formatter.dateFormat = "d MMM"
                return Tweet.formatter.string(from: timestamp!)
            } else {
                return "\(times[0])h"
            }
        default:
            return ""
            
        }
        /*
        let interval = (self.timestamp?.timeIntervalSinceNow)! / 1000
        let hours = interval / 3600
        if hours > 24 {
            return ""
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            let mins = (interval / 60 ) % 60
            if mins > 0 {
                return "\(hours)h"
            } else {
                let seconds = interval % 60;
            }
        }*/
        
    }
}
