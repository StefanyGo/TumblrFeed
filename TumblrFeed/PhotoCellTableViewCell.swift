//
//  PhotoCellTableViewCell.swift
//  TumblrFeed
//
//  Created by Stefany Felicia on 2/2/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class PhotoCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var avatarView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
