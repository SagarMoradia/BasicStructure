//
//  ProfileMainVC.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 15/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

struct Profile {
    static let FACEBOOK = "FACEBOOK"
    static let TWITTER = "TWITTER"
    static let INSTAGRAM = "INSTAGRAM"
    static let SNAPCHAT = "SNAPCHAT"
}

let headerHeight = CGFloat(230.0)

class ProfileMainVC: ParentVC, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    var arrVideos   = [videoListData]()
    var arrPlaylist = [playlistDataAry]()
    
    @IBOutlet weak var lblNoData: darkGreyLabelCtrlModel!
    @IBOutlet weak var btnEditProfile: UIButton!
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var topConstant: NSLayoutConstraint!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var tblvMain: UITableView!
    @IBOutlet weak var tblTopConst: NSLayoutConstraint!
    @IBOutlet weak var lblDropDownSelect: UILabel!
    
    lazy var topView = Bundle.loadView(fromNib:"ProfileTopView", withType: ProfileTopView.self)
    lazy var tabView = Bundle.loadView(fromNib:"ProfileTabView", withType: ProfileTabView.self)
    var currentPage = 0
    var dictProfileAbout : ProfileData!
    var currentPageOffset: Int = 0
    var totalRecords: Int = 0
    var isForOwnProfile = false
    var user_uuid: String = ""
    
    var handler: indexHandlerBlock!
    
    //MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoData.isHidden = true
        navigationController!.navigationBar.isTranslucent = true
        self.setupPagination()
        self.setupRightbarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        self.prepareViews()
        navigationController!.navigationBar.isTranslucent = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifyForProfile(_:)), name: NSNotification.Name(rawValue: NOTIFICATION_NAME.VideoNotification), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    //MARK: - Intial Methods
    private func setupRightbarButton(){
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "more_white"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(actionBlock(sender:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        if isForOwnProfile{
            self.btnEditProfile.isHidden = false
            btn1.isHidden = true
        }else{
            self.btnEditProfile.isHidden = true
            btn1.isHidden = false
            self.navigationItem.setRightBarButtonItems([item1], animated: false)
        }
    }
    
    private func prepareViews() {
        
        let statusBarSize = UIApplication.shared.statusBarFrame.size.height
        let navBarSize = self.navigationController?.navigationBar.frame.size.height ?? 44.0
        heightConstant.constant = navBarSize + statusBarSize
        
        //About Cells
        tblvMain.register(UINib.init(nibName: "CellProfileTop", bundle: nil), forCellReuseIdentifier: "CellProfileTop_ID")
        tblvMain.register(UINib.init(nibName: "CellAboutStatus", bundle: nil), forCellReuseIdentifier: "CellAboutStatus_ID")
        tblvMain.register(UINib.init(nibName: "CellAboutLinks", bundle: nil), forCellReuseIdentifier: "CellAboutLinks_ID")//sam
        tblvMain.register(UINib.init(nibName: "CellProfileAbout", bundle: nil), forCellReuseIdentifier: "CellProfileAbout_ID")
        
        //Video Cells
        tblvMain.register(UINib.init(nibName: "CellHome", bundle: nil), forCellReuseIdentifier: "ID_CellHome")
        
        //Playlist Cells
        tblvMain.register(UINib.init(nibName: "CellPlaylist_1", bundle: nil), forCellReuseIdentifier: "ID_CellPlaylist_1")
        tblvMain.register(UINib.init(nibName: "CellPlaylist_2", bundle: nil), forCellReuseIdentifier: "ID_CellPlaylist_2")
        tblvMain.register(UINib.init(nibName: "CellPlaylist_3", bundle: nil), forCellReuseIdentifier: "ID_CellPlaylist_3")
    
        self.tblvMain.isHidden = true
        
        if GLOBAL.sharedInstance.isFromNotification{
            self.user_uuid = GLOBAL.sharedInstance.Notification_uuid
            GLOBAL.sharedInstance.isFromNotification = false
        }
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            self.callGetVisitorProfileAPI()
        }else{
            self.callGetProfileAPI()
        }
    }
    
    fileprivate func setupPagination() {
        
        // Add infinite scroll handler
        tblvMain.addInfiniteScroll { [weak self] (tableView) -> Void in
            
            guard let tempSelf = self else{
                return
            }
            
            tempSelf.callAPIs(inMainthread: false)
        }
        
        if currentPage == 0{
            tblvMain.setShouldShowInfiniteScrollHandler { _ -> Bool in
                return self.totalRecords > self.arrVideos.count
            }
        }else if currentPage == 1{
            tblvMain.setShouldShowInfiniteScrollHandler { _ -> Bool in
                return self.totalRecords > self.arrPlaylist.count
            }
        }
    }
    
    @objc func notifyForProfile(_ notification: NSNotification){
        if notification.name.rawValue == NOTIFICATION_NAME.ProfileNotification{
            self.prepareViews()
        }
    }
    
    //MARK: - Button Event Methods
    @objc func actionVideoDetail(sender: UIButton){
        let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
        vcDetail.strSelectedVideoId = arrVideos[sender.tag].uuid ?? ""
        vcDetail.isFromPlaylist = false
//        self.navigationController?.present(vcDetail, animated: true, completion: nil)
        vcDetail.hidesBottomBarWhenPushed = true
        self.pushVCWithPresentAnimation(controller: vcDetail)
    }
    
    //MARK: - Tableview Datasource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            if self.isForOwnProfile {
                return headerHeight-42.0
            }else{
                return headerHeight
            }
        }else{
            return 45
            //return currentPage == 1 ? 87.0 : 45.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
            topView.btnSubscribe.isHidden = true
            topView.btnBlockUnblock.isHidden = true
            
            let profileURL = self.dictProfileAbout?.user_data?.profile_photo ?? ""
            if self.verifyUrl(urlString: profileURL){
                loadImageWith(imgView: topView.imgvProfile, url: profileURL)
                topView.imgvProfile.contentMode = .scaleAspectFill
            }else{
                topView.imgvProfile.image = UIImage(named: Cons_Profile_Image_Name)
                topView.imgvProfile.contentMode = .center
            }
            
            let coverURL = self.dictProfileAbout?.user_data?.cover_photo ?? ""
            if self.verifyUrl(urlString: coverURL){
                loadImageWith(imgView: topView.imgvCover, url: coverURL)
                topView.imgvCover.contentMode = .scaleAspectFill
            }else{
                //topView.imgvCover.image = UIImage(named: PLACEHOLDER_IMAGENAME.Large)
                topView.imgvCover.contentMode = .scaleAspectFit
            }
            
//            let fName = self.dictProfileAbout?.user_data?.first_name ?? ""
//            let lName = self.dictProfileAbout?.user_data?.last_name ?? ""
            
            topView.lblName.text = self.dictProfileAbout?.user_data?.username ?? ""
            
//            let subsribers:NSNumber? = NSNumber(value: Float32(self.dictProfileAbout?.user_data?.total_followers ?? 0))
//            var totalSubsribers = self.suffixNumber(number:subsribers!)
            let totalSubsribers = self.dictProfileAbout?.user_data?.total_followers ?? 0
            topView.lblFollowers.text = String(totalSubsribers)+" Subscribers"
            
            if self.isForOwnProfile{
                topView.viewEmail.isHidden = true
                topView.lblEmailID.isHidden = true
                topView.imgMailIcon.isHidden = true
                topView.btnSubscribe.isHidden = true
                topView.btnBlockUnblock.isHidden = true
                //let emailID = self.dictProfileAbout?.user_data?.email ?? ""
                topView.lblEmailID.text = "Subscribe newsletter"//emailID
                let news = self.dictProfileAbout?.user_data?.subscribe_newsletter ?? ""
                if news == "true"{
                    topView.imgMailIcon.image = UIImage(named : "Check")
                }else{
                    topView.imgMailIcon.image = UIImage(named : "Uncheck")
                }
            }else{
                topView.viewEmail.isHidden = false
                topView.lblEmailID.isHidden = true
                topView.imgMailIcon.isHidden = true
                topView.btnSubscribe.isHidden = false
                
//                if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) != nil
//                {
//                    topView.btnBlockUnblock.isHidden = false
//                    topView.btnSubscribeLeadConst.constant = 15.0
//                }
//                else
//                {
//                    topView.btnBlockUnblock.isHidden = true
//                    topView.btnSubscribeLeadConst.constant = (SCREEN_WIDTH/2)-(topView.btnSubscribe.frame.width/2)
//                }
                
                
                let sInt = self.dictProfileAbout?.user_data?.total_followers ?? 0
                let total = self.suffixNumber(number:NSNumber.init(value: sInt))
                let is_follow = self.dictProfileAbout?.user_data?.is_follow ?? ""
//                let is_block = self.dictProfileAbout?.user_data?.is_block ?? ""
                
                if is_follow.lowercased() == "yes"{
                    topView.btnSubscribe.backgroundColor = UIColor.theme_green.withAlphaComponent(0.1)
                    topView.btnSubscribe.setTitleColor(UIColor.theme_green, for: .normal)
                    topView.btnSubscribe.setTitle("Unsubscribe \(total)", for: .normal)
                }else{
                    topView.btnSubscribe.backgroundColor = UIColor.theme_green
                    topView.btnSubscribe.setTitleColor(UIColor.white, for: .normal)
                    topView.btnSubscribe.setTitle("Subscribe \(total)", for: .normal)
                }
                
//                if is_block.lowercased() == "yes"{
//                    topView.btnBlockUnblock.backgroundColor = UIColor.theme_green.withAlphaComponent(0.1)
//                    topView.btnBlockUnblock.setTitleColor(UIColor.theme_green, for: .normal)
//                    topView.btnBlockUnblock.setTitle("Unblock", for: .normal)
//                }else{
//                    topView.btnBlockUnblock.backgroundColor = UIColor.theme_green
//                    topView.btnBlockUnblock.setTitleColor(UIColor.white, for: .normal)
//                    topView.btnBlockUnblock.setTitle("Block", for: .normal)
//                }
                
                topView.btnSubscribe.addTarget(self, action: #selector(actionSubsribeTap(_:)), for: .touchUpInside)
//                topView.btnBlockUnblock.addTarget(self, action: #selector(actionBlockUnblockTap(_:)), for: .touchUpInside)
                
                
            }
            
            return topView
            
        }else{
            tabView.ctrlVideos.addTarget(self, action: #selector(btnTabChanged(_:)), for: .touchUpInside)
            tabView.ctrlPlayList.addTarget(self, action: #selector(btnTabChanged(_:)), for: .touchUpInside)
            tabView.ctrlAbout.addTarget(self, action: #selector(btnTabChanged(_:)), for: .touchUpInside)
            tabView.ctrlFilter.addTarget(self, action: #selector(actionDropDownTap(_:)), for: .touchUpInside)
            tabView.clipsToBounds = true
            return tabView
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }else{
            
            if self.dictProfileAbout != nil{
                let isBlock = self.dictProfileAbout.user_data?.is_block ?? ""
                if isBlock.lowercased() == "yes"{
                    return 0
                }
                else{
                    if self.currentPage == 0{ //Videos
                        return arrVideos.count
                    }else if self.currentPage == 1{ //Playlists
                        return self.arrPlaylist.count
                    }else if self.currentPage == 2{ //About
                        return 3
                    }else{
                        return 0
                    }
                }
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            return cell
        }else {
            if self.currentPage == 0 {
                
                let cell = tblvMain.dequeueReusableCell(withIdentifier: "ID_CellHome", for: indexPath) as! CellHome
                cell.textLabel?.backgroundColor = UIColor.clear
                
                cell.btnVideoDetail.tag = indexPath.row
                cell.btnVideoDetail.addTarget(self, action: #selector(actionVideoDetail(sender:)), for: UIControl.Event.touchUpInside)
                cell.btnVideoName.tag = indexPath.row
                cell.btnVideoName.addTarget(self, action: #selector(actionVideoDetail(sender:)), for: UIControl.Event.touchUpInside)
                let objSearchVideos = self.arrVideos[indexPath.row]
                
                //Duration conversion
                let duration = objSearchVideos.duration ?? "0"
                let doubleDuration = Double(duration) ?? 0.0
                cell.lblVideoDuration.text = self.timeFormatted(totalSeconds: Int(doubleDuration))
//                let duration = objSearchVideos.duration ?? "0"
//                cell.lblVideoDuration.text = self.timeFormatted(totalSeconds: Int(duration) ?? 0)
                
                loadImageWith(imgView: cell.imgVideo, url: objSearchVideos.thumbnail_480)
                cell.lblVideoTitle.text = objSearchVideos.title?.HSDecode
                cell.lblVideoAutherName.text = objSearchVideos.username?.HSDecode
                let totalInt = Int(objSearchVideos.view_count ?? "0") ?? 0
                let totalViews = self.suffixNumber(number:NSNumber.init(value: totalInt))
                cell.lblViewAndUploadTime.text = "\(totalViews) views | \(objSearchVideos.publish_date ?? "-")"
                //sweta changes
//                setDefaultPic(strImg: objSearchVideos.user_image ?? "", imgView: cell.imgVideoAuther, strImgName: PLACEHOLDER_IMAGENAME.small)

                
                
                cell.strSelectedVideoId = arrVideos[indexPath.row].uuid ?? ""
                cell.strAddToStashType = AddToStash_TYPE.Profile
                
//                let userID = objSearchVideos.user_uuid ?? ""
//                cell.strUserID = String(userID)
                
                
                if self.isForOwnProfile{
                    cell.isForOwnProfile = self.isForOwnProfile
                    cell.selectedVideo = objSearchVideos
                    //For Profile Image
                    let profileURL = self.dictProfileAbout.user_data?.profile_photo ?? ""
                    if verifyUrl(urlString: profileURL){
                        cell.imgVideoAuther.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
                        loadImageWith(imgView: cell.imgVideoAuther, url: profileURL)
                        cell.imgVideoAuther.contentMode = .scaleAspectFill
                    }else{
                        cell.imgVideoAuther.frame = CGRect(x: 7.0, y: 7.0, width: 21.0, height: 21.0)
                        cell.imgVideoAuther.image = UIImage(named: Cons_Profile_Image_Name)
                        cell.imgVideoAuther.contentMode = .scaleAspectFit
                    }
                    
                }else{
                    //For Profile Image
                    let profileURL = objSearchVideos.user_image ?? ""
                    if verifyUrl(urlString: profileURL){
                        cell.imgVideoAuther.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
                        loadImageWith(imgView: cell.imgVideoAuther, url: profileURL)
                        cell.imgVideoAuther.contentMode = .scaleAspectFill
                    }else{
                        cell.imgVideoAuther.frame = CGRect(x: 7.0, y: 7.0, width: 21.0, height: 21.0)
                        cell.imgVideoAuther.image = UIImage(named: Cons_Profile_Image_Name)
                        cell.imgVideoAuther.contentMode = .scaleAspectFit
                    }
                }
                
                //Callback
                cell.handler = indexHandlerBlock({(index) in
                    if index == 0{ //0 => Add To My Stash tap
                        //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                    }else if index == 1{ //1 => Add To Playlist tap
                        
                        if self.isForOwnProfile{
                            print("Call Delete API cell")
                            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Delete_Video_message, buttonsTitles: [Cons_No, Cons_Yes], showAsActionSheet: false, handler: { (index) in
                                switch(index){
                                case 1:
                                    print("Call Delete API")
                                    self.callDeleteVideoAPI(strVideoID: self.arrVideos[indexPath.row].uuid ?? "", isInMainThread: true) { (status, message) in
                                        if(status){
                                            self.alertOnTop(message: message, style: .success)
                                            self.arrVideos.remove(at: indexPath.row)
                                            self.tblvMain.reloadData()
                                        }else{
                                            self.alertOnTop(message: message, style: .danger)
                                        }
                                    }

                                default:
                                    print("Cancel tapped")
                                    //self.hidePopUp()
                                }
                            })
                        }
                        
                    }else{
                        //Share
                    }
                })
                
                return cell
                
            }
            else if self.currentPage == 1{ //Playlists
                
                let modelPlaylist = self.arrPlaylist[indexPath.row]
                var mediaCount = modelPlaylist.media_image?.count ?? 0
                mediaCount = mediaCount == 0 ? 1 : mediaCount > 3 ? 3 : mediaCount
                let cell = tblvMain.dequeueReusableCell(withIdentifier: "ID_CellPlaylist_\(mediaCount)", for: indexPath) as! CellPlaylist
                cell.objModelPlaylistNew = modelPlaylist
                return cell
            }
            else { //About
                
                if self.dictProfileAbout != nil{
                    let isBlock = self.dictProfileAbout.user_data?.is_block ?? ""
                    if isBlock.lowercased() == "yes"{
                        return UITableViewCell()
                    }
                    else{
                        if indexPath.row == 0{// About -> Status //sam
                            let cell = tblvMain.dequeueReusableCell(withIdentifier:"CellAboutStatus_ID") as! CellAboutStatus
                            cell.selectionStyle = .none
                            
                            let joinedDate = self.dictProfileAbout?.user_data?.joined_date ?? ""
                            cell.lblJoined.text = "Joined \(joinedDate)"
                            
                            //                    let views:NSNumber? = NSNumber(value: Float32(self.dictProfileAbout?.user_data?.total_profile_views ?? 0))
                            //                    let totalViews = self.suffixNumber(number:views!)
                            let totalViews = self.dictProfileAbout?.user_data?.total_profile_views ?? 0
                            cell.lblViews.text = String(totalViews)+" views"
                            
                            return cell
                        }
                        else if indexPath.row == 1{// About -> about text //sam
                            let cell = tblvMain.dequeueReusableCell(withIdentifier:"CellProfileAbout_ID") as! CellProfileAbout
                            cell.lblTitle.text = "About"
                            
                            let aboutText = self.dictProfileAbout?.user_data?.about_me ?? ""
                            if aboutText == ""{
                                cell.lblTitle.isHidden      = true
                                cell.lblAbout.isHidden      = true
                                cell.viewSeparator.isHidden = true
                            }
                            else{
                                cell.lblTitle.isHidden      = false
                                cell.lblAbout.isHidden      = false
                                cell.viewSeparator.isHidden = false
                                
                                cell.lblAbout.text = aboutText.stringByDecodingHTMLEntities
                                cell.lblAbout.textAlignment = .left
                            }
                            
                            return cell
                        }
                        else {// About -> Social links //sam
                            let cell = tblvMain.dequeueReusableCell(withIdentifier:"CellAboutLinks_ID") as! CellAboutLinks
                            cell.aryLinks = self.dictProfileAbout?.user_data?.social_accounts ?? [Social_accounts]()
                            
                            return cell
                        }
                    }
                }
            }
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }else {
            if self.currentPage == 0 {
                return UITableView.automaticDimension
            }
            else if self.currentPage == 1{ //Playlists
                return UITableView.automaticDimension
            }
            else { //About
                
                if self.dictProfileAbout != nil{
                    let isBlock = self.dictProfileAbout.user_data?.is_block ?? ""
                    if isBlock.lowercased() == "yes"{
                        return 0.0
                    }
                    else{
                        if indexPath.row == 0{// About -> Status //sam
                            return UITableView.automaticDimension
                        }
                        else if indexPath.row == 1{// About -> about text //sam
                            let aboutText = self.dictProfileAbout?.user_data?.about_me ?? ""
                            if aboutText == ""{
                                return 0.0
                            }
                            else{
                                return UITableView.automaticDimension
                            }
                        }
                        else {// About -> Social links //sam
                            return UITableView.automaticDimension
                        }
                    }
                }
            }
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if currentPage == 1{
//            let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
            let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VedioPlayListVC") as! VideoPlayListVC
            
            vcDetail.strSelectedVideoId = arrPlaylist[indexPath.row].first_video_details?.uuid ?? ""
            vcDetail.strPlaylistVideoId = arrPlaylist[indexPath.row].uuid ?? ""
            vcDetail.strSelectedVideoTitle = arrPlaylist[indexPath.row].name ??  ""
            vcDetail.isFromPlaylist = true
//            self.navigationController?.present(vcDetail, animated: true, completion: nil)
            self.navigationController?.pushViewController(vcDetail, animated: true)
        }
    }
    
    //MARK: - UIScrollViewDelegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        DispatchQueue.main.async {
            if scrollView.tag == 111{
                
                let alpha = scrollView.contentOffset.y / (headerHeight - 130.0)
                self.viewTop.backgroundColor = UIColor(red: 38.0/255.0, green:38.0/255.0, blue:38.0/255.0, alpha: alpha)
                
                if scrollView.contentOffset.y <= 0{
                    scrollView.contentOffset.y = 0
                }
            }
        }
    }
    
    //MARK: - Action Methods
    @IBAction func btnBackTap(_ sender: UIButton) {
        POP_VC()
    }
   
    @objc func actionBlock(sender: UIButton){
        
        DispatchQueue.main.async {
            //Callback
            self.handler = indexHandlerBlock({(index) in
                if index == 0{ //0 => Block
                    if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
                    }else{
                        self.actionBlockUnblockTap(sender)
                    }
                }
                else { //1 => Report
                    GLOBAL.sharedInstance.callReportcategorylistAPI(isInMainThread: true, completionBlock: { (status, message) in
                        
                        let viewReportVideoPopup = Bundle.loadView(fromNib: "ReportVideoPopup", withType: ReportVideoPopup.self)
                        viewReportVideoPopup.frame = UIScreen.main.bounds
                        viewReportVideoPopup.viewMain.backgroundColor = .clear
                        viewReportVideoPopup.strUserId = self.user_uuid
                        viewReportVideoPopup.isFromProfile = true
                        viewReportVideoPopup.addSubviewWithAnimationCenter(animation: {
                        }) {//Completion
                            
                            if(GLOBAL.sharedInstance.arrayReportCategoryData.count > 0){
                                let modelReportCategoryData = GLOBAL.sharedInstance.arrayReportCategoryData[0]
                                viewReportVideoPopup.txtCategory.txtField.text = modelReportCategoryData.title ?? ""
                                viewReportVideoPopup.strReportCategoryUUID = modelReportCategoryData.uuid ?? ""
                            }
                        }
                    })
                }
            })
            
            let is_block = self.dictProfileAbout?.user_data?.is_block ?? ""
            
            let viewAddStash = Bundle.loadView(fromNib: "ReportActionSheet", withType: ReportActionSheet.self)
            viewAddStash.frame = UIScreen.main.bounds
            viewAddStash.strPopUpTYPE = PopUpType.ReportActionSheet
            viewAddStash.isFromProfile = is_block
            viewAddStash.setupPopUpUI()
            if(self.handler != nil){
                viewAddStash.handler = self.handler
            }
            
            viewAddStash.addSubviewWithAnimationBottom(animation: {
            }, completion: {
            })
        }
    }
    
    @IBAction func btnEditProfileTap(_ sender: UIButton) {
        
        if isForOwnProfile{
            print("Edit Profile Tap")
            //self.PUSH_STORY_R1(Identifier: STORYBOARD_IDENTIFIER.EditProfileVC)
            let editProVC = self.MAKE_STORY_OBJ_R1(Identifier: STORYBOARD_IDENTIFIER.EditProfileVC) as! EditProfileVC
            editProVC.dictEditProfiile = self.dictProfileAbout
            self.PUSH_STORY_OBJ(obj: editProVC)
        }
    }
    
    @objc func btnTabChanged(_ sender: UIControl) {
        
        if currentPage == sender.tag - 2000{
            return
        }
        
        let lblOld = tabView.viewWithTag(1000+currentPage) as! UILabel
        lblOld.font = fontType.InterUI_Medium_13
        lblOld.textColor = UIColor.textColor_black_unselected
        
        currentPage = sender.tag - 2000
        
        self.currentPageOffset = 0
        self.totalRecords = 0
        
        if currentPage == 0{
            print("\n---------------Videos Tab-------------\n")
            
            self.tblvMain.bounces = true
            
            self.arrVideos = [videoListData]()
            self.callAPIs(inMainthread: true)
        }else if currentPage == 1{
            print("\n---------------Playlists Tab-------------\n")
            self.tblvMain.bounces = true
            
            self.arrPlaylist = [playlistDataAry]()
            self.callAPIs(inMainthread: true)
            
        }else if currentPage == 2{
            print("\n---------------About Tab-------------\n")
            self.tblvMain.bounces = false
            
            let isBlock = self.dictProfileAbout.user_data?.is_block ?? ""
            if isBlock.lowercased() == "yes"{
                self.lblNoData.isHidden = false
                self.lblNoData.text = "To view this user profile then please Unblock this user first."
            }else{
                self.lblNoData.isHidden = true
            }
        }
        
        self.tblvMain.reloadData()
        
        let lblNew = tabView.viewWithTag(1000+currentPage) as! UILabel
        lblNew.font = fontType.InterUI_Medium_13
        lblNew.textColor = UIColor.theme_green
        
        UIView.animate(withDuration: 0.25) {
            self.tabView.selectedTabView.frame = CGRect(x: sender.frame.minX, y: self.tabView.selectedTabView.frame.minY, width: sender.frame.width, height: self.tabView.selectedTabView.frame.height)
        }
    }

    @objc func actionDropDownTap(_ sender: UIControl) {
        print("actionDropDownTap")
    }
    
    @objc func actionSubsribeTap(_ sender: UIButton) {
        print("actionSubsribeTap")
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Subscribe_message, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.redirctToLoginScreen()
                default:
                    print("Cancel tapped")
                }
            })
        }else{
            let is_follow = self.dictProfileAbout?.user_data?.is_follow ?? ""
            if is_follow.lowercased() == "yes"{
                self.callFollowUnFollowAPI(inMainthread: true, strFollowingID: self.user_uuid, strFollowUnFollowStatus: "0", tag: sender.tag)
            }else{
                self.callFollowUnFollowAPI(inMainthread: true, strFollowingID: self.user_uuid, strFollowUnFollowStatus: "1", tag: sender.tag)
            }
        }
    }
    
    @objc func actionBlockUnblockTap(_ sender: UIButton) {
        print("actionBlockUnblockTap")
        let is_block = self.dictProfileAbout?.user_data?.is_block ?? ""
        if is_block.lowercased() == "yes"{
            Alert.shared.showAlertWithHandler(title: App_Name, message: msg_UnblockUser, buttonsTitles: [Cons_Cancel, str_AlertTextUnblock], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.callBlockUserAPI(blockStr: "No")
                default:
                    print("Cancel tapped")
                }
            })
        }
        else{
            Alert.shared.showAlertWithHandler(title: App_Name, message: msg_BlockUser, buttonsTitles: [Cons_Cancel, str_AlertTextBlock], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.callBlockUserAPI(blockStr: "Yes")
                default:
                    print("Cancel tapped")
                }
            })
        }
    }
    
}


extension ProfileMainVC{
    
    //MARK: - API Methods
    func callBlockUserAPI(blockStr:String){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.blocker_id : user_uuid,
                                          KEYS_API.block : blockStr]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: BlockUserModel.self,apiName:APIName.BlockUser, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                let isBlock = response.data?.is_block ?? ""
                if isBlock.lowercased() == "yes"{
                    self.topView.btnBlockUnblock.backgroundColor = UIColor.theme_green.withAlphaComponent(0.1)
                    self.topView.btnBlockUnblock.setTitleColor(UIColor.theme_green, for: .normal)
                    self.topView.btnBlockUnblock.setTitle("Unblock", for: .normal)
                }else{
                    self.topView.btnBlockUnblock.backgroundColor = UIColor.theme_green
                    self.topView.btnBlockUnblock.setTitleColor(UIColor.white, for: .normal)
                    self.topView.btnBlockUnblock.setTitle("Block", for: .normal)
                }
                
                self.callGetVisitorProfileAPIAfterBlockUser()
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
    func callGetVisitorProfileAPIAfterBlockUser(){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: String] = [KEYS_API.platform : APIConstant.platform,
                                             KEYS_API.version : KEYS_API.app_version,
                                             KEYS_API.uuid : self.user_uuid]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: ModelGetProfile.self,apiName:APIName.GetVisitorProfile, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                if response.data != nil{
                    self.dictProfileAbout = response.data
                    
                    let isBlock = self.dictProfileAbout.user_data?.is_block ?? ""
                    if self.currentPage == 0{
                        self.callVideoListAPIForVisitor(inMainthread: true)
//                        if isBlock.lowercased() == "yes"{
//                            self.lblNoData.text = "To view this user videos then please Unblock this user first."
//                        }
//                        else{
//                            self.lblNoData.text = "No Videos available"
//                        }
                    }
                    else if self.currentPage == 1{
                        self.callPlaylistAPIForVisitor(inMainthread: true)
//                        if isBlock.lowercased() == "yes"{
//                            self.lblNoData.text = "To view this user playlists then please Unblock this user first."
//                        }
//                        else{
//                            self.lblNoData.text = "No playlist available"
//                        }
                    }
                    else if self.currentPage == 2{
                        if isBlock.lowercased() == "yes"{
                            self.lblNoData.isHidden = false
                            self.lblNoData.text = "To view this user profile then please Unblock this user first."
                        }
                        else{
                            self.lblNoData.isHidden = true
                        }
                    }
                    
                    self.tblvMain.reloadData()
                    self.tblvMain.isHidden = false
                }
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
    
    func callGetProfileAPI(){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: String] = [KEYS_API.platform : APIConstant.platform,
                                             KEYS_API.version : KEYS_API.app_version,
                                             KEYS_API.uuid : self.user_uuid]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: ModelGetProfile.self,apiName:APIName.GetProfile, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                if response.data != nil{
                    self.dictProfileAbout = response.data
                    print("\n-------------------------Edit Profile :-----------------------\n",self.dictProfileAbout as Any)
                    
                    if self.isForOwnProfile{
                        let menuUserProfileImage = response.data?.user_data?.profile_photo
                        self.setUserDefault(menuUserProfileImage, KeyToSave: KEYS_USERDEFAULTS.USER_PHOTO)
                    }
                    
                    //self.populateVideosData()
                    self.callAPIs(inMainthread: true)
                    self.tblvMain.reloadData()
                    self.tblvMain.isHidden = false
                }
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
    
    func callGetVisitorProfileAPI(){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: String] = [KEYS_API.platform : APIConstant.platform,
                                             KEYS_API.version : KEYS_API.app_version,
                                             KEYS_API.uuid : self.user_uuid]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: ModelGetProfile.self,apiName:APIName.GetVisitorProfile, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            //self.hideLoader()
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                if response.data != nil{
                    self.dictProfileAbout = response.data
                    print("\n-------------------------Edit Profile :-----------------------\n",self.dictProfileAbout as Any)
                
                    //self.populateVideosData()
                    self.callAPIs(inMainthread: true)
                    self.tblvMain.reloadData()
                    self.tblvMain.isHidden = false
                }
            }
            
        }, FailureBlock: { (error) in
            //self.hideLoader()
        })
    }
    
    fileprivate func callAPIs(inMainthread: Bool){
        
        if currentPage == 0{
            if self.isForOwnProfile{
                self.callVideoListAPI(inMainthread: inMainthread)
            }else{
                self.callVideoListAPIForVisitor(inMainthread: inMainthread)
            }
        }else if currentPage == 1{            
            if self.isForOwnProfile{
                self.callPlaylistAPI(inMainthread: inMainthread)
            }else{
                self.callPlaylistAPIForVisitor(inMainthread: inMainthread)
            }
        }
        
    }
    
    func callVideoListAPI(inMainthread: Bool) {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.sort_param : "publish_date",
                                          KEYS_API.sort_type : "desc",
                                          KEYS_API.page_limit : PAGE_LIMIT,
                                          KEYS_API.page_offset : String(currentPageOffset),
                                          KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version
        ]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_CategoryVideoData.self,apiName:APIName.GetProfileVideolist, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblvMain.finishInfiniteScroll()
            
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                self.totalRecords = response.recordsTotal ?? 0
                
                if self.totalRecords > 0{
                    
                    if self.currentPageOffset == 0{
                        self.arrVideos = [videoListData]()
                    }
                    
                    self.arrVideos.append(contentsOf: (response.data)!)
                    
                    self.currentPageOffset = self.arrVideos.count
                    
                    if self.arrVideos.count > 0{
                        self.lblNoData.isHidden = false
                    }else{
                        self.lblNoData.isHidden = true
                    }
                    self.lblNoData.isHidden = true
                }
                else{
                    self.lblNoData.isHidden = false
                }
                
                self.lblNoData.text = "No videos available"
                self.tblvMain.reloadData()
            }
            
        }, FailureBlock: { (error) in
            self.tblvMain.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
        })
    }

    func callPlaylistAPI(inMainthread: Bool) {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.sort_param : "",
                                          KEYS_API.sort_type : "",
                                          KEYS_API.length : PAGE_LIMIT,
                                          KEYS_API.start : String(currentPageOffset),
                                          KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version
        ]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Playlist_Model.self,apiName:APIName.GetProfilePlaylist, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblvMain.finishInfiniteScroll()
            
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                self.totalRecords = response.data?.original?.recordsTotal ?? 0
                
                if self.totalRecords > 0{
                    
                    if self.currentPageOffset == 0{ // || self.is_searching
                        self.arrPlaylist = [playlistDataAry]()
                    }
                    
                    self.arrPlaylist.append(contentsOf: (response.data?.original?.data)!)
                    
                    self.currentPageOffset = self.arrPlaylist.count
                    
                    if self.arrPlaylist.count > 0{
                        self.lblNoData.isHidden = true
                    }else{
                        self.lblNoData.isHidden = false
                    }
                }
                else{
                    self.lblNoData.isHidden = false
                }
                self.lblNoData.text = "No playlist available"
                self.tblvMain.reloadData()
            }
            
        }, FailureBlock: { (error) in
            self.tblvMain.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
        })
    }
    
    func callVideoListAPIForVisitor(inMainthread: Bool) {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.sort_param : "publish_date",
                                          KEYS_API.sort_type : "desc",
                                          KEYS_API.user_id : user_uuid,
                                          KEYS_API.page_limit : PAGE_LIMIT,
                                          KEYS_API.page_offset : String(currentPageOffset),
                                          KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version
        ]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_CategoryVideoData.self,apiName:APIName.GetVisitorProfileVideolist, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblvMain.finishInfiniteScroll()
            
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                self.totalRecords = response.recordsTotal ?? 0
                
                if self.totalRecords > 0{
                    
                    if self.currentPageOffset == 0{
                        self.arrVideos = [videoListData]()
                    }
                    
                    self.arrVideos.append(contentsOf: (response.data)!)
                    
                    self.currentPageOffset = self.arrVideos.count
                    
                    if self.arrVideos.count > 0{
                        self.lblNoData.isHidden = true
                    }else{
                        self.lblNoData.isHidden = false
                    }
                }
                else{
                    self.lblNoData.isHidden = false
                }
                
                let isBlock = self.dictProfileAbout.user_data?.is_block ?? ""
                if isBlock.lowercased() == "yes"{
                    self.lblNoData.text = "To view this user videos then please Unblock this user first."
                }
                else{
                    self.lblNoData.text = "No Videos available"
                }
                
                
                self.tblvMain.reloadData()
            }
            
        }, FailureBlock: { (error) in
            self.tblvMain.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
        })
    }
    
    func callPlaylistAPIForVisitor(inMainthread: Bool) {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.sort_param : "",
                                          KEYS_API.sort_type : "",
                                          KEYS_API.user_id : user_uuid,
                                          KEYS_API.length : PAGE_LIMIT,
                                          KEYS_API.start : String(currentPageOffset),
                                          KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version
        ]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Playlist_Model.self,apiName:APIName.GetVisitorProfilePlaylist, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblvMain.finishInfiniteScroll()
            
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                self.totalRecords = response.data?.original?.recordsTotal ?? 0
                
                if self.totalRecords > 0{
                    
                    if self.currentPageOffset == 0{ // || self.is_searching
                        self.arrPlaylist = [playlistDataAry]()
                    }
                    
                    self.arrPlaylist.append(contentsOf: (response.data?.original?.data)!)
                    
                    self.currentPageOffset = self.arrPlaylist.count
                    
                    if self.arrPlaylist.count > 0{
                        self.lblNoData.isHidden = true
                    }else{
                        self.lblNoData.isHidden = false
                    }
                }
                else{
                    self.lblNoData.isHidden = false
                }
                
                let isBlock = self.dictProfileAbout.user_data?.is_block ?? ""
                if isBlock.lowercased() == "yes"{
                    self.lblNoData.text = "To view this user playlists then please Unblock this user first."
                }
                else{
                    self.lblNoData.text = "No playlist available"
                }
                
                self.tblvMain.reloadData()
            }
            
        }, FailureBlock: { (error) in
            self.tblvMain.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
        })
    }
    
    
    private func callFollowUnFollowAPI(inMainthread: Bool,strFollowingID:String,strFollowUnFollowStatus:String,tag:Int)  {
        
        GLOBAL.sharedInstance.callFollowUpfollowAPI(strFollowingID: strFollowingID, strIsFollowUnFollow: strFollowUnFollowStatus, isInMainThread: inMainthread,completionBlock: { (status, message) in
            
            if(status){
                self.alertOnTop(message: message, style: .success)
                
                if strFollowUnFollowStatus == "1"{
                    self.topView.btnSubscribe.backgroundColor = UIColor.theme_green.withAlphaComponent(0.1)
                    self.topView.btnSubscribe.setTitleColor(UIColor.theme_green, for: .normal)
                    self.topView.btnSubscribe.setTitle("Unsubscribe", for: .normal)
                }else{
                    self.topView.btnSubscribe.backgroundColor = UIColor.theme_green
                    self.topView.btnSubscribe.setTitleColor(UIColor.white, for: .normal)
                    self.topView.btnSubscribe.setTitle("Subscribe", for: .normal)
                }
                
                self.callGetVisitorProfileAPI()
            }
        })
    }
    
    func callDeleteVideoAPI(strVideoID : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version]
        if isInMainThread{
            self.showLoader()
        }
        
        let strApiName = APIName.VideoDelete + strVideoID
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: DeleteVideoModel.self,apiName:strApiName, requestType: .delete, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if isInMainThread{
                self.hideLoader()
            }
            
            let statusCode = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                completionBlock(true,response.meta?.message ?? "success")
            }
            else{
                completionBlock(false,response.meta?.message ?? "fail")
            }
            
        }, FailureBlock: { (error) in
            if isInMainThread{
                self.hideLoader()
            }
            completionBlock(false,error.localizedDescription)
        })
    }
}

