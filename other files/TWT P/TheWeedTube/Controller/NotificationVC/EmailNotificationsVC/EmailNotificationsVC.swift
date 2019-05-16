//
//  EmailNotificationsVC.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 12/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

struct General {
    static let Updates = "General updates, announcements, and videos"
    static let Channel = "My TheWeedTube channel: updates, announcements, and personalized tips"
    static let Activity = "Follow for our newsletter"
}

struct Activity {
    static let Videos = "Activity on my videos or channel"
    static let Comments = "Activity on my comments"
    static let RepliesComments = "Replies to my comments"
    static let OtherChannel = "Activity on other channels"
    static let Follows = "When someone follows me"
}

class EmailNotificationsVC: ParentVC {
    
    //MARK: - Outlets
    @IBOutlet weak var tblNotification: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var aryUserSettings = [Any]()    
    
    //MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
        callGetAccountSettingsAPI(isInMainThread: true)
    }
    
    //MARK: - Intial Methods
    func prepareViews() {
        tblNotification.register(UINib.init(nibName: "CellEmailNotification", bundle: nil), forCellReuseIdentifier: "CellEmailNotification")
        tblNotification.register(UINib.init(nibName: "CellComments", bundle: nil), forCellReuseIdentifier: "CellComments")
        self.tblNotification.isHidden = true
        self.lblTitle.isHidden = true
        tblNotification.tableFooterView = UIView()
    }
}


//MARK: - Tableview Datasource and Delegate Methods
extension EmailNotificationsVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryUserSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let objClassAccountSettings = aryUserSettings[indexPath.row] as? ClassAccountSettings{
            let cell = tblNotification.dequeueReusableCell(withIdentifier: "CellEmailNotification", for: indexPath) as! CellEmailNotification
            cell.textLabel?.backgroundColor = UIColor.clear
            
            let strName = objClassAccountSettings.name
            cell.lblName.text = strName
            cell.cntrlSwitch.tag = indexPath.row
            cell.cntrlSwitch.addTarget(self, action: #selector(actionSwitch(sender:)), for: .valueChanged)
            cell.cntrlSwitch.isOn = objClassAccountSettings.isEnable
            return cell
        }else{
            let strTitle = aryUserSettings[indexPath.row] as? String ?? ""
            let cell = tblNotification.dequeueReusableCell(withIdentifier: "CellComments", for: indexPath) as! CellComments
            cell.textLabel?.backgroundColor = UIColor.clear
            cell.lblTitle.text = strTitle
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 61
//    }
    
    
    //MARK: - Switch Event Method
    @objc func actionSwitch(sender: PVSwitch) {
        if let objClassAccountSettings = aryUserSettings[sender.tag] as? ClassAccountSettings{
            objClassAccountSettings.isEnable = !objClassAccountSettings.isEnable
            var arySelectedID = [String]()
            
            for value in aryUserSettings{
                if let objClassAccountSettings = value as? ClassAccountSettings,objClassAccountSettings.isEnable{
                    arySelectedID.append(objClassAccountSettings.id)
                }
            }
            //No value selected then pass 0 in array
            if arySelectedID.count == 0{
                arySelectedID.append("0")
            }
            
            callSetAccountSettingsAPI(isInMainThread: true, arrSelectedIds: arySelectedID,index:sender.tag)
        }
    }
}

extension EmailNotificationsVC{
    //MARK: - API Methods
    func callGetAccountSettingsAPI(isInMainThread:Bool)  {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: String] = [KEYS_API.platform : APIConstant.platform,
                                             KEYS_API.version : KEYS_API.app_version]
        
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: ModelAccountSettings.self,apiName:APIName.GetAccountSetting, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if isInMainThread{
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                //self.showToastMessage(title: (response.meta?.message)!)
                self.aryUserSettings = [ClassAccountSettings]()
                
                let aryGenrals = response.data?.gENERAL ?? []
                let aryActivity = response.data?.aCTIVITY ?? []
                
                for objGenrals in aryGenrals{
                    let objClassAccountSettings = ClassAccountSettings(objGENERAL: objGenrals)
                    self.aryUserSettings.append(objClassAccountSettings)
                }
                self.aryUserSettings.append("Comments & activity")
                for objGenrals in aryActivity{
                    let objClassAccountSettings = ClassAccountSettings(objGENERAL: objGenrals)
                    self.aryUserSettings.append(objClassAccountSettings)
                }
                self.tblNotification.isHidden = false
                self.lblTitle.isHidden = false
                self.tblNotification.reloadData()
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
    
    func callSetAccountSettingsAPI(isInMainThread:Bool,arrSelectedIds:[String],index:Int)  {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.account_setting_ids : arrSelectedIds,
                                          KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version]
        
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: ModelSetAccountSettings.self,apiName:APIName.SetAccountSetting, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if isInMainThread{
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if !self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                if let objClassAccountSettings = self.aryUserSettings[index] as? ClassAccountSettings{
                    objClassAccountSettings.isEnable = !objClassAccountSettings.isEnable
                }
            }
            self.alertOnTop(message: response.meta?.message, style: .success)
            self.tblNotification.reloadData()
        }, FailureBlock: { (error) in
            if let objClassAccountSettings = self.aryUserSettings[index] as? ClassAccountSettings{
                objClassAccountSettings.isEnable = !objClassAccountSettings.isEnable
                self.tblNotification.reloadData()
            }
            self.hideLoader()
        })
    }
}
