//
//  HomeTableViewCell.swift
//  NewDiscoverNearby
//
//  Created by bhl on 3/16/18.
//  Copyright © 2018 UChicago. All rights reserved.
//

import UIKit
import SDWebImage
/**
    Define HomeTableView cell, prepare data and connect with Home view
 */
class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    var post: Retrieve? {
        didSet {
            updateView()
        }
    }
    var user: UserInfo? {
        didSet {
            setupUserInfo()
        }
    }
    
    /**
     Updatw home table view cell
    */
    
    func updateView() {
        captionLabel.text = post?.caption
        descriptionLabel.text = post?.description
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        
    }
    
    /**
     set up user information of every cell
     */
    
    func setupUserInfo() {
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "User"))
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        captionLabel.text = ""
        descriptionLabel.text = ""
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "User")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
