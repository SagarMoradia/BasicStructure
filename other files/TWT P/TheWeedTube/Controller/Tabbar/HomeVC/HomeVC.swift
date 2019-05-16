//
//  HomeVC.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 14/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit
import SideMenu

let V_TYPE_FEATURED = "Featured"
let V_TYPE_RECENT   = "Recently Uploaded"
let V_TYPE_DYNAMIC_CONTENT   = "Dynamic Content"

class HomeVC: ParentVC {
    
    //MARK: - Outlets
    @IBOutlet weak var tblAllVideos: UITableView!
    @IBOutlet weak var imgTopHeaderAdsURL: UIImageView!
    @IBOutlet weak var cntrlTop: UIControl!
    @IBOutlet weak var viewBadge: UIView!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var imgvProfile: UIImageView!
    @IBOutlet weak var lblNotificationCount: BadgeSwift!
    @IBOutlet weak var lblNoData: darkGreyLabelCtrlModel!
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var viewAd: UIView!
    
    //MARK: - Properties
    var viewAddStash:AddToStashActionSheet?
    var aryAllVideos = [ModelHomeParent]()
    var arrAllVideos = [Any]()
    //let currentPageOffset = "0"
    var currentPageLimit = "6"
    var dictProfileAbout : ProfileData!
    //MARK: - Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
        populateHomeScreenData()
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tblAllVideos.refreshControl = refreshControl
        } else {
            tblAllVideos.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.theme_green
    }
    
    //MARK: - Refresh Api methods
    @objc private func refresh(sender:UIRefreshControl) {
//        aryAllVideos = [ModelHomeParent]()
        arrAllVideos = [Any]()
        currentPageLimit = "6"
        self.tblAllVideos.isUserInteractionEnabled = false
        self.callGetFeaturedVideoAPI(inMainThread: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    //    populateHomeScreenData()
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) != nil{

            if GLOBAL.sharedInstance.isFromNotification{
                self.notificationRedirection()
            }
            
            self.callGetProfileAPI()
        }
        
        checkProfilePic()
    }
    
    //MARK: - Intial Methods
    func setNotificationCountOnActiveState(count:String){
        let globalCount = GLOBAL.sharedInstance.Notification_count
        //self.lblNotificationCount.text = globalCount
        let countInt = Int(globalCount) ?? 0
        if count != ""{
            self.lblNotificationCount.text = String(countInt+1)
        }
    }
    
    fileprivate func notificationRedirection(){
        var notificationType = GLOBAL.sharedInstance.Notification_type 
        if notificationType != ""{
            notificationType = notificationType.lowercased()
            if GLOBAL.sharedInstance.Notification_type == n_type_profile || GLOBAL.sharedInstance.Notification_type == n_type_user{
                self.notificationRedirectToProfile()
//                let profileVC = self.MAKE_STORY_OBJ_MAIN(Identifier: "ProfileMainVC") as! ProfileMainVC
//                profileVC.isForOwnProfile = false
//                let topNavigationVC = UIApplication.topViewController()
//
//                if (topNavigationVC?.isKind(of: ProfileMainVC.self))! {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_NAME.ProfileNotification), object: nil, userInfo: nil)
//                }else{
//                    topNavigationVC?.navigationController?.pushViewController(profileVC, animated: true)
//                }
            }
            else if GLOBAL.sharedInstance.Notification_type == n_type_video || GLOBAL.sharedInstance.Notification_type == n_type_comment{
                self.notificationRedirectToVideoDetail()
//                let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
//                vcDetail.isFromPlaylist = false
//
//                let topNavigationVC = UIApplication.topViewController()
//                if (topNavigationVC?.isKind(of: VideoDetailVC.self))! {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_NAME.VideoNotification), object: nil, userInfo: nil)
//                }else{
//                    self.pushVCWithPresentAnimation(controller: vcDetail)
//                }
            }
            else if GLOBAL.sharedInstance.Notification_type == n_type_general{
                print("Redirect to Notification Listing Screen")
                let objMore = self.MAKE_STORY_OBJ_TABBAR(Identifier: STORYBOARD_IDENTIFIER.NotificationVC)
                objMore.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(objMore, animated: true)
            }
        }
    }
    
    fileprivate func checkProfilePic() {
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            
        }else{
            imgvProfile.image = UIImage(named: "notification_icon")
//            let profileURL = self.getUserDefault(KEYS_USERDEFAULTS.USER_PHOTO) as? String
//            if verifyUrl(urlString: profileURL){
//                imgvProfile.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
//                loadImageWith(imgView: imgvProfile, url: profileURL)
//                imgvProfile.contentMode = .scaleAspectFill
//            }else{
//                imgvProfile.frame = CGRect(x: 7.0, y: 7.0, width: 16.0, height: 16.0)
//                imgvProfile.image = UIImage(named: Cons_Profile_Image_Name)
//                imgvProfile.contentMode = .scaleAspectFit
//            }
        }
    }
    
    func prepareViews() {
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            self.removeRightBarItemWithTag(tag: 11)
        }
        
//        cntrlTop.layer.cornerRadius = cntrlTop.frame.height/2
//        cntrlTop.layer.masksToBounds = true
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tblAllVideos.tableHeaderView = UIView(frame: frame)
        self.tblAllVideos.contentInset = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 0.0, right: 0.0)
//        loadImageWith(imgView: imgTopHeaderAdsURL, url:"https://amazingslider.com/wp-content/uploads/amazingslider/3/images/big_buck_bunny_960_300.jpg")
        //populateHomeScreenData()
    }
    
    fileprivate func populateHomeScreenData() {
        
        tblAllVideos.delegate = self
        tblAllVideos.dataSource = self

        tblAllVideos.estimatedRowHeight = UITableView.automaticDimension
        
        let nibProfileName = UINib(nibName: "CellHome", bundle: nil)
        tblAllVideos.register(nibProfileName, forCellReuseIdentifier: "ID_CellHome")
        
        //aryAllVideos = [ModelHomeParent]()
        arrAllVideos = [Any]()
        self.callGetFeaturedVideoAPI(inMainThread: true)
    }
    //MARK: - Action Methods
    @IBAction func btnNotificationTap(_ sender: UIControl) {
        let objMore = self.MAKE_STORY_OBJ_TABBAR(Identifier: STORYBOARD_IDENTIFIER.NotificationVC)
        objMore.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(objMore, animated: true)
    }
    
    @IBAction func btnSearchTap(_ sender: UIButton) {
        //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
        let objSearch = self.MAKE_STORY_OBJ_TABBAR(Identifier: STORYBOARD_IDENTIFIER.SearchVC) as! SearchVC
        self.navigationController?.pushViewController(objSearch, animated: false)
        
//        let objSearchResult = self.MAKE_STORY_OBJ_TABBAR(Identifier: STORYBOARD_IDENTIFIER.SearchResultVC) as! SearchResultVC
//        objSearchResult.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(objSearchResult, animated: false)

    }
    
    @objc func btnViewAllTap(_ sender:UIButton){
        print("btnViewAllTap \(sender.tag)")
        
        let catInfo = arrAllVideos[sender.tag] as! NSDictionary
        let catTag = catInfo.value(forKey:API_RES.cat_tag) as! String
        let catName = catInfo.value(forKey:API_RES.cat_name) as! String
        let catUuid = catInfo.value(forKey:API_RES.cat_uuid) as! String
        
        var videoType = String()
        var catType = String()
        if catTag == V_TYPE_FEATURED{
            videoType = v_type_featured
            catType = ""
        }
        else if catTag == V_TYPE_RECENT{
            videoType = v_type_recently_uploaded
            catType = ""
        }
        else if catTag == V_TYPE_DYNAMIC_CONTENT{
            videoType = catName
            catType = V_TYPE_DYNAMIC_CONTENT
        }
        else{
            videoType = catName
            catType = ""
        }
        
        let objVideoCategoryListVC = MAKE_STORY_OBJ_R2(Identifier: "VideoCategoryListVC") as! VideoCategoryListVC
        objVideoCategoryListVC.hidesBottomBarWhenPushed = true
        objVideoCategoryListVC.lblNavigationTitle?.text = videoType
        objVideoCategoryListVC.categoryID = catUuid
        objVideoCategoryListVC.categoryType = catType
        objVideoCategoryListVC.isFromCategory = false
        PUSH_STORY_OBJ(obj: objVideoCategoryListVC)
    }
    
    //MARK:- Notification Redirection Methods
    fileprivate func notificationRedirectToVideoDetail(){
        
        self.showLoader()
        
        let strNotificationUDID = GLOBAL.sharedInstance.N_ID
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams = [KEYS_API.uuid : strNotificationUDID]
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: DeleteVideoModel.self,apiName:APIName.NotificationRead, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
            vcDetail.isFromPlaylist = false
            
            let topNavigationVC = UIApplication.topViewController()
            if (topNavigationVC?.isKind(of: VideoDetailVC.self))! {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_NAME.VideoNotification), object: nil, userInfo: nil)
            }else{
                self.pushVCWithPresentAnimation(controller: vcDetail)
            }
            
            
//            let statusCode  = response.meta?.status_code ?? 0
//
//            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
//
//                var nType = GLOBAL.sharedInstance.Notification_type
//                if nType != ""{
//                    nType = nType.lowercased()
//                    if nType == n_type_video || nType == n_type_comment{
//
//                        let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
//                        vcDetail.isFromPlaylist = false
//
//                        let topNavigationVC = UIApplication.topViewController()
//                        if (topNavigationVC?.isKind(of: VideoDetailVC.self))! {
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_NAME.VideoNotification), object: nil, userInfo: nil)
//                        }else{
//                            self.pushVCWithPresentAnimation(controller: vcDetail)
//                        }
//
//                    }
//                }
//            }

            
        }, FailureBlock: { (error) in
            self.hideLoader()
            
            let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
            vcDetail.isFromPlaylist = false
            
            let topNavigationVC = UIApplication.topViewController()
            if (topNavigationVC?.isKind(of: VideoDetailVC.self))! {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_NAME.VideoNotification), object: nil, userInfo: nil)
            }else{
                self.pushVCWithPresentAnimation(controller: vcDetail)
            }
            
        })
    }
    
    fileprivate func notificationRedirectToProfile(){
        
        self.showLoader()
        
        let strNotificationUDID = GLOBAL.sharedInstance.N_ID
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams = [KEYS_API.uuid : strNotificationUDID]
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: DeleteVideoModel.self,apiName:APIName.NotificationRead, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let profileVC = self.MAKE_STORY_OBJ_MAIN(Identifier: "ProfileMainVC") as! ProfileMainVC
            profileVC.isForOwnProfile = false
            let topNavigationVC = UIApplication.topViewController()
            
            if (topNavigationVC?.isKind(of: ProfileMainVC.self))! {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_NAME.ProfileNotification), object: nil, userInfo: nil)
            }else{
                topNavigationVC?.navigationController?.pushViewController(profileVC, animated: true)
            }
            
            
//            let statusCode  = response.meta?.status_code ?? 0
//
//            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
//
//                var nType = GLOBAL.sharedInstance.Notification_type
//                if nType != ""{
//                    nType = nType.lowercased()
//                    if nType == n_type_profile || nType == n_type_user{
//
//                        let profileVC = self.MAKE_STORY_OBJ_MAIN(Identifier: "ProfileMainVC") as! ProfileMainVC
//                        profileVC.isForOwnProfile = false
//                        let topNavigationVC = UIApplication.topViewController()
//
//                        if (topNavigationVC?.isKind(of: ProfileMainVC.self))! {
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_NAME.ProfileNotification), object: nil, userInfo: nil)
//                        }else{
//                            topNavigationVC?.navigationController?.pushViewController(profileVC, animated: true)
//                        }
//
//                    }
//                }
//            }
            
            
        }, FailureBlock: { (error) in
            self.hideLoader()
            
            let profileVC = self.MAKE_STORY_OBJ_MAIN(Identifier: "ProfileMainVC") as! ProfileMainVC
            profileVC.isForOwnProfile = false
            let topNavigationVC = UIApplication.topViewController()
            
            if (topNavigationVC?.isKind(of: ProfileMainVC.self))! {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_NAME.ProfileNotification), object: nil, userInfo: nil)
            }else{
                topNavigationVC?.navigationController?.pushViewController(profileVC, animated: true)
            }
            
        })
    }
    
}

//MARK:- Custom Methods
extension HomeVC{
    
    func setNoDataFound() {
        if self.arrAllVideos.count > 0{ //aryAllVideos
            self.tblAllVideos.isHidden = false
            self.lblNoData.isHidden = true
        }else{
            self.tblAllVideos.isHidden = true
            self.lblNoData.isHidden = false
        }
    }
}

//MARK: - Button Event Methods
extension HomeVC{
    @objc func actionVideoDetail(sender: UIButton){
        
        let tappedButtonIndex = self.indexPathForControl(sender, tableView: self.tblAllVideos)
        print("\(tappedButtonIndex.row)" + " " + "\(tappedButtonIndex.section)")
        
        let catInfo = arrAllVideos[tappedButtonIndex.section] as! NSDictionary
        let catTag = catInfo.value(forKey:API_RES.cat_tag) as! String
        
        if catTag == V_TYPE_RECENT || catTag == V_TYPE_FEATURED{
            
            let vidList = catInfo.value(forKey:API_RES.cat_videos) as! [Model_VideoData]
            let video = vidList[tappedButtonIndex.row]
            let catName = catInfo.value(forKey: API_RES.cat_name) as! String
            
            let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
            
            if catName == v_type_featured{
                vcDetail.strSelectedVideoId = video.uuid ?? ""
            }else{
                vcDetail.strSelectedVideoId = video.video_uuid ?? ""
            }
            
            vcDetail.isFromPlaylist = false
            vcDetail.hidesBottomBarWhenPushed = true
            self.pushVCWithPresentAnimation(controller: vcDetail)
        }
        else{
            let vidList = catInfo.value(forKey:API_RES.cat_videos) as! [VideoData_Info]
            let video = vidList[tappedButtonIndex.row]
            let catName = catInfo.value(forKey: API_RES.cat_name) as! String
            
            let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
            
            if catName == v_type_featured{
                vcDetail.strSelectedVideoId = video.uuid ?? ""
            }else{
                vcDetail.strSelectedVideoId = video.video_uuid ?? ""
            }
            
            vcDetail.isFromPlaylist = false
            vcDetail.hidesBottomBarWhenPushed = true
            self.pushVCWithPresentAnimation(controller: vcDetail)
        }
    }
}

//MARK:- UITableViewDataSource and UITableViewDelegate Methods
extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if arrAllVideos.count > 0 //aryAllVideos
        {
            return arrAllVideos.count //aryAllVideos
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let catInfo = arrAllVideos[section] as! NSDictionary
        let catTag = catInfo.value(forKey:API_RES.cat_tag) as! String
        
        if catTag == V_TYPE_RECENT || catTag == V_TYPE_FEATURED{
            let vidList = catInfo.value(forKey:API_RES.cat_videos) as! [Model_VideoData]
            if vidList.count > 0 {
                return vidList.count
            }
        }
        else{
            let vidList = catInfo.value(forKey:API_RES.cat_videos) as! [VideoData_Info]
            if vidList.count > 0 {
                return vidList.count
            }
        }
        
//        if (aryAllVideos[section].videoList?.count)! > 0
//        {
//            return aryAllVideos[section].videoList?.count ?? 0
//        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID_CellHome", for: indexPath) as! CellHome
        
        cell.btnVideoDetail.tag = indexPath.row
        cell.btnVideoDetail.addTarget(self, action: #selector(actionVideoDetail(sender:)), for: UIControl.Event.touchUpInside)
        cell.btnVideoName.tag = indexPath.row
        cell.btnVideoName.addTarget(self, action: #selector(actionVideoDetail(sender:)), for: UIControl.Event.touchUpInside)
        
        if arrAllVideos.count > indexPath.section { //aryAllVideos
            
            let catInfo = arrAllVideos[indexPath.section] as! NSDictionary
            let catTag = catInfo.value(forKey:API_RES.cat_tag) as! String
            
            if catTag == V_TYPE_RECENT || catTag == V_TYPE_FEATURED{
                let vidList = catInfo.value(forKey:API_RES.cat_videos) as! [Model_VideoData]
                
                if indexPath.section == 0 { //indexPath.section == 0
                    cell.isFeaturedVideo = true
                    cell.strSelectedVideoId = vidList[indexPath.row].uuid ?? ""//aryAllVideos[indexPath.section].videoList![indexPath.row].uuid ?? ""
                    cell.strUserID = vidList[indexPath.row].user_uuid ?? ""//aryAllVideos[indexPath.section].videoList![indexPath.row].user_uuid ?? ""
                }else{
                    cell.isFeaturedVideo = false
                    cell.strSelectedVideoId = vidList[indexPath.row].video_uuid ?? "" //aryAllVideos[indexPath.section].videoList![indexPath.row].video_uuid ?? ""
                    cell.strUserID = vidList[indexPath.row].visitors_uuid ?? "" //aryAllVideos[indexPath.section].videoList![indexPath.row].visitors_uuid ?? ""
                }
                
                cell.objModelHomeParent = vidList[indexPath.row]
            }
            else{
                let vidList = catInfo.value(forKey:API_RES.cat_videos) as! [VideoData_Info]
                
                if indexPath.section == 0 { //indexPath.section == 0
                    cell.isFeaturedVideo = true
                    cell.strSelectedVideoId = vidList[indexPath.row].uuid ?? ""//aryAllVideos[indexPath.section].videoList![indexPath.row].uuid ?? ""
                    cell.strUserID = vidList[indexPath.row].user_uuid ?? ""//aryAllVideos[indexPath.section].videoList![indexPath.row].user_uuid ?? ""
                }else{
                    cell.isFeaturedVideo = false
                    cell.strSelectedVideoId = vidList[indexPath.row].video_uuid ?? "" //aryAllVideos[indexPath.section].videoList![indexPath.row].video_uuid ?? ""
                    cell.strUserID = vidList[indexPath.row].visitors_uuid ?? "" //aryAllVideos[indexPath.section].videoList![indexPath.row].visitors_uuid ?? ""
                }
                
                cell.objModelHomeParentNew = vidList[indexPath.row]
            }
            
            //cell.objModelHomeParent = aryAllVideos[indexPath.section].videoList![indexPath.row]
            
            cell.strAddToStashType = AddToStash_TYPE.Home
            
            //Callback
            cell.handler = indexHandlerBlock({(index) in
                if index == 0{ //0 => Add To My Stash tap
                }else if index == 1 { //1 => Add To Playlist tap
                }else{//Share
                }
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.loadView(fromNib: "HeaderHome", withType: HeaderHome.self)
        
        
        let catInfo = arrAllVideos[section] as! NSDictionary
        if arrAllVideos.count > 0{ //aryAllVideos
            let catName = catInfo.value(forKey: API_RES.cat_name) as! String
            headerView.lblHeaderTitle.text = catName
            //headerView.lblHeaderTitle.text = aryAllVideos[section].type
        }
        
        if arrAllVideos.count > section ,let footerUrl = catInfo.value(forKey: API_RES.cat_Ad_Url) as? String, footerUrl.count > 0{
            
            headerView.viewAd.isHidden = false
            headerView.adViewHeight.constant = 50.0
            headerView.topTitleConst.constant = 8.0
            
            self.loadMopubAdForHomeTop(inView: headerView.viewAd)
            
        }else{
            headerView.viewAd.isHidden = true
            headerView.adViewHeight.constant = 0.0
            headerView.topTitleConst.constant = 0.0
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let catInfo = arrAllVideos[section] as! NSDictionary
        let footerUrl = catInfo.value(forKey:API_RES.cat_Ad_Url) as! String
        return footerUrl.count > 0 ? 100.0 : 40.0
        
        //        return aryAllVideos[section].footerAdsUrl?.count ?? -1 > 0 ? 100.0 : 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = Bundle.loadView(fromNib: "FooterHome", withType: FooterHome.self)
        footerView.btnViewAll.tag = section
        footerView.btnViewAll.addTarget(self, action: #selector(btnViewAllTap(_:)), for: .touchUpInside)
        
        let count = self.arrAllVideos.count
        if count-1 == section{
            footerView.viewAd.isHidden = false
            footerView.ContrainAdsHeight.constant = 50.0
            
            self.loadMopubAdForHomeBottom(inView: footerView.viewAd)
        }
        else{
            footerView.viewAd.isHidden = true
            footerView.ContrainAdsHeight.constant = 0.0
        }
        
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let count = self.arrAllVideos.count
        if count-1 == section{
            return 130.0
        }
        else{
            return 64.0
        }
    }
}

//MARK: - API
extension HomeVC{

    //MARK:-
    //MARK: - Featuered -> 1
    func callGetFeaturedVideoAPI(inMainThread:Bool){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.page_offset : "1",
                                          KEYS_API.page_limit : currentPageLimit]
        
        if inMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:APIName.GetFeaturedVideo, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if inMainThread{
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                self.arrAllVideos = [Any]()
                
                let videos = response.data ?? [Model_VideoData]()
                
                let res_dict: [String: Any] = [API_RES.cat_name : response.title ?? "",//v_type_featured,
                                               API_RES.cat_videos : videos,
                                               API_RES.cat_tag : V_TYPE_FEATURED,
                                               API_RES.cat_uuid : "",
                                               API_RES.cat_Ad_Url : "AdURL"]
                
                if videos.count > 0{
                    self.arrAllVideos.append(res_dict as Any)
                }
            }
            
            self.callGetCategoryBasedVideosAPI(inMainThread: inMainThread)
            
        }, FailureBlock: { (error) in
            if inMainThread{
                self.hideLoader()
            }
//            self.aryAllVideos = [ModelHomeParent]()
            self.arrAllVideos = [Any]()
            self.callGetCategoryBasedVideosAPI(inMainThread: inMainThread)
        })
    }
    
    //MARK: - Category Based -> 2
    func callGetCategoryBasedVideosAPI(inMainThread:Bool){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.page_offset : "1",
                                          KEYS_API.page_limit : currentPageLimit]
        
        if inMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: HomeCategoryDataModel.self,apiName:APIName.GetHomeCategoryVideos, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if inMainThread{
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {

                if self.arrAllVideos.count == 0{
                    self.arrAllVideos = [Any]()
                }
                
                let catInfo = response.data ?? [Cat_Info]()
                
                if catInfo.count > 0 {
                    for categoryInfo in catInfo{
                        let catName = categoryInfo.home_content_info?.name ?? ""
                        let catUuid = categoryInfo.home_content_info?.uuid ?? ""
                        let videos = categoryInfo.videos_info ?? [VideoData_Info]()
                        
                        let res_dict: [String: Any] = [API_RES.cat_name : catName,
                                                       API_RES.cat_videos : videos,
                                                       API_RES.cat_tag : "",
                                                       API_RES.cat_uuid : catUuid,
                                                       API_RES.cat_Ad_Url : ""]
                        if videos.count > 0{
                            self.arrAllVideos.append(res_dict as Any)
                        }
                    }
                }
            }
            
            self.callGetDynamicContentVideosAPI(inMainThread: inMainThread)
            
        }, FailureBlock: { (error) in
            if inMainThread{
                self.hideLoader()
            }
            
//            if self.aryAllVideos.count == 0{
//                self.aryAllVideos = [ModelHomeParent]()
//            }
            
            if self.arrAllVideos.count == 0{
                self.arrAllVideos = [Any]()
            }
            self.callGetDynamicContentVideosAPI(inMainThread: inMainThread)
        })
    }
    
    //MARK: - Content Based Dynamic -> 3
    func callGetDynamicContentVideosAPI(inMainThread:Bool){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.sort_param : "like_count",
                                          KEYS_API.sort_type : "ASC",
                                          KEYS_API.page_offset : "1",
                                          KEYS_API.page_limit : currentPageLimit]
        
        if inMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: HomeCategoryDataModel.self,apiName:APIName.GetHomeDynamicContent, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if inMainThread{
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                if self.arrAllVideos.count == 0{
                    self.arrAllVideos = [Any]()
                }
                
                let catInfo = response.data ?? [Cat_Info]()
                
                if catInfo.count > 0 {
                    for categoryInfo in catInfo{
                        let catName = categoryInfo.home_content_info?.name ?? ""
                        let catUuid = categoryInfo.home_content_info?.uuid ?? ""
                        let videos = categoryInfo.videos_info ?? [VideoData_Info]()
                        
                        let res_dict: [String: Any] = [API_RES.cat_name : catName,
                                                       API_RES.cat_videos : videos,
                                                       API_RES.cat_tag : V_TYPE_DYNAMIC_CONTENT,
                                                       API_RES.cat_uuid : catUuid,
                                                       API_RES.cat_Ad_Url : ""]
                        if videos.count > 0{
                            self.arrAllVideos.append(res_dict as Any)
                        }
                    }
                }
            }
            
            self.callGetRecentlyUploadedVideoAPI(inMainThread: inMainThread)
            
        }, FailureBlock: { (error) in
            if inMainThread{
                self.hideLoader()
            }
            
            //            if self.aryAllVideos.count == 0{
            //                self.aryAllVideos = [ModelHomeParent]()
            //            }
            
            if self.arrAllVideos.count == 0{
                self.arrAllVideos = [Any]()
            }
            self.callGetRecentlyUploadedVideoAPI(inMainThread: inMainThread)
        })
    }
    
    //MARK: - Recently Uploaded -> 4
    func callGetRecentlyUploadedVideoAPI(inMainThread:Bool){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.page_offset : "1",
                                          KEYS_API.page_limit : currentPageLimit,]
        
        if inMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:APIName.GetRecentlyUploadedVideo, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if inMainThread{
                self.hideLoader()
            }
            self.refreshControl.endRefreshing()
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {

                if self.arrAllVideos.count == 0{
                    self.arrAllVideos = [Any]()
                }

                let videos = response.data ?? [Model_VideoData]()
                
                let res_dict: [String: Any] = [API_RES.cat_name : response.title ?? "",//v_type_recently_uploaded,
                                               API_RES.cat_videos : videos,
                                               API_RES.cat_tag : V_TYPE_RECENT,
                                               API_RES.cat_uuid : "",
                                               API_RES.cat_Ad_Url : self.arrAllVideos.count>0 ? "" : "AdURL"]
                
                if videos.count > 0{
                    self.arrAllVideos.append(res_dict as Any)
                }
            }
            
            self.setNoDataFound()
            
            self.tblAllVideos.isUserInteractionEnabled = true
            self.tblAllVideos.reloadData()
            
        }, FailureBlock: { (error) in
            if inMainThread{
                self.hideLoader()
            }
            self.refreshControl.endRefreshing()
            self.tblAllVideos.isUserInteractionEnabled = true
            self.tblAllVideos.reloadData()
        })
    }
    
    //MARK: - Get Profile for Notification Count Updates
    func callGetProfileAPI(){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let strUserUUID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID) as! String
        
        if strUserUUID != ""{
            
            let queryParams: [String: String] = [KEYS_API.platform : APIConstant.platform,
                                                 KEYS_API.version : KEYS_API.app_version,
                                                 KEYS_API.uuid : strUserUUID]
            
            self.showLoader()
            
            API.sharedInstance.apiRequestWithModalClass(modelClass: ModelGetProfile.self,apiName:APIName.GetProfile, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
                
                self.hideLoader()
                
                print("\n-------------------------API Response :-----------------------\n",response)
                
                let statusCode  = response.meta?.status_code ?? 0
                
                if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                    
                    if response.data != nil{
                        self.dictProfileAbout = response.data
                        print("\n-------------------------Edit Profile :-----------------------\n",self.dictProfileAbout as Any)
                        
                        let count = self.dictProfileAbout.user_data?.notification_unread_count ?? 0
                        if count == 0{
                            self.lblNotificationCount.text = ""
                            self.lblNotificationCount.isHidden = true
                        }
                        else{
                            self.lblNotificationCount.text = String(count)
                            self.lblNotificationCount.isHidden = false
                        }
                    }
                }
                
            }, FailureBlock: { (error) in
                self.hideLoader()
                self.lblNotificationCount.text = ""
                self.lblNotificationCount.isHidden = true
            })
            
        }
        else{
            self.lblNotificationCount.text = ""
            self.lblNotificationCount.isHidden = true
        }
    }
}
