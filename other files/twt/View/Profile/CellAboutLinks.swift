//
//  CellAboutLinks.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 18/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class CellAboutLinks: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
    
    fileprivate let aryAllSocialName = ["FACEBOOK","TWITTER","INSTAGRAM","SNAPCHAT"]//FTIS ==> FIST
    fileprivate var arySocials = [NSDictionary]()
    fileprivate var aryToCollection = [classSocial]()
    @IBOutlet weak var clvLinks: UICollectionView!
    @IBOutlet weak var lblLinks: blackLabelCtrlModel!
    @IBOutlet weak var viewSeparator: UIView!
    
    
    fileprivate var arySocialName = [String]()
    //fileprivate var arySocialUrl = [String].init(repeating: "", count: 3)
    fileprivate var arySocialUrl = [String]()
    
    var aryLinks:[Social_accounts]!{
        didSet {
            
            self.arySocials = [NSDictionary]()
            for obj in aryLinks{
                let strUrl = obj.social_media_url ?? ""
                if strUrl != ""{
                    let strSocialName = obj.social_media_name ?? ""
                    let dict = ["s_name":strSocialName,"s_url":strUrl] as NSDictionary
                    self.arySocials.append(dict)
                }
            }
            
//            aryToCollection = [classSocial]()
//            arySocialUrl = [String].init(repeating: "", count: 4)
//            for objSocial_accounts in aryLinks{
//                //aryToCollection.append(classSocial(objSocial_accounts: objSocial_accounts))
//                arySocialName.append((objSocial_accounts.social_media_name ?? "").uppercased())
//                //sweta changes
//                let strName = objSocial_accounts.social_media_name
//                let strUrl = objSocial_accounts.social_media_url
//                if aryAllSocialName.contains(strName!){
//                    if strName == Profile.FACEBOOK{
//                        arySocialUrl[0] = strUrl!
//                    }
//                    if strName == Profile.TWITTER{
//                        arySocialUrl[1] = strUrl!
//                    }
//                    if strName == Profile.INSTAGRAM{
//                        arySocialUrl[2] = strUrl!
//                    }
//                    if strName == Profile.SNAPCHAT{
//                        arySocialUrl[3] = strUrl!
//                    }
//                }
//            }
//
//            print(arySocialUrl)
            
            if arySocials.count == 0{
                self.lblLinks.isHidden = true
                self.viewSeparator.isHidden = true
            }
            else{
                self.lblLinks.isHidden = false
                self.viewSeparator.isHidden = false
            }
            
            self.clvLinks.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clvLinks.register(UINib.init(nibName: "CellLinkButton", bundle: nil), forCellWithReuseIdentifier: "CellLinkButton_ID")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - UICollectionView DataSource and Deletgate Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 72.5, height: 36.0)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return aryToCollection.count
        //return aryAllSocialName.count
        return self.arySocials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = clvLinks.dequeueReusableCell(withReuseIdentifier:"CellLinkButton_ID", for: indexPath) as! CellLinkButton
        
        let dict = self.arySocials[indexPath.item]
        
        var name = dict["s_name"] as! String
        name = name.lowercased()
        
        if name == Profile.FACEBOOK.lowercased(){
            cell.imgvBtn.image = UIImage.init(named: "facebook_h")
        }
        else if name == Profile.TWITTER.lowercased(){
            cell.imgvBtn.image = UIImage.init(named: "twitter_h")
        }
        else if name == Profile.INSTAGRAM.lowercased(){
            cell.imgvBtn.image = UIImage.init(named: "instagram_h")
        }
        else if name == Profile.SNAPCHAT.lowercased(){
            cell.imgvBtn.image = UIImage.init(named: "snapchat_h")
        }
        else{
            cell.imgvBtn.image = UIImage.init(named: "")
        }
        
//        //sweta changes
//        let strName = aryAllSocialName[indexPath.item]
//        let strUrl = arySocialUrl[indexPath.item]
//        if strName == Profile.FACEBOOK{
//            if strUrl == ""{
//                cell.imgvBtn.isHidden = true
//                cell.imgvBtn.image = UIImage.init(named: "facebook")
//            }else{
//                cell.imgvBtn.isHidden = false
//                cell.imgvBtn.image = UIImage.init(named: "facebook_h")
//            }
//        }
//        if strName == Profile.TWITTER{
//            if strUrl == ""{
//                cell.imgvBtn.isHidden = true
//                cell.imgvBtn.image = UIImage.init(named: "twitter")
//            }else{
//                cell.imgvBtn.isHidden = false
//                cell.imgvBtn.image = UIImage.init(named: "twitter_h" )
//            }
//        }
//        if strName == Profile.INSTAGRAM{
//            if strUrl == ""{
//                cell.imgvBtn.isHidden = true
//                cell.imgvBtn.image = UIImage.init(named: "instagram")
//            }else{
//                cell.imgvBtn.isHidden = false
//                cell.imgvBtn.image = UIImage.init(named: "instagram_h" )
//            }
//        }
//        if strName == Profile.SNAPCHAT{
//            if strUrl == ""{
//                cell.imgvBtn.isHidden = true
//                cell.imgvBtn.image = UIImage.init(named: "snapchat")
//            }else{
//                cell.imgvBtn.isHidden = false
//                cell.imgvBtn.image = UIImage.init(named: "snapchat_h" )
//            }
//        }
        
        
        cell.btnLink.tag = indexPath.row
        cell.btnLink.addTarget(self, action: #selector(actionLinkTapped(sender:)), for: UIControl.Event.touchUpInside)
        //cell.objclassSocial = aryToCollection[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @objc func actionLinkTapped(sender: UIButton){
        
//        let strUrl = arySocialUrl[sender.tag]
//        let strName = aryAllSocialName[sender.tag]
//        print("\(strName) tapped")
        
        let dict = self.arySocials[sender.tag]
        var strUrl = dict["s_url"] as! String
        
        if dict["s_name"] as! String == "INSTAGRAM"{
     
            if !strUrl.contains("https://www.instagram.com/") {
                strUrl = "https://www.instagram.com/" + strUrl
            }
     
        }
        else if dict["s_name"] as! String == "TWITTER"{
            
            if !strUrl.contains("https://www.twitter.com/") {
                strUrl = "https://www.twitter.com/" + strUrl
            }
            
        }
        else if dict["s_name"] as! String == "FACEBOOK"{
            
            if !strUrl.contains("https://www.facebook.com/") {
                strUrl = "https://www.facebook.com/" + strUrl
            }
            
        }
        else if dict["s_name"] as! String == "SNAPCHAT"{
            
            if !strUrl.contains("https://www.snapchat.com/add/") {
                strUrl = "https://www.snapchat.com/add/" + strUrl
            }
       
        }
        
        if strUrl != ""{
         
            if self.verifyUrl(urlString: strUrl){

                guard let url = URL(string: strUrl) else { return }
                UIApplication.shared.open(url)

            }else{

                Alert.shared.showAlert(title: App_Name, message: Cons_Invalid_Url)
            }

            
        }
    }
}


extension String {
    mutating func insert(string:String,ind:Int) {
        self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
    }
}
