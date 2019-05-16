//
//  VideoDetailsCell.swift
//  TheWeedTube
//
//  Created by Vivek Bhoraniya on 05/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit
import WebKit

class VideoDetailsCell: CellHomeParent, WKNavigationDelegate {

    @IBOutlet weak var constraintWebHeight: NSLayoutConstraint!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var viewWeb: WKWebView!
    
    @IBOutlet weak var btnLike: UIControl!
    @IBOutlet weak var btnDisLike: UIControl!
    @IBOutlet weak var btnShare: UIControl!
    @IBOutlet weak var btnAddTo: UIControl!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnFollow: UIButton!
    var heightForWebView = 0.0
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblViewsCount: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblDislikeCount: UILabel!
    @IBOutlet weak var imgViewUserPic: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFollowersCount: UILabel!
    
    @IBOutlet weak var imageViewLike: UIImageView!
    @IBOutlet weak var imageViewDisLike: UIImageView!
    
    @IBOutlet weak var lblPublishDate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var conHeight: NSLayoutConstraint!
    @IBOutlet weak var swtchAutoPlay: PVSwitch!
    @IBOutlet weak var lblAutoPlay: UILabel!
    
    @IBOutlet weak var txtDesc: UITextView!
    
    var aryCategory = [String]()
    
    var modelVideoDetailData : Model_VideoDetailData?{
        didSet {
            
            self.lblTitle.text = modelVideoDetailData?.title?.HSDecode ?? ""
            
            let totalViews = self.suffixNumber(number:NSNumber.init(value: modelVideoDetailData?.view_count ?? 0))
            self.lblViewsCount.text = "\(totalViews) views"
            
            //loadImageWith(imgView: imgViewUserPic, url: modelVideoDetailData?.thumbnail ?? "", placeHolderImageName: PLACEHOLDER_IMAGENAME.small)
            //sweta changes
            setDefaultPic(strImg: modelVideoDetailData?.profile_image_100x100 ?? "", imgView: imgViewUserPic, strImgName: PLACEHOLDER_IMAGENAME.small)
                        
            let userName = modelVideoDetailData?.username?.HSDecode ?? ""
            
            self.lblUserName.text = userName.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let totalFollowers = self.suffixNumber(number:NSNumber.init(value: modelVideoDetailData?.total_followers ?? 0))
            self.lblFollowersCount.text = "\(totalFollowers) Subscribers"
         
            //self.lblDesc.text = self.modelVideoDetailData?.description ?? "" //sam
            
         //   self.txtDesc.text = self.modelVideoDetailData?.desc_mobile ?? ""
            
            // HP
            

      //      let htmlDescriptionStr = NSString(format:"<span style=\"font-family: '-apple-system', 'InterUI-Regular'; font-size: \(14)\">%@</span>" as NSString, self.modelVideoDetailData?.desc_mobile ?? "") as String
            
      //      let htmlDescriptionStr = NSString(format:"<span style=\"font-family: '-apple-system', 'InterUI-Regular'; font-size: \(14)\ color:\(#868686))"">%@</span>" as NSString, self.modelVideoDetailData?.desc_mobile ?? "") as String
            
            //InterUI-Regular 14.0
            
            
          //  let modifiedFont = NSString(format:"<span style=\"color:\(UIColor.lightGray);font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize)\">%@</span>", self.modelVideoDetailData?.desc_mobile ?? "") as String

            
                // self.modelVideoDetailData?.desc_mobile ?? ""
//            let theAttributedDescString = try! NSAttributedString(
//                data: htmlDescriptionStr.data(using: .unicode, allowLossyConversion: true)!,
//                options:[.documentType: NSAttributedString.DocumentType.html,
//                         .characterEncoding: String.Encoding.utf8.rawValue],
//                documentAttributes: nil)
            
            var strHTML : String = self.modelVideoDetailData?.description ?? ""
                
                strHTML = strHTML.replacingOccurrences(of: "\n", with: "<br>")
            
            self.txtDesc.setHTMLFromString(text: strHTML)
            
            // HP
            
            
//            self.txtDesc.text = "This video is uploaded by Sagar http://google.com For more information https://facebook.com Please visit my website www.yahoo.com brainvire.com"
            
            self.lblPublishDate.text = "Published on \(modelVideoDetailData?.publish_date ?? "")"
            aryCategory = [String]()
            let arrCategory = self.modelVideoDetailData?.category ?? []
            for arrName in arrCategory{
                let strCatName = arrName.name
                aryCategory.append(strCatName ?? "")
            }
            self.lblCategory.text = aryCategory.joined(separator: ",")
            
            self.updateLikeDislikeSelection()
            self.updateFollowButtonUI()
            
            let strUserUUID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID)
            if strUserUUID != nil{
                if (strUserUUID as! String) == modelVideoDetailData?.user_uuid{
                    btnFollow.isHidden = true
                }else{
                    btnFollow.isHidden = false
                }
            }
        }
    }
    
    func updateFollowButtonUI() {
        let strIsFollow = self.modelVideoDetailData?.is_follow?.lowercased()
        if strIsFollow == "yes"{
            self.btnFollow.setTitle("Unsubscribe", for: .normal)
            self.btnFollow.backgroundColor = UIColor.theme_green.withAlphaComponent(0.1)
            self.btnFollow.setTitleColor(UIColor.theme_green, for: .normal)
        }else{
            self.btnFollow.setTitle("Subscribe", for: .normal)
            self.btnFollow.backgroundColor = UIColor.theme_green
            self.btnFollow.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func updateLikeDislikeSelection(){
        
        if(modelVideoDetailData?.is_like?.lowercased() == "yes"){
            self.imageViewLike.image = UIImage.init(named: "like")
            self.imageViewDisLike.image = UIImage.init(named: "dislike_gray")
        }
        else if(modelVideoDetailData?.is_like?.lowercased() == "no"){
            self.imageViewLike.image = UIImage.init(named: "like_gray")
            self.imageViewDisLike.image = UIImage.init(named: "dislike")
        }
        else{
            self.imageViewLike.image = UIImage.init(named: "like_gray")
            self.imageViewDisLike.image = UIImage.init(named: "dislike_gray")
        }
        
        let totalLikes = self.suffixNumber(number:NSNumber.init(value: modelVideoDetailData?.like_count ?? 0))
        self.lblLikeCount.text = totalLikes
        
        let totalDisLikes = self.suffixNumber(number:NSNumber.init(value: modelVideoDetailData?.dislike_count ?? 0))
        self.lblDislikeCount.text = totalDisLikes
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        makeBorder(yourView: imgViewUserPic, cornerRadius: imgViewUserPic.frame.height / 2, borderWidth: 0, borderColor: .clear, borderColorAlpha: 1.0)
        self.txtDesc.dataDetectorTypes = UIDataDetectorTypes.all
        
        
        let urlString:URL = URL.init(string: "https://www.google.com/")!
        let urlRequest :URLRequest = URLRequest.init(url: urlString)
        viewWeb.navigationDelegate = self
        viewWeb.load(urlRequest)
        viewWeb.scrollView.addObserver(self, forKeyPath: "contentSize", options:[] , context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize")
        {
            
            let scrollView:UIScrollView = object as! UIScrollView
            self.heightForWebView = Double(scrollView.contentSize.height)
            print(scrollView.contentSize.height)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            print(webView.scrollView.contentSize)
        })
//        self.viewWeb.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
//            if complete != nil {
//                self.viewWeb.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
//                    self.heightForWebView = height as! Double
//                })
//            }
//
//        })
    }
    
    func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!) {
        
        print(webView.scrollView.contentSize.height)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        selectionStyle = .none
    }
    
    
    
}


extension UITextView {
    func setHTMLFromString(text: String) {
        let modifiedFont = NSString(format:"<span style=\"color:\(UIColor.textColor_gray);font-family: '-apple-system', 'InterUI-Regular'; font-size: \(14)\">%@</span>" as NSString, text) as String
        
    //  text = text.replacingOccurrences(of: " ", with: "+")
        
        let theAttributedDescString = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options:[.documentType: NSAttributedString.DocumentType.html,
                     .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = theAttributedDescString
    }
}
