//
//  ProfileTopView.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 15/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class ProfileTopView: UIView {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgvCover: UIImageView!
    @IBOutlet weak var imgvProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblEmailID: UILabel!
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var btnBlockUnblock: UIButton!
    @IBOutlet weak var imgMailIcon: UIImageView!
    @IBOutlet weak var viewEmail: UIView!
    
    @IBOutlet weak var btnSubscribeLeadConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgvProfile.clipsToBounds = true
        imgvProfile.layer.cornerRadius = imgvProfile.frame.height/2
        
        imgvCover.clipsToBounds = true
        
        imgvProfile.layer.borderWidth = 1.0
        imgvProfile.layer.borderColor = UIColor(hex:SideMenuHexColor.TextColor).cgColor
        imgvProfile.layer.masksToBounds = true
    }

}
