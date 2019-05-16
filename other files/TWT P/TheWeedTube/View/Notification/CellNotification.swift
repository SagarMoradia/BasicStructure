//
//  CellMore.swift
//  TheWeedTube
//
//  Created by Hitesh Surani on 13/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class CellNotification: UITableViewCell {
    
    @IBOutlet weak var lblNotificationTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var imgVideoAuther: UIImageView!
    @IBOutlet weak var viewUserProfile: UIView!
    
    var objModelNotification : NotificationDataAry!{
        didSet {
            loadImageWith(imgView: imgVideo, url: objModelNotification.video_image, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
           
            
            lblNotificationTitle.text = objModelNotification.notification_text?.HSDecode
            
            lblTime.text = objModelNotification.created_at
            //loadImageWith(imgView: imgVideoAuther, url: objModelNotification.notifier_profile, placeHolderImageName: PLACEHOLDER_IMAGENAME.small)
            //sweta changes
//            setDefaultPic(strImg: objModelNotification.user_profile ?? "", imgView: imgVideoAuther, strImgName: PLACEHOLDER_IMAGENAME.small)
            let profileURL = objModelNotification.user_profile ?? ""
            
            
            if verifyUrl(urlString: profileURL){
                imgVideoAuther.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
                loadImageWith(imgView: imgVideoAuther, url: profileURL)
                imgVideoAuther.contentMode = .scaleAspectFill
            }else{
                
                imgVideoAuther.frame = CGRect(x: 7.0, y: 7.0, width: 21.0, height: 21.0)
                imgVideoAuther.image = UIImage(named: Cons_Profile_Image_Name)
                self.imgVideoAuther.contentMode = .scaleAspectFit
//                DispatchQueue.main.async {
//                }
            }
            
            
            if objModelNotification.is_new == "0"{
                contentView.backgroundColor = UIColor.white
            }else{
                contentView.backgroundColor = UIColor.init(red:17.0/255.0, green: 17.0/255.0, blue: 17.0/255.0, alpha: 0.09)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewUserProfile.layer.cornerRadius = viewUserProfile.frame.width / 2
        viewUserProfile.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    
  
}
