//
//  MyStashVC.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 14/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class MyStashVC: ParentVC {

    //MARK: - Outlets
    @IBOutlet weak var tblStash: UITableView!
    @IBOutlet weak var lblNoData: darkGreyLabelCtrlModel!
    
    //MARK: - Properties
    var arrStash    = [statshData]()
    var currentPageOffset: Int = 0
    var totalRecords: Int = 0
    
  
    //MARK:- UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
        self.setupPagination()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblStash.setContentOffset(.zero, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_NonLogin_My_Stash, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.redirctToLoginScreen()
                default:
                    self.redirectToHomeScreen()
                    print("Cancel tapped")
                }
            })
        }else{
            arrStash    = [statshData]()
            currentPageOffset = 0
            totalRecords = 0
            callMyStashAPI(inMainthread: true)
        }
    }
    
    //MARK:- Intial Methods
    fileprivate func prepareViews() {
        tblStash.register(UINib.init(nibName: "CellHome", bundle: nil), forCellReuseIdentifier: "ID_CellHome")
        tblStash.tableFooterView = UIView()
    }
    
    fileprivate func setupPagination() {
        // Add infinite scroll handler
        tblStash.addInfiniteScroll { [weak self] (tableView) -> Void in
            
            guard let tempSelf = self else{
                return
            }
            
            tempSelf.callMyStashAPI(inMainthread: false)
        }
        
        tblStash.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.totalRecords > self.arrStash.count
        }
    }
}

//MARK: - Button Event Methods
extension MyStashVC{
    @objc func actionVideoDetail(sender: UIButton){
        let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
        vcDetail.strSelectedVideoId = arrStash[sender.tag].uuid ?? ""
        vcDetail.isFromPlaylist = false
//        self.navigationController?.present(vcDetail, animated: true, completion: nil)
        vcDetail.hidesBottomBarWhenPushed = true
        self.pushVCWithPresentAnimation(controller: vcDetail)
    }
}

//MARK: - Tableview Datasource and Delegate Methods
extension MyStashVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrStash.count > 0{
            return arrStash.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrStash.count > 0{
            let cell = tblStash.dequeueReusableCell(withIdentifier: "ID_CellHome", for: indexPath) as! CellHome
            cell.textLabel?.backgroundColor = UIColor.clear
            
            cell.btnVideoDetail.tag = indexPath.row
            cell.btnVideoDetail.addTarget(self, action: #selector(actionVideoDetail(sender:)), for: UIControl.Event.touchUpInside)
            cell.btnVideoName.tag = indexPath.row
            cell.btnVideoName.addTarget(self, action: #selector(actionVideoDetail(sender:)), for: UIControl.Event.touchUpInside)
            cell.objModelStash = arrStash[indexPath.row]
            cell.strSelectedVideoId = arrStash[indexPath.row].uuid ?? ""
            cell.strAddToStashType = AddToStash_TYPE.MyStash
            
            cell.strUserID = arrStash[indexPath.row].visitors_uuid ?? ""
            
            //Callback
            cell.handler = indexHandlerBlock({(index) in
                if index == 0{ //0 => Remove From My Stash tap
                    //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                    print("Remove from stash api call in Cell")
                    self.callDeleteVideoFromMyStashAPI(strVideoID: self.arrStash[indexPath.row].uuid ?? "", isInMainThread: true) { (status, message) in
                        if(status){
                            self.alertOnTop(message: message, style: .success)
                            self.arrStash.remove(at: indexPath.row)
                            self.tblStash.reloadData()
                        }else{
                            self.alertOnTop(message: message, style: .danger)
                        }
                    }
                    
                }else if index == 1{ //1 => Add To Playlist tap
                    //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                }else{
                    //Share
                }
            })
            
            
            return cell
        }
        else{
            return UITableViewCell()
        }
        
        
    }
}

//MARK: - API Methods
extension MyStashVC{
    func callMyStashAPI(inMainthread: Bool) {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.sort_param : "", //watch_added
                                          KEYS_API.sort_type : "", //desc
                                          KEYS_API.length : PAGE_LIMIT,
                                          KEYS_API.start : String(currentPageOffset),
                                          KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: ModelMyStash.self,apiName:APIName.MyStash, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblStash.finishInfiniteScroll()
            
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                self.totalRecords = response.data?.original?.recordsTotal ?? 0
                
                if self.totalRecords > 0{
                    
                    if self.currentPageOffset == 0{
                        self.arrStash = [statshData]()
                    }
                    
                    self.arrStash.append(contentsOf: (response.data?.original?.data)!)
                    
                    self.currentPageOffset = self.arrStash.count
                    
                    if self.arrStash.count > 0{
                        self.tblStash.isHidden = false
                        self.lblNoData.isHidden = true
                    }else{
                        self.tblStash.isHidden = true
                        self.lblNoData.isHidden = false
                    }
                }else{
                    self.tblStash.isHidden = true
                    self.lblNoData.isHidden = false
                }
                
                self.tblStash.reloadData()
            }
            
        }, FailureBlock: { (error) in
            if inMainthread {
                self.hideLoader()
            }
            self.tblStash.finishInfiniteScroll()
        })
    }
    
    func callDeleteVideoFromMyStashAPI(strVideoID : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version]
        if isInMainThread{
            self.showLoader()
        }
        
        let strApiName = APIName.DeleteFromMyStash + strVideoID
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: DeleteVideoModel.self,apiName:strApiName, requestType: .delete, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if isInMainThread{
                self.hideLoader()
            }
            
            let statusCode  = response.meta?.status_code ?? 0
            
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
