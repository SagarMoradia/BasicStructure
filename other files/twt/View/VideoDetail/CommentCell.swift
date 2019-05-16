//
//  CommentCell.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 12/03/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class CommentCell: VideoCommentCell {
    
//    @IBOutlet weak var imgViewProfile: UIImageView!
//    @IBOutlet weak var lblUserName: UILabel!
//    @IBOutlet weak var lblTime: UILabel!
//    @IBOutlet weak var lblComment: UILabel!
//    @IBOutlet weak var lblLike: UILabel!
//    @IBOutlet weak var lblDisLike: UILabel!
//    @IBOutlet weak var lblCommentCount: UILabel!
//    @IBOutlet weak var imgLike: UIImageView!
//    @IBOutlet weak var imgDisLike: UIImageView!
//    @IBOutlet weak var imgComment: UIImageView!
//    @IBOutlet weak var btnCommentLike: UIControl!
//    @IBOutlet weak var btnCommentDisLike: UIControl!
//    @IBOutlet weak var btnCommentReply: UIControl!
//    @IBOutlet weak var btnCommentMore: UIButton!
    
    @IBOutlet weak var txtReply: UITextField!
    @IBOutlet weak var imgViewAuthorProfile: UIImageView!
    @IBOutlet weak var cntrlAuthorProfile: UIControl!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeBorder(yourView: imgViewProfile, cornerRadius: imgViewProfile.frame.height / 2, borderWidth: 0, borderColor: .clear, borderColorAlpha: 1.0)
        makeBorder(yourView: imgViewAuthorProfile, cornerRadius: imgViewAuthorProfile.frame.height / 2, borderWidth: 0, borderColor: .clear, borderColorAlpha: 1.0)
                
        txtReply.layer.cornerRadius = 3.0
        txtReply.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtReply.frame.height))
        txtReply.leftViewMode = .always
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        self.checkProfilePic()
    }
    
     
    fileprivate func checkProfilePic() {
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            imgViewAuthorProfile.frame = CGRect(x: 12.0, y:12, width: 24.0, height: 24.0)
            imgViewAuthorProfile.image = UIImage(named: Cons_Profile_Image_Name)
            imgViewAuthorProfile.contentMode = .scaleAspectFit
            imgViewAuthorProfile.layer.cornerRadius = imgViewAuthorProfile.frame.height / 2
            imgViewAuthorProfile.clipsToBounds = true
        }else{
            let profileURL = self.getUserDefault(KEYS_USERDEFAULTS.USER_PHOTO) as? String
            if self.verifyUrl(urlString: profileURL){
                imgViewAuthorProfile.frame = CGRect(x: 5.0, y:5, width: 36.0, height: 36.0)
                loadImageWith(imgView: imgViewAuthorProfile, url: profileURL)
                imgViewAuthorProfile.contentMode = .scaleAspectFill
                imgViewAuthorProfile.layer.cornerRadius = imgViewAuthorProfile.frame.height / 2
                imgViewAuthorProfile.clipsToBounds = true
            }else{
                imgViewAuthorProfile.frame = CGRect(x: 12.0, y:12, width: 24.0, height: 24.0)
                imgViewAuthorProfile.image = UIImage(named: Cons_Profile_Image_Name)
                imgViewAuthorProfile.contentMode = .scaleAspectFit
                imgViewAuthorProfile.layer.cornerRadius = imgViewAuthorProfile.frame.height / 2
                imgViewAuthorProfile.clipsToBounds = true
            }
        }
    }
    
    
}
