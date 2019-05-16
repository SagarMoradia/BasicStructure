//
//  NotificationVC.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 14/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class NotificationVC: ParentVC {

    @IBOutlet weak var tblNotificationList: UITableView!
    @IBOutlet weak var lblNoData: darkGreyLabelCtrlModel!
    
    //MARK: - Properties
    var aryNotification = [NotificationDataAry]()
    var currentPageOffset: Int = 0
    var totalRecords: Int = 0
    
    var isAPICall: String = "yes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //prepareViews()
        self.setupPagination()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        prepareViews()
    }
    
    //MARK: - Intial Methods
    func prepareViews() {
        tblNotificationList.delegate = self
        tblNotificationList.dataSource = self
        
        tblNotificationList.estimatedRowHeight = UITableView.automaticDimension
        
        let nibProfileName = UINib(nibName: "CellNotification", bundle: nil)
        tblNotificationList.register(nibProfileName, forCellReuseIdentifier: "ID_CellNotification")
        
        self.aryNotification = [NotificationDataAry]()
        currentPageOffset = 0
        self.callNotificationListAPI(inMainthread: true)
    }
    
    fileprivate func setupPagination() {
        tblNotificationList.addInfiniteScroll { [weak self] (tableView) -> Void in
            guard let tempSelf = self else{
                return
            }
            tempSelf.callNotificationListAPI(inMainthread: false)
        }
        
        tblNotificationList.setShouldShowInfiniteScrollHandler { _ -> Bool in
            if self.isAPICall.lowercased() == "yes"{
                return true
            }
            else{
                return false
            }
//            return self.totalRecords > self.aryNotification.count
        }
    }
    
    //MARK: - Action Methods
    @IBAction func btnSettingsTap(_ sender: UIButton) {
//        self.PUSH_STORY_R1(Identifier: STORYBOARD_IDENTIFIER.SettingsVC)
        self.PUSH_STORY_R1(Identifier: STORYBOARD_IDENTIFIER.EmailNotificationsVC)
    }

    //MARK: - API Methods
    func callNotificationListAPI(inMainthread: Bool) {
        
        if inMainthread {
            self.showLoader()
        }
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams = [KEYS_API.start : String(currentPageOffset),
                           KEYS_API.length : PAGE_LIMIT,
                           KEYS_API.platform : APIConstant.platform,
                           KEYS_API.version : KEYS_API.app_version]
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: NotificationModel.self,apiName:APIName.NotificationList, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblNotificationList.finishInfiniteScroll()
            
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                let apicall = response.data?.original?.endOfRecord ?? 0
                if apicall == 1 {
                    self.isAPICall = "no"
                }
                else{
                    self.isAPICall = "yes"
                }

                if self.currentPageOffset == 0{
                    self.aryNotification = [NotificationDataAry]()
                }

                self.aryNotification.append(contentsOf: (response.data?.original?.data)!)

                if self.aryNotification.count > 0{
                    self.tblNotificationList.isHidden = false
                    self.lblNoData.isHidden = true
                }
                else{
                    self.tblNotificationList.isHidden = true
                    self.lblNoData.isHidden = false
                }

                self.currentPageOffset = response.data?.original?.start ?? 0
                
                
                
//                self.totalRecords = response.data?.original?.recordsTotal ?? 0
//
//                if self.totalRecords > 0{
//
//                    if self.currentPageOffset == 0{
//                        self.aryNotification = [NotificationDataAry]()
//                    }
//
//                    self.aryNotification.append(contentsOf: (response.data?.original?.data)!)
//
//                    self.currentPageOffset = self.aryNotification.count
//
//                    self.tblNotificationList.isHidden = false
//                    self.lblNoData.isHidden = true
//                }
//                else{
//                    self.tblNotificationList.isHidden = true
//                    self.lblNoData.isHidden = false
//                }
                
                
                self.tblNotificationList.reloadData()
            }
            
        }, FailureBlock: { (error) in
            self.tblNotificationList.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
        })
    }
}

//MARK:- UITableViewDataSource and UITableViewDelegate Methods
extension NotificationVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID_CellNotification", for: indexPath) as! CellNotification
        cell.objModelNotification = aryNotification[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let objNotification = aryNotification[indexPath.row]
        
        let strNotificationUDID = objNotification.uuid ?? ""
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams = [KEYS_API.uuid : strNotificationUDID]
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: DeleteVideoModel.self,apiName:APIName.NotificationRead, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                var nType = objNotification.component_name ?? ""
                if nType != ""{
                    nType = nType.lowercased()
                    if nType == n_type_profile || nType == n_type_user{
                        let profileVC = self.MAKE_STORY_OBJ_MAIN(Identifier: "ProfileMainVC") as! ProfileMainVC
                        profileVC.hidesBottomBarWhenPushed = true
                        profileVC.user_uuid = objNotification.user_uuid ?? ""
                        profileVC.isForOwnProfile = false
                        let topNavigationVC = UIApplication.topViewController()
                        topNavigationVC?.navigationController?.pushViewController(profileVC, animated: true)
                    }
                    else if nType == n_type_video || nType == n_type_comment{
                        print("Redirect to Video Details Screen")
                        let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
                        vcDetail.strSelectedVideoId = objNotification.video_uuid ?? ""
                        vcDetail.isFromPlaylist = false
                        vcDetail.hidesBottomBarWhenPushed = true
                        self.pushVCWithPresentAnimation(controller: vcDetail)
                    }
                }
            }
            
        }, FailureBlock: { (error) in
            self.tblNotificationList.finishInfiniteScroll()
            self.hideLoader()
        })
    }
}
