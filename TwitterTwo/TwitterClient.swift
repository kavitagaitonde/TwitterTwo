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
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?

    func login (success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()

        
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twittertwo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
                let token = (requestToken?.token)!
                print("Got Oauth token =\(token)")
                let url = URL(string: "\(twitterBaseUrl)/oauth/authorize?oauth_token=\(token)")
            UIApplication.shared.open(url!, options: [:], completionHandler: {(result: Bool) in
            })
            }, failure: { (error: Error?) in
                print("Error fetching Oauth token =\(error?.localizedDescription)")
                self.loginFailure?(error!)
        })
    }
    
    func handleOpenUrl(url: URL) {
        print(url.description)
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print("Success fetching access token = \((accessToken?.token)!)")
            
            self.userCredentials(success: {(user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: {(error: Error?) in
                 self.loginFailure?(error!)   
            })
        }) { (error: Error?) in
                print("Error fetching access token = \(error?.localizedDescription)")
        }
    }
    
    func homeTimeLine (success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil
            , success: { (task: URLSessionDataTask?, response: Any?) in
                print("Success fetching home timeline - ")
                let dictionaries = response as! [NSDictionary]
                success(Tweet.tweetsArray(dictionaries: dictionaries))
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print("Error fetching home timeline - \(error.localizedDescription)")
                failure(error)
        })
    }
    
    func userCredentials (success: @escaping (User) -> (),  failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil
            , success: { (task: URLSessionDataTask?, response: Any?) in
                let userDict = response as! NSDictionary
                print("Account info - \(userDict)")
                //create and save user
                let user = User(dictionary: userDict)
                success(user)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print("Error fetching user account - \(error.localizedDescription)")
                failure(error)
        })
    }
}
