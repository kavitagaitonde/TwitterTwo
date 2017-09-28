//
//  MainViewController.swift
//  TwitterTwo
//
//  Created by Kavita Gaitonde on 9/25/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl : UIRefreshControl?
    var infiniteScrollActivityView:InfiniteScrollActivityView?
    var isMoreDataLoading = false
    var tweets: [Tweet] = [Tweet]()
    var tweetOffset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        print ("******* Loading MainViewController *******")
        
        // Add UI refreshing on pull down
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(self.refreshControl!, at: 0)

        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        infiniteScrollActivityView = InfiniteScrollActivityView(frame: frame)
        infiniteScrollActivityView!.isHidden = true
        self.tableView.addSubview(infiniteScrollActivityView!)
        
        var insets = self.tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight + 50
        self.tableView.contentInset = insets

        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.tweetOffset = 0
        self.loadData()
    }
    
    func loadData() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.infiniteScrollActivityView!.stopAnimating()
        self.refreshControl!.endRefreshing()
        self.isMoreDataLoading = false
        
        //fetch latest tweets
        TwitterClient.sharedInstance?.homeTimeLine(success: {(tweets: [Tweet]) in
            print ("Tweets fetch successful")
            if(self.tweetOffset > 0) {
                self.tweets += tweets
            } else {
                self.tweets = tweets
            }
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

    // MARK: - Scrollview
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!self.isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            //actual hieght of the table filled in with content - height of 1 page of content
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                self.isMoreDataLoading = true
                print("Loading more data.......offset = \(self.tweetOffset)")
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                infiniteScrollActivityView?.frame = frame
                infiniteScrollActivityView!.startAnimating()
                
                self.tweetOffset = self.tweets.count
                
                self.loadData()
            }
            
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "composeTweetSegue") {
            //let composeController = segue.destination as! ComposeViewController
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
