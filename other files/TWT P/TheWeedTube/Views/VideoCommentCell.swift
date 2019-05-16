// Doubt
//  VideoCommentCell.swift
//  TheWeedTube
//
//  Created by Vivek Bhoraniya on 14/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class VideoCommentCell: UITableViewCell {

    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblDisLike: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var imgDisLike: UIImageView!
    @IBOutlet weak var imgComment: UIImageView!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var cntrlProfile: UIControl!
    @IBOutlet weak var btnCommentLike: UIControl!
    @IBOutlet weak var btnCommentDisLike: UIControl!
    @IBOutlet weak var btnCommentReply: UIControl!
    @IBOutlet weak var btnCommentMore: UIButton!
    @IBOutlet weak var conHeightReply: NSLayoutConstraint!
    
    var modelCommentListingData : Model_CommentListingData?{
        didSet {
            self.lblUserName.text = modelCommentListingData?.user_username ?? ""
            self.lblTime.text = modelCommentListingData?.created_at ?? ""
            //sweta changes
//            setDefaultPic(strImg: modelCommentListingData?.profile_photo ?? "", imgView: imgViewProfile, strImgName: PLACEHOLDER_IMAGENAME.small)
            let profileURL = modelCommentListingData?.profile_photo ?? ""
            if verifyUrl(urlString: profileURL){
                imgViewProfile.frame = CGRect(x: 0.0, y: 0.0, width: 36.0, height: 36.0)
                loadImageWith(imgView: imgViewProfile, url: profileURL)
                imgViewProfile.contentMode = .scaleAspectFill
            }else{
                imgViewProfile.frame = CGRect(x: 7.0, y: 7.0, width: 22.0, height: 22.0)
                imgViewProfile.image = UIImage(named: Cons_Profile_Image_Name)
                imgViewProfile.contentMode = .scaleAspectFit
            }
            
            let comment = modelCommentListingData?.comment ?? ""
            self.lblComment.text = comment.stringByDecodingHTMLEntities
            
//            self.lblComment.text = modelCommentListingData?.comment ?? ""
            
            let replyCount = NSNumber.init(value: Int(modelCommentListingData?.reply_count ?? "0")!)
            let replyCountText = self.suffixNumber(number:replyCount)
            self.lblCommentCount.text = replyCountText
            
            if(conHeightReply != nil){
                if(replyCount.intValue > 0){
                    conHeightReply.constant = 30
                    let btnReplyTitle = replyCount.intValue > 1 ? "VIEW \(replyCount.intValue) REPLIES" : "VIEW REPLY"
                    btnReply.setTitle(btnReplyTitle, for: .normal)
                }
                else{
                    conHeightReply.constant = 0
                }
            }
            
            self.updateLikeDislikeSelection()
            
            let strUserUUID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID)
            if strUserUUID != nil{
                if (strUserUUID as! String) == modelCommentListingData?.user_uuid{
                    btnCommentMore.isHidden = false
                }else{
                    btnCommentMore.isHidden = true
                }
            }
           
        }
    }
    
    func updateLikeDislikeSelection(){
        
        if(modelCommentListingData?.is_like?.lowercased() == "yes"){
            self.imgLike.image = UIImage.init(named: "like")
            self.imgDisLike.image = UIImage.init(named: "dislike_gray")
            
//            self.btnCommentLike.isEnabled = false
//            self.btnCommentDisLike.isEnabled = true
        }
        else if(modelCommentListingData?.is_like?.lowercased() == "no"){
            self.imgLike.image = UIImage.init(named: "like_gray")
            self.imgDisLike.image = UIImage.init(named: "dislike")

//            self.btnCommentLike.isEnabled = true
//            self.btnCommentDisLike.isEnabled = false
        }
        else{
            self.imgLike.image = UIImage.init(named: "like_gray")
            self.imgDisLike.image = UIImage.init(named: "dislike_gray")
            
//            self.btnCommentLike.isEnabled = true
//            self.btnCommentDisLike.isEnabled = true
        }
        
        let totalLikes = self.suffixNumber(number:NSNumber.init(value: Int(modelCommentListingData?.like_count ?? "0")!))
        self.lblLike.text = totalLikes
        
        let totalDisLikes = self.suffixNumber(number:NSNumber.init(value: Int(modelCommentListingData?.dislike_count ?? "0")!))
        self.lblDisLike.text = totalDisLikes
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        makeBorder(yourView: imgViewProfile, cornerRadius: imgViewProfile.frame.height / 2, borderWidth: 0, borderColor: .clear, borderColorAlpha: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        selectionStyle = .none
    }
    
}

extension String {
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil).string
        
        return decoded ?? self
    }
}


private let characterEntities : [ Substring : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",

    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]

extension String {

    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {

        // ===== Utility functions =====

        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : Substring, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }

        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : Substring) -> Character? {

            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return characterEntities[entity]
            }
        }

        // ===== Method starts here =====

        var result = ""
        var position = startIndex

        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self[position...].range(of: "&") {
            result.append(contentsOf: self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound

            // Find the next ';' and copy everything from '&' to ';' into `entity`
            guard let semiRange = self[position...].range(of: ";") else {
                // No matching ';'.
                break
            }
            let entity = self[position ..< semiRange.upperBound]
            position = semiRange.upperBound

            if let decoded = decode(entity) {
                // Replace by decoded character:
                result.append(decoded)
            } else {
                // Invalid entity, copy verbatim:
                result.append(contentsOf: entity)
            }
        }
        // Copy remaining characters to `result`:
        result.append(contentsOf: self[position...])
        return result
    }
}
