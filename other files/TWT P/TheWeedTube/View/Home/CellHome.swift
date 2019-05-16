//
//  CellMore.swift
//  TheWeedTube
//
//  Created by Hitesh Surani on 13/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class CellHome: CellHomeParent {
    
    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var lblVideoAutherName: UILabel!
    @IBOutlet weak var lblVideoDuration: UILabel!
    @IBOutlet weak var lblViewAndUploadTime: UILabel!
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var imgVideoAuther: UIImageView!
    @IBOutlet weak var viewUserProfile: UIControl!
    @IBOutlet weak var btnMore: UIControl!
    @IBOutlet weak var btnVideoDetail: UIButton!
    @IBOutlet weak var lblVideoCount : UILabel!
    @IBOutlet weak var imgVideoPlay : UIImageView!
    @IBOutlet weak var btnVideoName: UIButton!
    
    var objModelHome : HomeData!{
        didSet {
            lblVideoDuration.text = objModelHome.videoDuration
            loadImageWith(imgView: imgVideo, url: objModelHome.videoImage, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
            lblVideoTitle.text = objModelHome.videoTitle?.HSDecode
            lblVideoAutherName.text = objModelHome.videoAuthorName?.HSDecode
            lblVideoDuration?.text = objModelHome.videoDuration
            lblViewAndUploadTime.text = "\(objModelHome.videoViewes!) | \(objModelHome.videoUploadTime!)"
            //loadImageWith(imgView: imgVideoAuther, url: objModelHome.videoAuthorImage, placeHolderImageName: PLACEHOLDER_IMAGENAME.small)
            //sweta changes
            setDefaultPic(strImg: objModelHome.videoAuthorImage ?? "", imgView: imgVideoAuther, strImgName: PLACEHOLDER_IMAGENAME.small)
        }
    }
    
    //Sandip
    var objModelHomeParent : Model_VideoData!{
        didSet {
            
            var profileURL = String()
            
            if isFeaturedVideo{
                lblVideoDuration.text = self.timeFormatted(totalSeconds: objModelHomeParent.duration ?? 0)
                loadImageWith(imgView: imgVideo, url: objModelHomeParent.thumbnail_480)//https://assets-jpcust.jwpsrv.com/thumbnails/8frdppyz-720.jpg  // thumbnail_480  thumbnail
                lblVideoTitle.text = objModelHomeParent.title?.HSDecode
                lblVideoAutherName.text = objModelHomeParent.user_name?.HSDecode
                
                let totalViews = self.suffixNumber(number:NSNumber.init(value: Int(objModelHomeParent.view_count ?? "0") ?? 0))
                lblViewAndUploadTime.text = "\(totalViews) views | \(objModelHomeParent.publish_date ?? "-")"
                
                profileURL = objModelHomeParent.user_image ?? ""
                
            }else{
                
                lblVideoDuration.text = self.timeFormatted(totalSeconds: objModelHomeParent.duration ?? 0)
                loadImageWith(imgView: imgVideo, url: objModelHomeParent.thumbnail_480, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large  // image  thumbnail_480
                lblVideoTitle.text = objModelHomeParent.title?.HSDecode
                lblVideoAutherName.text = objModelHomeParent.user_name?.HSDecode
                
                let totalViews = self.suffixNumber(number:NSNumber.init(value: Int(objModelHomeParent.views ?? "0") ?? 0))
                lblViewAndUploadTime.text = "\(totalViews) views | \(objModelHomeParent.date ?? "-")"
                
                //setDefaultPic(strImg: objModelHomeParent.video_author_profile_pic ?? "", imgView: imgVideoAuther, strImgName: PLACEHOLDER_IMAGENAME.small)
                profileURL = objModelHomeParent.video_author_profile_pic ?? ""
            }
            
            if verifyUrl(urlString: profileURL){
                imgVideoAuther.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
                loadImageWith(imgView: imgVideoAuther, url: profileURL)
                imgVideoAuther.contentMode = .scaleAspectFill
            }else{
                imgVideoAuther.frame = CGRect(x: 7.0, y: 7.0, width: 21.0, height: 21.0)
                imgVideoAuther.image = UIImage(named: Cons_Profile_Image_Name)
                imgVideoAuther.contentMode = .scaleAspectFit
            }
        }
    }
    
    //Sagar //30Apr2019
    var objModelHomeParentNew : VideoData_Info!{
        
        didSet {
            var profileURL = String()
            if isFeaturedVideo{
                lblVideoDuration.text = self.timeFormatted(totalSeconds: objModelHomeParentNew.duration ?? 0)
                loadImageWith(imgView: imgVideo, url: objModelHomeParentNew.thumbnail_480)//https://assets-jpcust.jwpsrv.com/thumbnails/8frdppyz-720.jpg  // thumbnail_480  thumbnail
                lblVideoTitle.text = objModelHomeParentNew.title?.HSDecode
                lblVideoAutherName.text = objModelHomeParentNew.user_name?.HSDecode
                
                let totalViews = self.suffixNumber(number:NSNumber.init(value: Int(objModelHomeParentNew.view_count ?? "0") ?? 0))
                lblViewAndUploadTime.text = "\(totalViews) views | \(objModelHomeParentNew.publish_date ?? "-")"
                
                profileURL = objModelHomeParentNew.user_image ?? ""
            }
            else{
                lblVideoDuration.text = self.timeFormatted(totalSeconds: objModelHomeParentNew.duration ?? 0)
                loadImageWith(imgView: imgVideo, url: objModelHomeParentNew.thumbnail_480, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large  // image  thumbnail_480
                lblVideoTitle.text = objModelHomeParentNew.title?.HSDecode
                lblVideoAutherName.text = objModelHomeParentNew.user_name?.HSDecode
                
                let totalViews = self.suffixNumber(number:NSNumber.init(value: Int(objModelHomeParentNew.views ?? "0") ?? 0))
                lblViewAndUploadTime.text = "\(totalViews) views | \(objModelHomeParentNew.date ?? "-")"
                
                profileURL = objModelHomeParentNew.video_author_profile_pic ?? ""
            }
            
            if verifyUrl(urlString: profileURL){
                imgVideoAuther.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
                loadImageWith(imgView: imgVideoAuther, url: profileURL)
                imgVideoAuther.contentMode = .scaleAspectFill
            }else{
                imgVideoAuther.frame = CGRect(x: 7.0, y: 7.0, width: 21.0, height: 21.0)
                imgVideoAuther.image = UIImage(named: Cons_Profile_Image_Name)
                imgVideoAuther.contentMode = .scaleAspectFit
            }
        }
    }
    
    //MARK: - My Stash
    var objModelStash : statshData!{
        didSet {
            lblVideoDuration.text = self.timeFormatted(totalSeconds: Int(objModelStash.duration ?? "")!)
            loadImageWith(imgView: imgVideo, url: objModelStash.thumbnail_480, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large // thumbnail  thumbnail_480
            lblVideoTitle.text = objModelStash.title?.HSDecode
            lblVideoAutherName.text = objModelStash.username?.HSDecode
            
            let totalViews = self.suffixNumber(number:NSNumber.init(value: Int(objModelStash.view_count ?? "") ?? 0))
            lblViewAndUploadTime.text = "\(totalViews) views | \(objModelStash.publish_date ?? "-")"
            
            let profileURL = objModelStash.user_profile_image ?? ""
            if verifyUrl(urlString: profileURL){
                imgVideoAuther.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
                loadImageWith(imgView: imgVideoAuther, url: profileURL)
                imgVideoAuther.contentMode = .scaleAspectFill
            }else{
                imgVideoAuther.frame = CGRect(x: 7.0, y: 7.0, width: 21.0, height: 21.0)
                imgVideoAuther.image = UIImage(named: Cons_Profile_Image_Name)
                imgVideoAuther.contentMode = .scaleAspectFit
            }
            
//            //sweta changes
//            setDefaultPic(strImg: objModelStash.user_profile_image ?? "", imgView: imgVideoAuther, strImgName: PLACEHOLDER_IMAGENAME.small)
        }
    }
    
    //MARK: - Playlist
    var objModelPlaylist : playlistMainData!{
        didSet {
            lblVideoDuration.text = self.timeFormatted(totalSeconds: Int(objModelPlaylist.duration ?? "")!)
            loadImageWith(imgView: imgVideo, url: objModelPlaylist.thumbnail_480, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large // thumbnail  thumbnail_480
            lblVideoTitle.text = objModelPlaylist.title?.HSDecode
            lblVideoAutherName.text = objModelPlaylist.user_name?.HSDecode
            lblVideoCount.text = objModelPlaylist.srNum
        }
    }
    
    //MARK: - Feed
    var objModelFeed : FeedData!{
        didSet {
            let dduration = Double(objModelFeed.duration ?? "")
            let iduration = Int(dduration!)
            lblVideoDuration.text = self.timeFormatted(totalSeconds: iduration)//Int(objModelFeed.duration ?? "")!
            loadImageWith(imgView: imgVideo, url: objModelFeed.thumbnail_480, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large // thumbnail  thumbnail_480
            lblVideoTitle.text = objModelFeed.title?.HSDecode
            lblVideoAutherName.text = objModelFeed.username?.HSDecode
        
            let totalViews = self.suffixNumber(number:NSNumber.init(value: Int(objModelFeed.view_count ?? "") ?? 0))
            lblViewAndUploadTime.text = "\(totalViews) views | \(objModelFeed.publish_date ?? "-")"
            
            let profileURL = objModelFeed.user_image ?? ""
            if verifyUrl(urlString: profileURL){
                imgVideoAuther.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
                loadImageWith(imgView: imgVideoAuther, url: profileURL)
                imgVideoAuther.contentMode = .scaleAspectFill
            }else{
                imgVideoAuther.frame = CGRect(x: 7.0, y: 7.0, width: 21.0, height: 21.0)
                imgVideoAuther.image = UIImage(named: Cons_Profile_Image_Name)
                imgVideoAuther.contentMode = .scaleAspectFit
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(viewUserProfile != nil){
            makeBorder(yourView: viewUserProfile, cornerRadius: viewUserProfile.frame.height / 2, borderWidth: 0, borderColor: .clear, borderColorAlpha: 1.0)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}

//MARK: - ViewAddStash Popup Methods
class CellHomeParent: UITableViewCell {
    
    //Callback
    var handler: indexHandlerBlock!
    var strSelectedVideoId = ""
    var strUserID = ""
    var strAddToStashType = AddToStash_TYPE.Home
    var isForOwnProfile = Bool()
    var selectedVideo: videoListData!
    var indexPath : IndexPath!
    var isFeaturedVideo = Bool()
    
    @IBAction func btnMoreTap(sender:UIControl){
        
        DispatchQueue.main.async {
            let viewAddStash = Bundle.loadView(fromNib: "AddToStashActionSheet", withType: AddToStashActionSheet.self)
            viewAddStash.frame = UIScreen.main.bounds
            viewAddStash.strSelectedVideoId = self.strSelectedVideoId
            viewAddStash.strAddToStashType = self.strAddToStashType
            
            if(self.handler != nil){
                viewAddStash.handler = self.handler
            }
            
            if self.isForOwnProfile{
                viewAddStash.isForOwnProfile = self.isForOwnProfile
                viewAddStash.selectedVideo = self.selectedVideo
            }
            viewAddStash.setupUI()
            
            //SMP:Change
            viewAddStash.addSubviewWithAnimationBottom(animation: {
            }, completion: {
            })
        }
    }
    
    @IBAction func btnProfileTap(sender:UIControl){
        
        let strUserUUID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID)
        if strUserUUID != nil{
            //not allowed for own profile
            if strUserID != ""{ //(strUserUUID as! String) != strUserID &&
                if strUserID == (strUserUUID as! String){
                    self.redirectToProfileScreen(isForOwn: true)
                }
                else{
                    self.redirectToProfileScreen(isForOwn: false)
                }
            }
        }else{
            if strUserID != ""{
                self.redirectToProfileScreen(isForOwn: false)
            }
        }
        
    }
    
    func redirectToProfileScreen(isForOwn: Bool){
        let viewController = UIStoryboard.init(name: ("Main"), bundle: nil).instantiateViewController(withIdentifier: "ProfileMainVC") as! ProfileMainVC
        viewController.hidesBottomBarWhenPushed = true
        viewController.user_uuid = strUserID
        viewController.isForOwnProfile = isForOwn
        let topNavigationVC = UIApplication.topViewController()
        topNavigationVC?.navigationController?.pushViewController(viewController, animated: true)
    }
}
