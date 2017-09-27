//
//  MainViewController.swift
//  TwitterTwo
//
//  Created by Kavita Gaitonde on 9/25/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet] = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        print ("******* Loading MainViewController *******")
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        //fetch latest tweets
        TwitterClient.sharedInstance?.homeTimeLine(success: {(tweets: [Tweet]) in
            print ("Tweets fetch successful")
            self.tweets = tweets
            self.tableView.reloadData()
            }, failure: { (error: Error?) in
                print("Error in fetching tweets")
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        let tweet = self.tweets[indexPath.row] as Tweet
        cell.tweetTextLabel?.text = tweet.text
        cell.nameLabel?.text = tweet.user?.name
        cell.screenNameLabel?.text = tweet.user?.screenName
        if (tweet.user?.profileUrl != nil) {
            cell.profileImageView.setImageWith((tweet.user?.profileUrl!)!)
        } else {
            cell.profileImageView.image = nil
        }
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "composeTweetSegue") {
            let composeController = segue.destination as! ComposeViewController
        } else if (segue.identifier == "tweetDetailSegue") {
            let cell = sender as! TweetTableViewCell
            if let indexPath = self.tableView.indexPath(for: cell) {
                let detailsController = segue.destination as! DetailViewController
                let tweet = self.tweets[indexPath.row] as Tweet
                detailsController.tweet = tweet
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
 

    
    @IBAction func onLogout(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }
    
}
