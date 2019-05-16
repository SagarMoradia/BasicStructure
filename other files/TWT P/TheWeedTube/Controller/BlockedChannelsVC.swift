//
//  BlockedChannelsVC.swift
//  TheWeedTube
//
//  Created by Hasya Panchasara on 01/05/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class BlockedChannelsVC: ParentVC, UITableViewDelegate, UITableViewDataSource {
    
   @IBOutlet weak var tblBlockedList: UITableView!
   @IBOutlet weak var lblNoData: darkGreyLabelCtrlModel!
   var totalRecords: Int = 0
   
   var arrUsers = [BlockedUserlistDataAry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.prepareViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
         self.prepareViews()
    }
    
    func prepareViews() {
        
        tblBlockedList.register(UINib.init(nibName: "CellBlockedUsers", bundle: nil), forCellReuseIdentifier: "ID_CellBlockedUsers")
        
        self.callAPIListOfBlockedUser()
        
        
        
    }
    
    func callAPIListOfBlockedUser()
    {
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.start : "",
                                          KEYS_API.length : "",
                                          KEYS_API.sort_param : "",
                                          KEYS_API.sort_type : "",
                                          KEYS_API.search_param : ""]
        
        
            self.showLoader()
        
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: BlockedUserListModel.self,apiName:APIName.BlockedUserListing, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            
            
            
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                self.totalRecords = response.data?.original?.recordsTotal ?? 0
                
                if self.totalRecords > 0{
                    
                    self.arrUsers = [BlockedUserlistDataAry]()
                    
                    self.arrUsers.append(contentsOf: (response.data?.original?.data)!)
                    
                    if self.arrUsers.count > 0{
                        self.tblBlockedList.isHidden = false
                        self.lblNoData.isHidden = true
                    }else{
                        self.tblBlockedList.isHidden = true
                        self.lblNoData.isHidden = false
                    }
                }
                else{
                    self.tblBlockedList.isHidden = true
                    self.lblNoData.isHidden = false
                }
                
                self.tblBlockedList.reloadData()
                
                 self.hideLoader()
            }
            
        }, FailureBlock: { (error) in
           
                self.hideLoader()
           
           
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return self.arrUsers.count
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblBlockedList.dequeueReusableCell(withIdentifier: "ID_CellBlockedUsers", for: indexPath) as! CellBlockedUsers
        cell.btnUnblock.tag = indexPath.row
        cell.btnUnblock.addTarget(self, action: #selector(actionUnblock(sender:)), for: .touchUpInside)
        cell.objModelUser = self.arrUsers[indexPath.row]
        
        return cell
    }
    
    @objc func actionUnblock(sender: UIButton) {
        
        let strUUID : String = self.arrUsers[sender.tag].uuid ?? ""
        
        print(strUUID)
        
        
        
        Alert.shared.showAlertWithHandler(title: App_Name, message: msg_UnblockUser, buttonsTitles: [Cons_Cancel, str_AlertTextUnblock], showAsActionSheet: false, handler: { (index) in
            switch(index){
            case 1:
                self.callBlockAPI(userId: strUUID)
            default:
                print("Cancel tapped")
            }
        })
        
        
    }
    
    func callBlockAPI(userId:String){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.blocker_id : userId,
                                          KEYS_API.block : "No"]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: BlockUserModel.self,apiName:APIName.BlockUser, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
               
                self.viewWillAppear(true)
                
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
    
}


