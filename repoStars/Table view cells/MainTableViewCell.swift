//
//  MainTableViewCell.swift
//  repoStars
//
//  Created by Apple on 4/1/19.
//  Copyright © 2019 matic challenge. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var repoTitleLabel: UILabel!
    @IBOutlet weak var repoDescrpLabel: UILabel!
    @IBOutlet weak var repoOwnerLabel: UILabel!
    @IBOutlet weak var starsCount: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        activityIndicator.startAnimating()
        avatar?.image = nil
    }
    
}
