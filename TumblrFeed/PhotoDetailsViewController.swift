//
//  PhotoDetailsViewController.swift
//  TumblrFeed
//
//  Created by Stefany Felicia on 9/2/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet var photoView: UIImageView!
    var post: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
        let imageUrlString = photos?[0].value(forKeyPath: "original_size.url") as? String
        let imageUrl = NSURL(string: imageUrlString!)
        photoView.setImageWith(imageUrl as! URL)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
