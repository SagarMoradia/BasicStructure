//
//  CellProfileTop.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 15/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class CellProfileTop: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgvCover: UIImageView!
    @IBOutlet weak var imgvProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblEmailID: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgvProfile.clipsToBounds = true
        imgvProfile.layer.cornerRadius = imgvProfile.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
