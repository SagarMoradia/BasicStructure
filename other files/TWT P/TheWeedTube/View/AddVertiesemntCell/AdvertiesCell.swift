//
//  AdvertiesCell.swift
//  TheWeedTube
//
//  Created by Hitesh Surani on 10/05/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class AdvertiesCell: UITableViewCell {

    
    @IBOutlet weak var viewAd: UIView!
    @IBOutlet weak var imgAds: UIImageView!
    @IBOutlet weak var ContrainAdsHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
