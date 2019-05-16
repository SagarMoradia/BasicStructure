//
//  CellSocialAccounts.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 19/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class CellSocialAccounts: UITableViewCell {
    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var cntrlSwitch : PVSwitch!
    @IBOutlet weak var viewSocial : UIView!
    @IBOutlet weak var viewShow : UIView!
    @IBOutlet weak var viewMain : UIView!
    @IBOutlet weak var viewInner : UIView!
    
    @IBOutlet weak var lblSocialLink: UILabel!
    @IBOutlet weak var txtSocialLink : UITextField!
    

    var objSocialList : SocialList!{
        didSet {
            
            
            let lblstr = UILabel(frame: CGRect(x: 0, y: txtSocialLink.frame.height/2, width: 20, height: txtSocialLink.frame.height))
            lblstr.text = "@"
            txtSocialLink.leftView = lblstr
            txtSocialLink.leftViewMode = .always
            
            textLabel?.backgroundColor = UIColor.clear
            
         
//            if objSocialList.social_media_url != ""
//            {
//                let fullNameArr = objSocialList.social_media_url.components(separatedBy: ".com/")
//            
//                txtSocialLink.text = fullNameArr[1]
//            }
            
            lblName.text = objSocialList.social_media_name
            if lblName.text == "INSTAGRAM"{
                lblSocialLink.text = "https://www.instagram.com/"
                txtSocialLink.text = objSocialList.social_media_url
            }
            else if lblName.text == "TWITTER"{
                lblSocialLink.text = "https://www.twitter.com/"
                txtSocialLink.text = objSocialList.social_media_url
            }
            else if lblName.text == "FACEBOOK"{
                lblSocialLink.text = "https://www.facebook.com/"
                txtSocialLink.text = objSocialList.social_media_url
            }
            else if lblName.text == "SNAPCHAT"{
                lblSocialLink.text = "https://www.snapchat.com/add/"
                txtSocialLink.text = objSocialList.social_media_url
            }

            cntrlSwitch.isOn = objSocialList.is_switchON
            
            if objSocialList.is_expanded{
                viewShow.isHidden = false
            }else{
                viewShow.isHidden = true
            }            
            
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewSocial.layer.borderColor = UIColor.border_color.cgColor
        self.viewSocial.layer.borderWidth = 1.0
        self.viewSocial.layer.cornerRadius = 3.0
        self.viewSocial.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
}
