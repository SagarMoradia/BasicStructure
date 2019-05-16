//
//  SearchResultVC.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 27/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class SearchResultVC: ParentVC, UITextFieldDelegate {

    var handlerBlock : CompletionHandler!
    
    @IBOutlet weak var tblSearchResult: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var ctrlVideos: UIControl!
    @IBOutlet weak var ctrlUsers: UIControl!
    @IBOutlet weak var ctrlPlayList: UIControl!
    @IBOutlet weak var selectedTabView : UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblNoData: darkGreyLabelCtrlModel!
    
    @IBOutlet weak var tblBottonContraint: NSLayoutConstraint!
    @IBOutlet weak var viewAd: UIView!
    
    var arrVideos   = [videoListData]()
    var arrPlaylist = [playlistDataAry]()
    var arrUsers    = [userlistDataAry]()
    
    var currentPage = 0
    var is_searching:Bool!
    var searchStr : String = ""
    var currentPageOffset: Int = 0
    var totalRecords: Int = 0
    
    var strFollowUnFollow = String()
    
    //MARK:- UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewResizerOnKeyboardShown()
        self.txtSearch.text = searchStr
        self.prepareViews()
        self.setupPagination()
        tblSearchResult.register(UINib.init(nibName: "AdvertiesCell", bundle: nil), forCellReuseIdentifier: "AdvertiesCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.closeButtonState()
    }
    
    //MARK:- Keyboard Handler Methods
    func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowForResizing(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideForResizing(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShowForResizing(notification: Notification) {
        
        let statusbarHeight = UIApplication.shared.statusBarView?.frame.height ?? 0.0
        let navHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            self.tblBottomConstraint.constant = keyboardSize.height - navHeight - statusbarHeight + 10
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        self.tblBottomConstraint.constant = 0.0
    }
    
    //MARK:- Helper Methods
    func closeButtonState(){
        if (txtSearch.text?.count)! > 0 {
            self.btnClose.isEnabled = true
            self.btnClose.alpha = 1.0
        }else{
            self.btnClose.isEnabled = false
            self.btnClose.alpha = 0.0
        }
        
        self.btnClose.isHidden = true
    }
    
    func prepareViews(){
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tblSearchResult.tableHeaderView = UIView(frame: frame)
        self.tblSearchResult.contentInset = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        ctrlVideos.alpha   = 1.0
        ctrlUsers.alpha    = 0.5
        ctrlPlayList.alpha = 0.5
        
        //txtSearch.becomeFirstResponder()
        txtSearch.text = searchStr

        is_searching = false
        txtSearch.delegate = self
        txtSearch.attributedPlaceholder = NSAttributedString(string: "Search TheWeedTube",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        newBackButton.image = UIImage(named: "Nav_back")
        self.navigationItem.leftBarButtonItem = newBackButton
        
        //Video Cells
        tblSearchResult.register(UINib.init(nibName: "CellHome", bundle: nil), forCellReuseIdentifier: "ID_CellHome")
        
        //User Cells
        tblSearchResult.register(UINib.init(nibName: "CellFollowing", bundle: nil), forCellReuseIdentifier: "ID_ CellFollowing")
        
        //Playlist Cells
        tblSearchResult.register(UINib.init(nibName: "CellPlaylist_1", bundle: nil), forCellReuseIdentifier: "ID_CellPlaylist_1")
        tblSearchResult.register(UINib.init(nibName: "CellPlaylist_2", bundle: nil), forCellReuseIdentifier: "ID_CellPlaylist_2")
        tblSearchResult.register(UINib.init(nibName: "CellPlaylist_3", bundle: nil), forCellReuseIdentifier: "ID_CellPlaylist_3")
        
        //self.populateVideosData()
        self.tblSearchResult.isHidden = true
        self.lblNoData.isHidden = true
        self.callAPIs(inMainthread: true)
        //self.preparePlaylistTempData()
    }
    
    func resetAllArray() {
        self.arrVideos   = [videoListData]()
        self.arrUsers    = [userlistDataAry]()
        self.arrPlaylist = [playlistDataAry]()
    }
    
    fileprivate func setupPagination() {
        
        // Add infinite scroll handler
        tblSearchResult.addInfiniteScroll { [weak self] (tableView) -> Void in
            
            guard let tempSelf = self else{
                return
            }
            
            tempSelf.callAPIs(inMainthread: false)
        }
        
        if currentPage == 0{
            tblSearchResult.setShouldShowInfiniteScrollHandler { _ -> Bool in
                return self.totalRecords > self.arrVideos.count
            }
        }else if currentPage == 1{
            tblSearchResult.setShouldShowInfiniteScrollHandler { _ -> Bool in
                return self.totalRecords > self.arrUsers.count
            }
        }else if currentPage == 2{
            tblSearchResult.setShouldShowInfiniteScrollHandler { _ -> Bool in
                return self.totalRecords > self.arrPlaylist.count
            }
        }
    }
    
    //MARK:- UITextFieldDelegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print(string)
        let charCount = textField.text?.count ?? 0
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            if charCount == 3 || charCount == 2 {
                //self.resetAllArray()
                self.tblSearchResult.reloadData()
                self.tblSearchResult.isHidden = true
            }else if charCount == 1{
                self.btnClose.setImage(UIImage(named: ""), for: .normal)
            }else{
                if charCount >= 2{
                    let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
                    searchStr = newString
                    //self.resetAllArray()
                    self.callAPIs(inMainthread: true)
                }
            }
        }else{
            if charCount > 0{
                is_searching = true
                self.btnClose.setImage(UIImage(named: "Nav_close"), for: .normal)
            }else{
                is_searching = false
                self.btnClose.setImage(UIImage(named: ""), for: .normal)
            }
            
            if charCount >= 2{
                let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
                searchStr = newString
                //self.resetAllArray()
                self.callAPIs(inMainthread: true)
            }
            
            if charCount < 3 {
                //EHGlobal.sharedInstance.hideLoadingIndicator()
            }
        }
        
        self.closeButtonState()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text != "" {
            textField.resignFirstResponder()
            //            self.callSearchAPI()
            self.searchBarSearchButtonClicked(textField.text!)
            return true
        }else{
            return false
        }
    }
    
    private func searchBarSearchButtonClicked(_ searchStr: String) {
        print("You have searched for ", searchStr)
        self.view.endEditing(true)
        self.searchStr = searchStr
        //self.resetAllArray()
        is_searching = true
        self.callAPIs(inMainthread: true)
    }
    
    //MARK: - Action Methods
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnBackTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnCloseTap(_ sender: UIButton) {
        self.txtSearch.text = ""
        self.searchStr = self.txtSearch.text!
        self.closeButtonState()
        self.resetAllArray()
        self.callAPIs(inMainthread: false)
    }
    
    @IBAction func btnTabChanged(_ sender: UIControl) {
        
        if currentPage == sender.tag - 2000{
            return
        }
        
//        let lblOld = self.view.viewWithTag(1000+currentPage) as! UILabel
//        lblOld.font = fontType.InterUI_Medium_13
//        lblOld.textColor = UIColor.textColor_light_white
        
        currentPage = sender.tag - 2000
        
        self.currentPageOffset = 0
        self.totalRecords = 0
        
        if currentPage == 0{
            print("\n---------------Videos Tab-------------\n")
            ctrlVideos.alpha   = 1.0
            ctrlUsers.alpha    = 0.5
            ctrlPlayList.alpha = 0.5
            
            self.arrVideos = [videoListData]()
            self.callAPIs(inMainthread: true)
        }else if currentPage == 1{
            print("\n---------------Users Tab-------------\n")
            ctrlVideos.alpha   = 0.5
            ctrlUsers.alpha    = 1.0
            ctrlPlayList.alpha = 0.5
            
            self.arrUsers = [userlistDataAry]()
            self.callAPIs(inMainthread: true)
        }else if currentPage == 2{
            print("\n---------------Playlists Tab-------------\n")
            ctrlVideos.alpha   = 0.5
            ctrlUsers.alpha    = 0.5
            ctrlPlayList.alpha = 1.0
            
            self.arrPlaylist  = [playlistDataAry]()
            self.callAPIs(inMainthread: true)
        }
        
        self.tblSearchResult.reloadData()
        
//        let lblNew = self.view.viewWithTag(1000+currentPage) as! UILabel
//        lblNew.font = fontType.InterUI_Medium_13
//        lblNew.textColor = UIColor.white
        
        UIView.animate(withDuration: 0.25) {
            self.selectedTabView.frame = CGRect(x: sender.frame.minX, y: self.selectedTabView.frame.minY, width: sender.frame.width, height: self.selectedTabView.frame.height)
        }
    }
    
    //MARK: - API Methods
    func callAPIs(inMainthread: Bool){
        if currentPage == 0{
            self.callVideoListAPI(inMainthread: inMainthread)
        }else if currentPage == 1{
            self.callUserListAPI(inMainthread: inMainthread)
        }else if currentPage == 2{
            self.callPlaylistAPI(inMainthread: inMainthread)
        }
    }
    
    func callVideoListAPI(inMainthread: Bool) {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.category_id : "",
                                          KEYS_API.search_param : searchStr,
                                          KEYS_API.sort_param : "view_count",
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
            
            self.tblSearchResult.finishInfiniteScroll()
            
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
                    
                    self.tblSearchResult.isHidden = false
                    self.lblNoData.isHidden = true
                }else{
                    self.tblSearchResult.isHidden = true
                    self.lblNoData.isHidden = false
                }
                
                self.tblSearchResult.reloadData()
            }
            
        }, FailureBlock: { (error) in
            self.tblSearchResult.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
        })
    }
    
    func callUserListAPI(inMainthread: Bool) {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.search_param : searchStr,
                                          KEYS_API.sort_param : "total_followers",
                                          KEYS_API.sort_type : "desc",
                                          KEYS_API.length : PAGE_LIMIT,
                                          KEYS_API.start : String(currentPageOffset),
                                          KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version
        ]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Userlist_Model.self,apiName:APIName.GetUserSearchlist, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblSearchResult.finishInfiniteScroll()
            
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                self.totalRecords = response.data?.original?.recordsTotal ?? 0
                
                if self.totalRecords > 0{
                    
                    if self.currentPageOffset == 0{
                        self.arrUsers = [userlistDataAry]()
                    }
                    
                    self.arrUsers.append(contentsOf: (response.data?.original?.data)!)
                    
                    self.currentPageOffset = self.arrUsers.count
                    
                    self.tblSearchResult.isHidden = false
                    self.lblNoData.isHidden = true
                }else{
                    self.tblSearchResult.isHidden = true
                    self.lblNoData.isHidden = false
                }
                
                self.tblSearchResult.reloadData()
            }
            
        }, FailureBlock: { (error) in
            self.tblSearchResult.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
        })
    }
    
    func callPlaylistAPI(inMainthread: Bool) {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.search_param : searchStr,
                                          KEYS_API.sort_param : "",
                                          KEYS_API.sort_type : "",
                                          KEYS_API.length : PAGE_LIMIT,
                                          KEYS_API.start : String(currentPageOffset),
                                          KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.is_public : 1
        ]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Playlist_Model.self,apiName:APIName.GetPlaylist, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblSearchResult.finishInfiniteScroll()
            
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
                    
                    self.tblSearchResult.isHidden = false
                    self.lblNoData.isHidden = true
                }else{
                    self.tblSearchResult.isHidden = true
                    self.lblNoData.isHidden = false
                }
                
                self.tblSearchResult.reloadData()
            }
            
        }, FailureBlock: { (error) in
            self.tblSearchResult.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
        })
    }
    
    func callFollowUnFollowAPI(inMainthread: Bool,strFollowingID:String,strFollowUnFollowStatus:String,tag:Int)  {
        GLOBAL.sharedInstance.callFollowUpfollowAPI(strFollowingID: strFollowingID, strIsFollowUnFollow: strFollowUnFollowStatus, isInMainThread: inMainthread,completionBlock: { (status, message) in
            
            if(status){
                self.alertOnTop(message: message, style: .success)
                
                let strFollowUnFollow = self.arrUsers[tag]
                if strFollowUnFollow.is_follow == "No"{
                    strFollowUnFollow.is_follow = "Yes"
                }else{
                    strFollowUnFollow.is_follow = "No"
                }
                
                self.tblSearchResult.reloadData()
            }
        })
    }
}

//MARK: - Button Event Methods
extension SearchResultVC{
    @objc func actionVideoDetail(sender: UIButton){
        
        print(arrVideos)
        let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
        vcDetail.strSelectedVideoId = arrVideos[sender.tag].uuid ?? ""
        vcDetail.isFromPlaylist = false
        vcDetail.hidesBottomBarWhenPushed = true
        self.pushVCWithPresentAnimation(controller: vcDetail)
        
    }
}

//MARK:- UITableViewDataSource and UITableViewDelegate Methods
extension SearchResultVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
         // array.count/3 add number of row in actual count of array due to advertiesment show every 3 row after
        
        if currentPage == 0{
            return self.arrVideos.count + arrVideos.count/3
        }else if currentPage == 1{
            return self.arrUsers.count
        }else{
            return self.arrPlaylist.count + arrPlaylist.count/3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentPage == 0{
            
            
            //NK MARK:- Adverties load in Celll
            if  indexPath.row == 3 || indexPath.row % 4 == 3{
                let addCell = tableView.dequeueReusableCell(withIdentifier: "AdvertiesCell", for: indexPath) as! AdvertiesCell
                self.loadMopubAdForSearchScreenInside(inView: addCell.viewAd)
                return addCell
            }
            //Substrack index from actual actual due to adverstiesment add in tableview then index of array index are diffrent so here substrac index from actual.
            let updatedIndex = indexPath.row - indexPath.row/4
            
            let cell = tblSearchResult.dequeueReusableCell(withIdentifier: "ID_CellHome", for: indexPath) as! CellHome
            cell.textLabel?.backgroundColor = UIColor.clear
            
            cell.btnVideoDetail.tag = updatedIndex
            cell.btnVideoDetail.addTarget(self, action: #selector(actionVideoDetail(sender:)), for: UIControl.Event.touchUpInside)
            cell.btnVideoName.tag = updatedIndex
            cell.btnVideoName.addTarget(self, action: #selector(actionVideoDetail(sender:)), for: UIControl.Event.touchUpInside)
            let objSearchVideos = self.arrVideos[updatedIndex]
            
            //Duration conversion
            let duration = objSearchVideos.duration ?? "0"
            let doubleDuration = Double(duration) ?? 0.0
            cell.lblVideoDuration.text = self.timeFormatted(totalSeconds: Int(doubleDuration))
            
            loadImageWith(imgView: cell.imgVideo, url: objSearchVideos.thumbnail)
            cell.lblVideoTitle.text = objSearchVideos.title?.HSDecode
            cell.lblVideoAutherName.text = objSearchVideos.username?.HSDecode
            let totalInt = Int(objSearchVideos.view_count ?? "0") ?? 0
            let totalViews = self.suffixNumber(number:NSNumber.init(value: totalInt))
            cell.lblViewAndUploadTime.text = "\(totalViews) views | \(objSearchVideos.publish_date ?? "-")"
            //loadImageWith(imgView: cell.imgVideoAuther, url: objSearchVideos.user_image)
            //sweta changes
            setDefaultPic(strImg: objSearchVideos.user_image ?? "", imgView: cell.imgVideoAuther, strImgName: PLACEHOLDER_IMAGENAME.small)
            
            cell.strSelectedVideoId = arrVideos[updatedIndex].uuid ?? ""
            cell.strAddToStashType = AddToStash_TYPE.Search
            
            let userID = objSearchVideos.user_uuid ?? ""
            cell.strUserID = String(userID)
            
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
        }else if currentPage == 1{
            let cell = tblSearchResult.dequeueReusableCell(withIdentifier: "ID_ CellFollowing", for: indexPath) as! CellFollowing
            cell.isFromFollowingList = false
            cell.objModelUser = self.arrUsers[indexPath.row]
            cell.btnSubscribe.tag = indexPath.row
            cell.btnSubscribe.addTarget(self, action: #selector(actionSubscribe(sender:)), for: .touchUpInside)
            return cell
        }else{
            //NK MARK:- Adverties load in Celll
            if  indexPath.row == 3 || indexPath.row % 4 == 3{
                let addCell = tableView.dequeueReusableCell(withIdentifier: "AdvertiesCell", for: indexPath) as! AdvertiesCell
                self.loadMopubAdForSearchScreenInside(inView: addCell.viewAd)
                return addCell
            }
            // Substrack index from actual actual due to adverstiesment add in tableview then index of array index are diffrent so here substrac index from actual.
            let updatedIndex = indexPath.row - indexPath.row/4
            
            let modelPlaylist = self.arrPlaylist[updatedIndex]
            var mediaCount = modelPlaylist.media_image?.count ?? 0
            mediaCount = mediaCount == 0 ? 1 : mediaCount > 3 ? 3 : mediaCount
            let cell = tblSearchResult.dequeueReusableCell(withIdentifier: "ID_CellPlaylist_\(mediaCount)", for: indexPath) as! CellPlaylist
            cell.objModelPlaylistNew = modelPlaylist
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentPage == 1{
            let objUser = self.arrUsers[indexPath.row]
            let profileVC = self.MAKE_STORY_OBJ_MAIN(Identifier: "ProfileMainVC") as! ProfileMainVC
            profileVC.hidesBottomBarWhenPushed = true
            profileVC.user_uuid = objUser.uuid ?? ""
            profileVC.isForOwnProfile = false
            let topNavigationVC = UIApplication.topViewController()
            topNavigationVC?.navigationController?.pushViewController(profileVC, animated: true)
        }
        else if currentPage == 2{
            let updatedIndex = indexPath.row - indexPath.row/4
            let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VedioPlayListVC") as! VideoPlayListVC
            vcDetail.strSelectedVideoId = arrPlaylist[updatedIndex].first_video_details?.uuid ?? ""
            vcDetail.strPlaylistVideoId = arrPlaylist[updatedIndex].uuid ?? ""
            vcDetail.strSelectedVideoTitle = arrPlaylist[updatedIndex].name ??  ""
            vcDetail.isFromPlaylist = true
            self.navigationController?.pushViewController(vcDetail, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = Bundle.loadView(fromNib: "HeaderAds", withType: HeaderAds.self)
            self.loadMopubAdForSearchScreenTop(inView: headerView.viewAd)
            return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 76.0
    }
}

//MARK:- Tap Event Methods
extension SearchResultVC{
    @objc func actionSubscribe(sender: UIButton) {
        let objUser = self.arrUsers[sender.tag]
        print(objUser.first_name!)
        
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
            let strFollow = objUser.is_follow
            if strFollow == "No"{
                strFollowUnFollow = "1"
            }else{
                strFollowUnFollow = "0"
            }
            self.callFollowUnFollowAPI(inMainthread: true, strFollowingID: objUser.uuid ?? "", strFollowUnFollowStatus: self.strFollowUnFollow, tag: sender.tag)
        }
    }
}
