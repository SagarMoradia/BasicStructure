//
//  CellBlockedUsers.swift
//  TheWeedTube
//
//  Created by Hasya Panchasara on 01/05/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

class CellBlockedUsers: UITableViewCell {

    
    @IBOutlet weak var imgAuther: UIImageView!
    @IBOutlet weak var viewUserProfile: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var btnUnblock: UIButton!
    
    var objModelUser : BlockedUserlistDataAry!{
        didSet {
            //self.loadImageWith(imgView: imgAuther, url: objModelUser.profile_image ?? "", placeHolderImageName: PLACEHOLDER_IMAGENAME.small)
            
            let profileURL = objModelUser.profile_image ?? ""
            if verifyUrl(urlString: profileURL){
                imgAuther.frame = CGRect(x: 0.0, y: 0.0, width: 36.0, height: 36.0)
                loadImageWith(imgView: imgAuther, url: profileURL)
                imgAuther.contentMode = .scaleAspectFill
            }else{
                imgAuther.frame = CGRect(x: 7.0, y: 7.0, width: 22.0, height: 22.0)
                imgAuther.image = UIImage(named: Cons_Profile_Image_Name)
                imgAuther.contentMode = .scaleAspectFit
            }
            
            //sweta changes
            setDefaultPic(strImg: objModelUser.profile_image ?? "", imgView: imgAuther, strImgName: PLACEHOLDER_IMAGENAME.small)
            
            lblUserName.text = objModelUser.username?.HSDecode ?? ""
            
            let followers = objModelUser.total_followers ?? ""
            let fInt = Int(followers)
            let totalFollowers = self.suffixNumber(number:NSNumber.init(value: fInt ?? 0))
            lblFollowers.text = "\(totalFollowers) Subscribers"
            
            
                btnUnblock.backgroundColor = UIColor.theme_green.withAlphaComponent(0.1)
                btnUnblock.setTitleColor(UIColor.theme_green, for: .normal)
                btnUnblock.setTitle("Unblock", for: .normal)
           
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeBorder(yourView: viewUserProfile, cornerRadius: viewUserProfile.frame.height / 2, borderWidth: 0, borderColor: .clear, borderColorAlpha: 1.0)
        
        btnUnblock.layer.masksToBounds = true
        btnUnblock.layer.cornerRadius = 1.2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }

}
