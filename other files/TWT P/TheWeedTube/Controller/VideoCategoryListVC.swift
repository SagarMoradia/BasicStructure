//
//  MyStashVC.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 14/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class VideoCategoryListVC: ParentVC {

    var aryAllVideos = [videoListData]()
    var aryTrendingVideos = [Model_VideoData]()
    var aryDynamicContentVideos = [Any]()
    var arrVids = [VideoData_Info]()
    var aryRecentVideos = [recentlyUploadedVideoDataAry]()
    var aryFeaturedVideos = [Model_VideoData]()
    @IBOutlet weak var tblVideolist: UITableView!
    @IBOutlet weak var lblNoData: darkGreyLabelCtrlModel!
    @IBOutlet weak var topImgWidthConstant: NSLayoutConstraint!
    
    var categoryID = String()
    var categoryType = String()
    var totalRecords: Int = 0
    var currentPageOffset: Int = 0
    var isFromCategory = Bool()
    var isAllTrendingLoaded = Bool()
  
    //MARK:- UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
        self.setupPagination()
    }
    
    //MARK:- Helper Methods
    fileprivate func prepareViews() {
        
        tblVideolist.register(UINib.init(nibName: "CellHome", bundle: nil), forCellReuseIdentifier: "ID_CellHome")
        tblVideolist.register(UINib.init(nibName: "AdvertiesCell", bundle: nil), forCellReuseIdentifier: "AdvertiesCell")
        
        imgNavigationLeft.layer.cornerRadius = imgNavigationLeft.frame.size.height/2
        imgNavigationLeft.layer.masksToBounds = true
        
        if self.isFromCategory{
            self.imgNavigationLeft.isHidden = false
            self.topImgWidthConstant.constant = 35.0
            self.callGetCategoryVideoAPI(inMainthread: true)
        }else{
            self.imgNavigationLeft.isHidden = true
            self.topImgWidthConstant.constant = 0.0
            
//            if self.lblNavigationTitle.text == v_type_trending{
//                self.callGetTrendingVideoAPI(inMainthread: true)
//            }
//            else
            
            if self.lblNavigationTitle.text == v_type_featured{
                self.callGetFeaturedVideoAPI(inMainthread: true)
            }
            else if self.lblNavigationTitle.text == v_type_recently_uploaded{
                self.callGetRecentlyUploadedVideoAPI(inMainthread: true)
            }
            else{
                if categoryType == V_TYPE_DYNAMIC_CONTENT{
                    self.callGetDynamicContentVideosAPI(inMainThread: true)
                }
                else{
                    self.callGetCategoryVideoAPI(inMainthread: true)
                }
            }
        }
    }
    
    fileprivate func setupPagination() {
        
        if self.isFromCategory{
            tblVideolist.addInfiniteScroll { [weak self] (tableView) -> Void in
                guard let tempSelf = self else{
                    return
                }
                tempSelf.callGetCategoryVideoAPI(inMainthread: false)
            }
            
            tblVideolist.setShouldShowInfiniteScrollHandler { _ -> Bool in
                return self.totalRecords > self.aryAllVideos.count
            }
        }else{
            if self.lblNavigationTitle.text == v_type_featured{
                tblVideolist.addInfiniteScroll { [weak self] (tableView) -> Void in
                    guard let tempSelf = self else{
                        return
                    }
                    tempSelf.callGetFeaturedVideoAPI(inMainthread: false)
                }
                
                tblVideolist.setShouldShowInfiniteScrollHandler { _ -> Bool in
                    return !self.isAllTrendingLoaded
                }
            }
            else if self.lblNavigationTitle.text == v_type_recently_uploaded{
                tblVideolist.addInfiniteScroll { [weak self] (tableView) -> Void in
                    guard let tempSelf = self else{
                        return
                    }
                    tempSelf.callGetRecentlyUploadedVideoAPI(inMainthread: false)
                }
                
                tblVideolist.setShouldShowInfiniteScrollHandler { _ -> Bool in
                    return self.totalRecords > self.aryRecentVideos.count
                }
            }
            else{
                
                if categoryType == V_TYPE_DYNAMIC_CONTENT{
                    tblVideolist.addInfiniteScroll { [weak self] (tableView) -> Void in
                        guard let tempSelf = self else{
                            return
                        }
                        tempSelf.callGetDynamicContentVideosAPI(inMainThread: false)
                    }
                    
                    tblVideolist.setShouldShowInfiniteScrollHandler { _ -> Bool in
                        return self.totalRecords > self.arrVids.count
                    }
                }
                else{
                    tblVideolist.addInfiniteScroll { [weak self] (tableView) -> Void in
                        guard let tempSelf = self else{
                            return
                        }
                        tempSelf.callGetCategoryVideoAPI(inMainthread: false)
                    }
                    
                    tblVideolist.setShouldShowInfiniteScrollHandler { _ -> Bool in
                        return self.totalRecords > self.aryAllVideos.count
                    }
                }
                
            }
        }
    }
    
}

//MARK: - Button Event Methods
extension VideoCategoryListVC{
    @objc func actionVideoDetail(sender: UIButton){
        let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
        var v_uuid = String()
        if self.isFromCategory{
            let objModelVideoData = aryAllVideos[sender.tag]
            v_uuid = objModelVideoData.uuid ?? ""
        }else{
//            if self.lblNavigationTitle.text == v_type_trending{
//                let objModelVideoData = aryTrendingVideos[sender.tag]
//                v_uuid = objModelVideoData.video_uuid ?? ""
//            }
            if self.lblNavigationTitle.text == v_type_featured{
                let objModelVideoData = aryFeaturedVideos[sender.tag]
                v_uuid = objModelVideoData.video_uuid ?? ""
            }
            else if self.lblNavigationTitle.text == v_type_recently_uploaded{
                let objModelVideoData = aryRecentVideos[sender.tag]
                v_uuid = objModelVideoData.video_uuid ?? ""
            }
            else{
                if categoryType == V_TYPE_DYNAMIC_CONTENT{
//                    let tappedButtonIndex = self.indexPathForControl(sender, tableView: self.tblVideolist)
//                    let catInfo = aryDynamicContentVideos[tappedButtonIndex.section] as! NSDictionary
//                    let vidList = catInfo.value(forKey:API_RES.cat_videos) as! [VideoData_Info]
//                    let video = vidList[tappedButtonIndex.row]
                    let video = arrVids[sender.tag]
                    v_uuid = video.video_uuid ?? ""
                }
                else{
                    let objModelVideoData = aryAllVideos[sender.tag]
                    v_uuid = objModelVideoData.uuid ?? ""
                }
            }
        }
        
        vcDetail.strSelectedVideoId = v_uuid
        vcDetail.isFromPlaylist = false
//        self.navigationController?.present(vcDetail, animated: true, completion: nil)
        vcDetail.hidesBottomBarWhenPushed = true
        self.pushVCWithPresentAnimation(controller: vcDetail)
    }
}

//MARK:- Tableview Datasource and Delegate Methods
extension VideoCategoryListVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        // array.count/3 add number of row in actual count of array due to advertiesment show every 3 row after
        if self.isFromCategory{
            return aryAllVideos.count + aryAllVideos.count/3
        }else{
            if self.lblNavigationTitle.text == v_type_featured{
                return self.aryFeaturedVideos.count + aryFeaturedVideos.count/3
            }
            else if self.lblNavigationTitle.text == v_type_recently_uploaded{
                return self.aryRecentVideos.count + aryRecentVideos.count/3
            }
            else{
                if categoryType == V_TYPE_DYNAMIC_CONTENT{

                    return self.arrVids.count + arrVids.count/3
//                    if self.aryDynamicContentVideos.count > 0 {
//                        let catInfo = aryDynamicContentVideos[section] as! NSDictionary
//                        let vidList = catInfo.value(forKey:API_RES.cat_videos) as! [VideoData_Info]
//                        if vidList.count > 0 {
//                            return vidList.count
//                        }
//                        else{
//                            return 0
//                        }
//                    }
//                    else{
//                        return 0
//                    }
                    
                }
                else{
                    return aryAllVideos.count + aryAllVideos.count/3
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         //NK MARK:- Adverties load in Celll
        if  indexPath.row == 3 || indexPath.row % 4 == 3{
            let addCell = tblVideolist.dequeueReusableCell(withIdentifier: "AdvertiesCell", for: indexPath) as! AdvertiesCell
            self.loadMopubAdForCategoryVideoListInside(inView: addCell.viewAd)
            return addCell
        }
        //Substrack index from actual actual due to adverstiesment add in tableview then index of array index are diffrent so here substrac index from actual.
        let updatedIndex = indexPath.row - indexPath.row/4
        
        
        let cell = tblVideolist.dequeueReusableCell(withIdentifier: "ID_CellHome", for: indexPath) as! CellHome
        cell.textLabel?.backgroundColor = UIColor.clear
        
        
        var profileURL = String()
        
        if self.isFromCategory{
            let objVideoData = aryAllVideos[updatedIndex]
            
            //Duration conversion
            let duration = objVideoData.duration ?? "0"
            let doubleDuration = Double(duration) ?? 0.0
            cell.lblVideoDuration.text = self.timeFormatted(totalSeconds: Int(doubleDuration))
//            cell.lblVideoDuration.text = self.timeFormatted(totalSeconds: Int(objVideoData.duration ?? "0") ?? 0)
            
            loadImageWith(imgView: cell.imgVideo, url: objVideoData.thumbnail)
            cell.lblVideoTitle.text = objVideoData.title?.HSDecode
            cell.lblVideoAutherName.text = objVideoData.username?.HSDecode
            let totalInt = Int(objVideoData.view_count ?? "0") ?? 0
            let totalViews = self.suffixNumber(number:NSNumber.init(value: totalInt))
            cell.lblViewAndUploadTime.text = "\(totalViews) views | \(objVideoData.publish_date ?? "-")"
            
            //setDefaultPic(strImg: objVideoData.user_image ?? "", imgView: cell.imgVideoAuther, strImgName: PLACEHOLDER_IMAGENAME.small)
            profileURL = objVideoData.user_image ?? ""
            
            cell.strSelectedVideoId = aryAllVideos[updatedIndex].uuid ?? ""
            cell.strAddToStashType = AddToStash_TYPE.CategoryDetail
            
            let userID = objVideoData.user_uuid ?? ""
            cell.strUserID = String(userID)
        }
        else{
            if self.lblNavigationTitle.text == v_type_featured{
                let objVideoData = aryFeaturedVideos[updatedIndex]
                
                cell.lblVideoDuration.text = self.timeFormatted(totalSeconds: objVideoData.duration ?? 0)
                loadImageWith(imgView: cell.imgVideo, url: objVideoData.thumbnail)
                cell.lblVideoTitle.text = objVideoData.title?.HSDecode
                cell.lblVideoAutherName.text = objVideoData.user_name?.HSDecode
                let totalInt = Int(objVideoData.view_count ?? "0") ?? 0
                let totalViews = self.suffixNumber(number:NSNumber.init(value: totalInt))
                cell.lblViewAndUploadTime.text = "\(totalViews) views | \(objVideoData.publish_date ?? "-")"
                //setDefaultPic(strImg: objVideoData.video_author_profile_pic ?? "", imgView: cell.imgVideoAuther, strImgName: PLACEHOLDER_IMAGENAME.small)
                profileURL = objVideoData.user_image ?? ""
                
                cell.strSelectedVideoId = aryFeaturedVideos[updatedIndex].uuid ?? ""
                cell.strAddToStashType = AddToStash_TYPE.CategoryDetail
                
                let userID = objVideoData.user_uuid ?? ""
                cell.strUserID = String(userID)
                
            }
            else if self.lblNavigationTitle.text == v_type_recently_uploaded{
                let objVideoData = aryRecentVideos[updatedIndex]
                
                //Duration conversion
                let duration = objVideoData.duration ?? "0"
                let doubleDuration = Double(duration) ?? 0.0
                cell.lblVideoDuration.text = self.timeFormatted(totalSeconds: Int(doubleDuration))
//                cell.lblVideoDuration.text = self.timeFormatted(totalSeconds: Int(objVideoData.duration ?? "0") ?? 0)
                
                loadImageWith(imgView: cell.imgVideo, url: objVideoData.image)
                cell.lblVideoTitle.text = objVideoData.title?.HSDecode
                cell.lblVideoAutherName.text = objVideoData.user_name?.HSDecode
                let totalInt = Int(objVideoData.views ?? "0") ?? 0
                let totalViews = self.suffixNumber(number:NSNumber.init(value: totalInt))
                cell.lblViewAndUploadTime.text = "\(totalViews) views | \(objVideoData.date ?? "-")"
                //setDefaultPic(strImg: objVideoData.video_author_profile_pic ?? "", imgView: cell.imgVideoAuther, strImgName: PLACEHOLDER_IMAGENAME.small)
                profileURL = objVideoData.video_author_profile_pic ?? ""
                
                cell.strSelectedVideoId = aryRecentVideos[updatedIndex].video_uuid ?? ""
                cell.strAddToStashType = AddToStash_TYPE.CategoryDetail
                
                let userID = objVideoData.user_uuid ?? ""
                cell.strUserID = String(userID)
            }else{
                
                if categoryType == V_TYPE_DYNAMIC_CONTENT{
                    
//                    let catInfo = aryDynamicContentVideos[indexPath.section] as! NSDictionary
//                    let vidList = catInfo.value(forKey:API_RES.cat_videos) as! [VideoData_Info]
//                    let objVideoData = vidList[indexPath.row]
                    
                    let objVideoData = arrVids[updatedIndex]
                    
                    cell.lblVideoDuration.text = self.timeFormatted(totalSeconds: objVideoData.duration ?? 0)
                    loadImageWith(imgView: cell.imgVideo, url: objVideoData.thumbnail_480, placeHolderImageName: "")
                    cell.lblVideoTitle.text = objVideoData.title?.HSDecode
                    cell.lblVideoAutherName.text = objVideoData.user_name?.HSDecode
                    
                    let totalViews = self.suffixNumber(number:NSNumber.init(value: Int(objVideoData.views ?? "0") ?? 0))
                    cell.lblViewAndUploadTime.text = "\(totalViews) views | \(objVideoData.date ?? "-")"
                    
                    let profileURL = objVideoData.video_author_profile_pic ?? ""
                    if verifyUrl(urlString: profileURL){
                        cell.imgVideoAuther.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
                        loadImageWith(imgView: cell.imgVideoAuther, url: profileURL)
                        cell.imgVideoAuther.contentMode = .scaleAspectFill
                    }else{
                        cell.imgVideoAuther.frame = CGRect(x: 7.0, y: 7.0, width: 21.0, height: 21.0)
                        cell.imgVideoAuther.image = UIImage(named: Cons_Profile_Image_Name)
                        cell.imgVideoAuther.contentMode = .scaleAspectFit
                    }
                    
                    cell.strSelectedVideoId = arrVids[updatedIndex].video_uuid ?? ""
                    cell.strAddToStashType = AddToStash_TYPE.CategoryDetail
                    
                    let userID = objVideoData.visitors_uuid ?? ""
                    cell.strUserID = String(userID)
                }
                else{
                    let objVideoData = aryAllVideos[updatedIndex]
                    
                    //Duration conversion
                    let duration = objVideoData.duration ?? "0"
                    let doubleDuration = Double(duration) ?? 0.0
                    cell.lblVideoDuration.text = self.timeFormatted(totalSeconds: Int(doubleDuration))
                    
                    loadImageWith(imgView: cell.imgVideo, url: objVideoData.thumbnail)
                    cell.lblVideoTitle.text = objVideoData.title?.HSDecode
                    cell.lblVideoAutherName.text = objVideoData.username?.HSDecode
                    let totalInt = Int(objVideoData.view_count ?? "0") ?? 0
                    let totalViews = self.suffixNumber(number:NSNumber.init(value: totalInt))
                    cell.lblViewAndUploadTime.text = "\(totalViews) views | \(objVideoData.publish_date ?? "-")"
                    profileURL = objVideoData.user_image ?? ""
                    
                    cell.strSelectedVideoId = aryAllVideos[updatedIndex].uuid ?? ""
                    cell.strAddToStashType = AddToStash_TYPE.CategoryDetail
                    
                    let userID = objVideoData.user_uuid ?? ""
                    cell.strUserID = String(userID)
                }
                
            }
        }
        
        if verifyUrl(urlString: profileURL){
            cell.imgVideoAuther.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            loadImageWith(imgView: cell.imgVideoAuther, url: profileURL)
            cell.imgVideoAuther.contentMode = .scaleAspectFill
        }else{
            cell.imgVideoAuther.frame = CGRect(x: 7.0, y: 7.0, width: 21.0, height: 21.0)
            cell.imgVideoAuther.image = UIImage(named: Cons_Profile_Image_Name)
            cell.imgVideoAuther.contentMode = .scaleAspectFit
        }
        
        cell.btnVideoDetail.tag = updatedIndex
        cell.btnVideoDetail.addTarget(self, action: #selector(actionVideoDetail(sender:)), for: UIControl.Event.touchUpInside)
        cell.btnVideoName.tag = updatedIndex
        cell.btnVideoName.addTarget(self, action: #selector(actionVideoDetail(sender:)), for: UIControl.Event.touchUpInside)
        //Callback
        cell.handler = indexHandlerBlock({(index) in
            if index == 0{ //0 => Add To My Stash tap
                //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
            }else if index == 1{ //1 => Add To Playlist tap
                // Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
            }else{
                //Share
            }
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
    }
    
   //NK MARK:- Header View For adverstiesment
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.loadView(fromNib: "HeaderAds", withType: HeaderAds.self)
        self.loadMopubAdForCategoryVideoListTop(inView: headerView.viewAd)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 76.0
    }
    
}

//MARK:- API
extension VideoCategoryListVC {
    
    func callGetCategoryVideoAPI(inMainthread: Bool){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.category_id : categoryID,
                                          KEYS_API.search_param : "",
                                          KEYS_API.sort_param : "publish_date",
                                          KEYS_API.sort_type : "desc",
                                          KEYS_API.page_limit : PAGE_LIMIT,
                                          KEYS_API.page_offset : String(currentPageOffset),
                                          KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version
                                        ]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_CategoryVideoData.self,apiName:APIName.GetCategoryVideo, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblVideolist.finishInfiniteScroll()
            
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                self.totalRecords = response.recordsTotal ?? 0
                
                if self.totalRecords > 0{
                    
                    if self.currentPageOffset == 0{
                        self.aryAllVideos = [videoListData]()
                    }
                    
                    self.aryAllVideos.append(contentsOf: (response.data)!)
                    
                    self.currentPageOffset = self.aryAllVideos.count
                    
                    if self.aryAllVideos.count > 0{
                        self.tblVideolist.isHidden = false
                        self.lblNoData.isHidden = true
                    }else{
                        self.tblVideolist.isHidden = true
                        self.lblNoData.isHidden = false
                    }
                }else{
                    self.tblVideolist.isHidden = true
                    self.lblNoData.isHidden = false
                }
                
                self.tblVideolist.reloadData()
            }
            
        }, FailureBlock: { (error) in
            if inMainthread {
                self.hideLoader()
            }
            self.tblVideolist.finishInfiniteScroll()
        })
    }
    
    func callGetTrendingVideoAPI(inMainthread: Bool){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.page_offset : String(self.aryTrendingVideos.count+1),
                                          KEYS_API.page_limit : PAGE_LIMIT]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:APIName.GetTrendingVideo, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblVideolist.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                if self.currentPageOffset == 0{
                    self.aryTrendingVideos = [Model_VideoData]()
                }
                
                let responseArray = response.data ?? [Model_VideoData]()
                self.aryTrendingVideos.append(contentsOf: responseArray)
                
                if(responseArray.count >= Int(PAGE_LIMIT)!){
                    self.isAllTrendingLoaded = false
                }
                else{
                    self.isAllTrendingLoaded = true
                }
                
                if self.aryTrendingVideos.count > 0{
                    self.tblVideolist.isHidden = false
                    self.lblNoData.isHidden = true
                }else{
                    self.tblVideolist.isHidden = true
                    self.lblNoData.isHidden = false
                }
                
                self.tblVideolist.reloadData()
            }
            
            
        }, FailureBlock: { (error) in
            self.tblVideolist.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
        })
    }
    
    func callGetFeaturedVideoAPI(inMainthread: Bool){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.page_offset : String(self.aryFeaturedVideos.count+1),
                                          KEYS_API.page_limit : PAGE_LIMIT,
                                          KEYS_API.sort_param : "publish_date",
                                          KEYS_API.sort_type : "desc"]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:APIName.GetFeaturedVideo, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblVideolist.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                if self.aryFeaturedVideos.count == 0{
                    self.aryFeaturedVideos = [Model_VideoData]()
                }
                
                let responseArray = response.data ?? [Model_VideoData]()
                self.aryFeaturedVideos.append(contentsOf: responseArray)
                
                if(responseArray.count >= Int(PAGE_LIMIT)!){
                    self.isAllTrendingLoaded = false
                }
                else{
                    self.isAllTrendingLoaded = true
                }
                
                if self.aryFeaturedVideos.count > 0{
                    self.tblVideolist.isHidden = false
                    self.lblNoData.isHidden = true
                }else{
                    self.tblVideolist.isHidden = true
                    self.lblNoData.isHidden = false
                }
                
                self.tblVideolist.reloadData()
            }
            
            
        }, FailureBlock: { (error) in
            self.tblVideolist.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
        })
    }
    
    func callGetRecentlyUploadedVideoAPI(inMainthread: Bool){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.start : String(currentPageOffset),
                                          KEYS_API.length : PAGE_LIMIT]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: RecentlyUploadedVideoList_Model.self,apiName:APIName.GetAllRecentlyUploadedVideo, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblVideolist.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                self.totalRecords = response.data?.original?.recordsTotal ?? 0
                
                if self.totalRecords > 0{
                    
                    if self.currentPageOffset == 0{
                        self.aryRecentVideos = [recentlyUploadedVideoDataAry]()
                    }
                    
                    self.aryRecentVideos.append(contentsOf: (response.data?.original?.data)!)
                    self.currentPageOffset = self.aryRecentVideos.count
                    
                    if self.aryRecentVideos.count > 0{
                        self.tblVideolist.isHidden = false
                        self.lblNoData.isHidden = true
                    }else{
                        self.tblVideolist.isHidden = true
                        self.lblNoData.isHidden = false
                    }
                }else{
                    self.tblVideolist.isHidden = true
                    self.lblNoData.isHidden = false
                }
            }
            
            self.tblVideolist.reloadData()
            
        }, FailureBlock: { (error) in
            self.tblVideolist.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
            self.tblVideolist.reloadData()
        })
    }
    
    func callGetDynamicContentVideosAPI(inMainThread:Bool){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.sort_param : "publish_date",
                                          KEYS_API.sort_type : "desc",
                                          KEYS_API.uuid : categoryID,
                                          KEYS_API.page_offset : String(currentPageOffset),
                                          KEYS_API.page_limit : PAGE_LIMIT]
        
        if inMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: HomeCategoryDataModel.self,apiName:APIName.GetHomeDynamicContent, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblVideolist.finishInfiniteScroll()
            if inMainThread{
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
//                self.aryDynamicContentVideos = [Any]()
                
                let catInfo = response.data ?? [Cat_Info]()
                
                if catInfo.count > 0 {
                    
                    for categoryInfo in catInfo{
                        
//                        let catName = categoryInfo.home_content_info?.name ?? ""
//                        let catUuid = categoryInfo.home_content_info?.uuid ?? ""
                        
                        let totalRecords = categoryInfo.home_content_info?.totalRecords ?? 0
                        self.totalRecords = totalRecords
                        
                        let videos = categoryInfo.videos_info ?? [VideoData_Info]()
                        
                        
                        if self.currentPageOffset == 0{
                            self.arrVids = [VideoData_Info]()
                        }
                        
                        self.arrVids.append(contentsOf: videos)
                        
//                        let res_dict: [String: Any] = [API_RES.cat_name : catName,
//                                                       API_RES.cat_videos : videos,
//                                                       API_RES.cat_tag : V_TYPE_DYNAMIC_CONTENT,
//                                                       API_RES.cat_uuid : catUuid,
//                                                       API_RES.cat_Ad_Url : ""]
//
//                        if videos.count > 0{
//                            self.aryDynamicContentVideos.append(res_dict as Any)
//                        }
                    }
                    
                    self.currentPageOffset = self.arrVids.count
                    
                    if self.arrVids.count > 0{
                        self.tblVideolist.isHidden = false
                        self.lblNoData.isHidden = true
                    }else{
                        self.tblVideolist.isHidden = true
                        self.lblNoData.isHidden = false
                    }
                    
                }else{
                    self.tblVideolist.isHidden = true
                    self.lblNoData.isHidden = false
                }
                
                self.tblVideolist.reloadData()
            }
            
        }, FailureBlock: { (error) in
            self.tblVideolist.finishInfiniteScroll()
            
            if inMainThread{
                self.hideLoader()
            }
        
            self.tblVideolist.reloadData()
            self.aryDynamicContentVideos = [Any]()
        })
    }
    
}
