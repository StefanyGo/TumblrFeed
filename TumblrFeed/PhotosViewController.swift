//
//  PhotosViewController.swift
//  TumblrFeed
//
//  Created by Stefany Felicia on 2/2/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var posts: [NSDictionary] = []
    var loadingMoreView:InfiniteScrollActivityView?

    @IBOutlet weak var tableView: UITableView!
    
    var isMoreDataLoading = false
  //  var loadingMoreView:InfiniteScrollActivityView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 240
        tableView.delegate = self
        tableView.dataSource = self
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.tableView.reloadData()
                        
                        
                
                    }
                }
        });
        task.resume()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (posts.count)
        
        return posts.count
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // ... Create the URLRequest `myRequest` ...
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCellTableViewCell") as! PhotoCellTableViewCell
        let post = posts[indexPath.row]
        let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
        let imageUrlString = photos?[0].value(forKeyPath: "original_size.url") as? String
        let imageUrl = NSURL(string: imageUrlString!)
            // URL(string: imageUrlString!) is NOT nil, go ahead and unwrap it and assign it to imageUrl and run the code in the curly braces
        cell.photoView.setImageWith(imageUrl as! URL)
        let name = post.value(forKey: "blog_name") as! String!
        cell.label.text = name
        let urlString = "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar"
        let urlAvatar = NSURL(string: urlString)
        
        cell.avatarView.setImageWith(urlAvatar as! URL)
        
        cell.avatarView.layer.cornerRadius = 30
        cell.avatarView.clipsToBounds = true
        cell.avatarView.layer.borderColor = UIColor.black.cgColor
        cell.avatarView.layer.borderWidth = 2.5
        
    
        
        return cell
    }
  /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated:true)
        
    }
 */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // ... Code to load more results ...
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        
        // ... Create the NSURLRequest (myRequest) ...
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)

        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        
        let task : URLSessionDataTask = session.dataTask(with: request,
                                                                      completionHandler: { (data, response, error) in
                                                                        
                                                                        // Update flag
                                                                        self.isMoreDataLoading = false
                                                                        
                                                                        // ... Use the new data to update the data source ...
                                                       
                                                                        // Stop the loading indicator
                                                                        self.loadingMoreView!.stopAnimating()
                                                                        // Reload the tableView now that there is new data
                                                                        self.tableView.reloadData()
        });
        task.resume()
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //    let vc = segue.destination as! PhotoDetailsViewController
      //  let indexPath = tableView.indexPath(for: <#T##UITableViewCell#>)
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let post = posts[(indexPath?.row)!]
        let photoDetailViewController = segue.destination as! PhotoDetailsViewController
        photoDetailViewController.post = post
        
        
    }
    

}
