//
//  TwitterClient.swift
//  TwitterTwo
//
//  Created by Kavita Gaitonde on 9/25/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

let twitterBaseUrl = "https://api.twitter.com"
let twitterConsumerKey = "SjiFlt58uAyjrXU8RGeRc6sK3"
let twitterConsumerSecret = "H6jiqvTrW1pKT59SaggiFNLYwe6KxgeRTJdH3r2KFRM9asbKiD"

class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let sharedInstance = TwitterClient (baseURL: URL(string: twitterBaseUrl)!, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    
    func login (success: () -> (), failure: (NSError) -> ()) {
        deauthorize()
        
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twittertwo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
                let token = (requestToken?.token)!
                print("Got Oauth token =\(token)")
                let url = URL(string: "\(twitterBaseUrl)/oauth/authorize?oauth_token=\(token)")
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }, failure: { (error: Error?) in
                print("Error fetching Oauth token =\(error?.localizedDescription)")
        })
    }
    
    func handleOpenUrl(url: URL) {
        print(url.description)
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
                print("Success fetching access token = \((accessToken?.token)!)")
        }) { (error: Error?) in
                print("Error fetching access token = \(error?.localizedDescription)")
        }
    }
    
    func homeTimeLine () {
        
    }
    
    func currentUser () {
        
    }
}
