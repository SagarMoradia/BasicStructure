//
//  MyFeedVC.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 14/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class UsersVC: ParentVC,UITableViewDataSource,UITableViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var tblFeed: UITableView!
    @IBOutlet weak var tblFollowing: UITableView!
    @IBOutlet weak var consXVal: NSLayoutConstraint!
    @IBOutlet weak var selectedTabView : UIView!
    @IBOutlet weak var topView : UIView!
    @IBOutlet weak var adsView : UIView!
    @IBOutlet weak var lblNoData: darkGreyLabelCtrlModel!
    @IBOutlet weak var consHeightTop: NSLayoutConstraint!
    @IBOutlet weak var lblNavTitle : UILabel!
    
    //MARK: - Properties
    var currentPage = 0 //0 for My Feed and 1 for Users
    var aryAllVideos = [ModelHome]()
    var arrUsers = [userlistDataAry]()
    var arrFeedList = [FeedData]()
    var currentPageOffset: Int = 0
    var totalRecords: Int = 0
    var currentPageOffsetFeed : Int = 0
    var totalFeedRecords: Int = 0
    
    var isFromFollowingList = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
        self.setupPagination()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblFollowing.setContentOffset(.zero, animated: true)
        tblFeed.setContentOffset(.zero, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK: - Intial Methods
    func prepareViews() {
        tblFeed.register(UINib.init(nibName: "CellHome", bundle: nil), forCellReuseIdentifier: "ID_CellHome")
        tblFollowing.register(UINib.init(nibName: "CellFollowing", bundle: nil), forCellReuseIdentifier: "ID_ CellFollowing")
        tblFeed.tableFooterView = UIView()
        tblFollowing.tableFooterView = UIView()
        tblFeed.estimatedRowHeight = UITableView.automaticDimension
        tblFollowing.estimatedRowHeight = UITableView.automaticDimension
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tblFollowing.tableHeaderView = UIView(frame: frame)
        
        var frame1 = CGRect.zero
        frame1.size.height = .leastNormalMagnitude
        tblFollowing.tableFooterView = UIView(frame: frame1)
        
        self.tblFollowing.contentInset = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        self.addShadowToView(view: topView)
        
        self.apiCall()
    }
    
    func apiCall() {
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            //show user tab only
            lblNavTitle.text = Cons_Subscriptions
            consHeightTop.constant = 0
            currentPage = 1
            arrUsers = [userlistDataAry]()
            currentPageOffset = 0
            totalRecords = 0
            adsView.isHidden = false
            self.callUserListAPI(inMainthread: true)
        }else{
            //show both tab
            lblNavTitle.text = Cons_Subscriptions //Cons_Users
            consHeightTop.constant = 40
            if currentPage == 0{
                lblNoData.text = "No feeds available"
                arrFeedList = [FeedData]()
                currentPageOffsetFeed = 0
                totalFeedRecords = 0
                adsView.isHidden = true
                self.callFeedListAPI(inMainthread: true)
            }else{
                arrUsers = [userlistDataAry]()
                currentPageOffset = 0
                totalRecords = 0
                adsView.isHidden = false
                self.callUserListAPI(inMainthread: true)
            }
        }
    }
    
    fileprivate func setupPagination() {
        
        tblFeed.addInfiniteScroll { [weak self] (tableView) -> Void in
            
            guard let tempSelf = self else{
                return
            }
            
            tempSelf.callFeedListAPI(inMainthread: false)
        }
        
        tblFollowing.addInfiniteScroll { [weak self] (tableView) -> Void in
            
            guard let tempSelf = self else{
                return
            }
            
            tempSelf.callUserListAPI(inMainthread: false)
        }
        
        if currentPage == 0{
            tblFeed.setShouldShowInfiniteScrollHandler { (_) -> Bool in
                return self.totalFeedRecords > self.arrFeedList.count
            }
        }
        
        else if currentPage == 1{
            tblFollowing.setShouldShowInfiniteScrollHandler { _ -> Bool in
                return self.totalRecords > self.arrUsers.count
            }
        }
    }
    
    //MARK:- Button Event Methods
    @IBAction func btnSearchTapped(_ sender: UIBarButtonItem) {
        let objSearch = self.MAKE_STORY_OBJ_TABBAR(Identifier: STORYBOARD_IDENTIFIER.SearchVC) as! SearchVC
        self.navigationController?.pushViewController(objSearch, animated: false)
    }
    
    @IBAction func btnChangeModule(_ sender:UIControl){
        
        if currentPage == sender.tag - 2000{
            return
        }
        
        let lblOld = view.viewWithTag(1000+currentPage) as! UILabel
        lblOld.font = fontType.InterUI_Medium_13
        lblOld.textColor = UIColor.textColor_light_white
       
        currentPage = sender.tag - 2000
    
        if currentPage == 0{
            print("\n-------------My Feed Tapped----------\n")
            tblFeed.isHidden = false
            tblFollowing.isHidden = true
            adsView.isHidden = true
            arrFeedList = [FeedData]()
            currentPageOffsetFeed = 0
            totalFeedRecords = 0
            lblNoData.text = "No feeds available"
            self.callFeedListAPI(inMainthread: true)
        }else{
            print("\n-------------Following Tapped----------\n")
            tblFeed.isHidden = true
            tblFollowing.isHidden = false
            adsView.isHidden = false
            arrUsers = [userlistDataAry]()
            currentPageOffset = 0
            totalRecords = 0
            lblNoData.text = "No subscribers available"
            self.callUserListAPI(inMainthread: true)
        }
    
        let lblNew = view.viewWithTag(1000+currentPage) as! UILabel
        lblNew.font = fontType.InterUI_Medium_13
        lblNew.textColor = UIColor.white
        
        UIView.animate(withDuration: 0.25) {
            self.selectedTabView.frame = CGRect(x: sender.frame.minX, y: self.selectedTabView.frame.minY, width: sender.frame.width, height: self.selectedTabView.frame.height)
        }
        
    }
    
    //MARK:- API
    func callFeedListAPI(inMainthread: Bool) {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams = [KEYS_API.is_subList : "1",
                           KEYS_API.page_offset : String(currentPageOffsetFeed),
                           KEYS_API.length : PAGE_LIMIT,
                           KEYS_API.platform : APIConstant.platform,
                           KEYS_API.version : KEYS_API.app_version,
                            KEYS_API.sort_param : "publish_date",
                            KEYS_API.sort_type : "desc"]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: ModelFeedList.self,apiName:APIName.FeedList, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblFeed.finishInfiniteScroll()
            
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                self.totalFeedRecords = response.recordsTotal ?? 0
                
                if self.totalFeedRecords > 0{
                    
                    if self.currentPageOffsetFeed == 0{
                        self.arrFeedList = [FeedData]()
                    }
                    
                    self.arrFeedList.append(contentsOf: (response.data)!)
                    
                    self.currentPageOffsetFeed = self.arrFeedList.count
                    
                    if self.arrFeedList.count > 0{
                        self.tblFeed.isHidden = false
                        self.lblNoData.isHidden = true
                    }else{
                        self.tblFeed.isHidden = true
                        self.lblNoData.isHidden = false
                    }
                }
                else{
                    self.tblFeed.isHidden = true
                    self.lblNoData.isHidden = false
                }
                
                self.tblFeed.reloadData()
            }
            
        }, FailureBlock: { (error) in
            self.tblFeed.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
        })
    }
    
    func callUserListAPI(inMainthread: Bool) {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        var queryParams = [String: Any]()
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            queryParams = [KEYS_API.search_param : "",
                                              KEYS_API.sort_param : "",
                                              KEYS_API.sort_type : "",
                                              KEYS_API.length : PAGE_LIMIT,
                                              KEYS_API.start : String(currentPageOffset),
                                              KEYS_API.platform : APIConstant.platform,
                                              KEYS_API.version : KEYS_API.app_version
            ]
        }else{
            queryParams = [KEYS_API.uuid : "",
                           KEYS_API.start : String(currentPageOffset),
                           KEYS_API.length : PAGE_LIMIT,
                           KEYS_API.platform : APIConstant.platform,
                           KEYS_API.version : KEYS_API.app_version
            ]
            
        }
        
      
        var strApiName = ""
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            strApiName = APIName.GetUserSearchlist
            isFromFollowingList = false
            lblNoData.text = "No users available"
            
        }else{
            strApiName = APIName.FollowersList
            isFromFollowingList = true
            lblNoData.text = "No subscribers available"
        }
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Userlist_Model.self,apiName:strApiName, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblFollowing.finishInfiniteScroll()
            
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
                    
                    if self.arrUsers.count > 0{
                        self.tblFollowing.isHidden = false
                        self.lblNoData.isHidden = true
                    }else{
                        self.tblFollowing.isHidden = true
                        self.lblNoData.isHidden = false
                    }
                }
                else{
                    self.tblFollowing.isHidden = true
                    self.lblNoData.isHidden = false
                }
                
                self.tblFollowing.reloadData()
            }
            
        }, FailureBlock: { (error) in
            self.tblFollowing.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
        })
    }
    
    func callFollowUnFollowAPI(inMainthread: Bool,strFollowingID:String,strFollowUnFollowStatus:String,tag:Int)  {
        GLOBAL.sharedInstance.callFollowUpfollowAPI(strFollowingID: strFollowingID, strIsFollowUnFollow: strFollowUnFollowStatus, isInMainThread: inMainthread,completionBlock: { (status, message) in
            
            if(status){
                self.alertOnTop(message: message, style: .success)
                self.arrUsers.removeAll()
                self.currentPageOffset = 0
                self.totalRecords = 0
                self.callUserListAPI(inMainthread: true)
                //self.arrUsers.remove(at: tag)
                //self.tblFollowing.reloadData()
            }
        })
    }
}

extension UsersVC{
    @objc func actionVideoDetail(sender: UIButton){
        
        let tappedButtonIndex = self.indexPathForControl(sender, tableView: self.tblFeed)
        print("\(tappedButtonIndex.row)" + " " + "\(tappedButtonIndex.section)")

        let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
        vcDetail.strSelectedVideoId = self.arrFeedList[tappedButtonIndex.row].uuid ?? ""
        vcDetail.isFromPlaylist = false
//        self.navigationController?.present(vcDetail, animated: true, completion: nil)
        vcDetail.hidesBottomBarWhenPushed = true
        self.pushVCWithPresentAnimation(controller: vcDetail)
    }
}


//MARK: - Tableview Datasource and Delegate Methods
extension UsersVC{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblFeed{
            return self.arrFeedList.count
        }
        else if tableView == tblFollowing{
            return self.arrUsers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentPage == 0{
            if tableView == tblFeed{
                let cell = tblFeed.dequeueReusableCell(withIdentifier: "ID_CellHome", for: indexPath) as! CellHome
                cell.textLabel?.backgroundColor = UIColor.clear

                cell.btnVideoDetail.tag = indexPath.row
                cell.btnVideoDetail.addTarget(self, action: #selector(actionVideoDetail(sender:)), for: UIControl.Event.touchUpInside)
                cell.btnVideoName.tag = indexPath.row
                cell.btnVideoName.addTarget(self, action: #selector(actionVideoDetail(sender:)), for: UIControl.Event.touchUpInside)
                cell.objModelFeed = self.arrFeedList[indexPath.row]
                cell.strUserID = self.arrFeedList[indexPath.row].user_uuid ?? ""
                cell.strSelectedVideoId = self.arrFeedList[indexPath.row].uuid ?? ""
                cell.strAddToStashType = AddToStash_TYPE.Users

                //Callback
                cell.handler = indexHandlerBlock({(index) in
                    if index == 0{ //0 => Add To My Stash tap

                    }else if index == 1 { //1 => Add To Playlist tap

                    }else{
                        //Share
                    }
                })

                return cell
            }
        }
        else if currentPage == 1{
            if tableView == tblFollowing{
                let cell = tblFollowing.dequeueReusableCell(withIdentifier: "ID_ CellFollowing", for: indexPath) as! CellFollowing
                cell.btnSubscribe.tag = indexPath.row
                cell.btnSubscribe.addTarget(self, action: #selector(actionSubscribe(sender:)), for: .touchUpInside)
                cell.isFromFollowingList = isFromFollowingList
                cell.objModelUser = self.arrUsers[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentPage == 1{
            if tableView == tblFollowing{
                let objUser = self.arrUsers[indexPath.row]
                let viewController = UIStoryboard.init(name: ("Main"), bundle: nil).instantiateViewController(withIdentifier: "ProfileMainVC") as! ProfileMainVC
                viewController.hidesBottomBarWhenPushed = true
                if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
                    viewController.user_uuid = objUser.uuid ?? ""
                }else{
                    viewController.user_uuid = objUser.users_uuid ?? ""
                }
                viewController.isForOwnProfile = false
                let topNavigationVC = UIApplication.topViewController()
                topNavigationVC?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if currentPage == 1{
            if tableView == tblFollowing{
                let headerView = Bundle.loadView(fromNib: "HeaderAds", withType: HeaderAds.self)
                self.loadMopubAdForSubscriptionList(inView: headerView.viewAd)
                return headerView
            }else{
                return UIView()
            }
        }else{
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if currentPage == 1{
            if tableView == tblFollowing{
                return 76.0 //aryAllVideos[section].footerAdsUrl?.count ?? -1 > 0 ? 76 : 0.0
            }
            else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    //MARK:- Subscribe Event Methods
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
            let strMsg = Cons_Unsubscribe + " " + objUser.first_name! + " " + objUser.last_name! + "?"
            Alert.shared.showAlertWithHandler(title: App_Name, message: strMsg, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.callFollowUnFollowAPI(inMainthread: true, strFollowingID: objUser.users_uuid ?? "", strFollowUnFollowStatus: Cons_unfollow, tag: sender.tag)
                default:
                    print("Cancel tapped")
                }
            })
        }
    }
}
