//
//  EmailNotificationVC+Extension.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 12/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

extension EmailNotificationsVC{
    //MARK: - Tableview Datasource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return arrGeneralData.count
        }
        else if section == 1{
            return 1
        }
        if section == 2{
            return arrActivityData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tblNotification.dequeueReusableCell(withIdentifier: "CellEmailNotification", for: indexPath) as! CellEmailNotification
            cell.textLabel?.backgroundColor = UIColor.clear
            
            let strName = arrGeneralData[indexPath.row].name
            cell.lblName.text = strName
            cell.cntrlSwitch.tag = indexPath.row
            cell.cntrlSwitch.addTarget(self, action: #selector(actionSwitch(sender:)), for: .valueChanged)
            
            //check switch state
            let strRead = arrGeneralData[indexPath.row].read
            if strRead == "true"{
                if strName == General.Updates{
                    cell.cntrlSwitch.isOn = true
                }
                else if strName == General.Channel{
                    cell.cntrlSwitch.isOn = true
                }
                else if strName == General.Activity{
                    cell.cntrlSwitch.isOn = true
                }
                
            }else{
                if strName == General.Updates{
                    cell.cntrlSwitch.isOn = false
                }
                else if strName == General.Channel{
                    cell.cntrlSwitch.isOn = false
                }
                else if strName == General.Activity{
                    cell.cntrlSwitch.isOn = false
                }
            }
            
            return cell
        }
        else if indexPath.section == 1{
            let cell = tblNotification.dequeueReusableCell(withIdentifier: "CellComments", for: indexPath) as! CellComments
            cell.textLabel?.backgroundColor = UIColor.clear
            
            return cell
        }
        else if indexPath.section == 2{
            let cell = tblNotification.dequeueReusableCell(withIdentifier: "CellEmailNotification", for: indexPath) as! CellEmailNotification
            cell.textLabel?.backgroundColor = UIColor.clear
            
            let strName = arrActivityData[indexPath.row].name
            cell.lblName.text = strName
            cell.cntrlSwitch.tag = indexPath.row
            cell.cntrlSwitch.addTarget(self, action: #selector(actionSwitchComment(sender:)), for: .valueChanged)
            
            //check switch state
            let strRead = arrActivityData[indexPath.row].read
            if strRead == "true"{
                if strName == Activity.Videos{
                    cell.cntrlSwitch.isOn = true
                }
                else if strName == Activity.Comments{
                    cell.cntrlSwitch.isOn = true
                }
                else if strName == Activity.RepliesComments{
                    cell.cntrlSwitch.isOn = true
                }
                else if strName == Activity.OtherChannel{
                    cell.cntrlSwitch.isOn = true
                }
                else if strName == Activity.Follows{
                    cell.cntrlSwitch.isOn = true
                }
                
            }else{
                if strName == Activity.Videos{
                    cell.cntrlSwitch.isOn = false
                }
                else if strName == Activity.Comments{
                    cell.cntrlSwitch.isOn = false
                }
                else if strName == Activity.RepliesComments{
                    cell.cntrlSwitch.isOn = false
                }
                else if strName == Activity.OtherChannel{
                    cell.cntrlSwitch.isOn = false
                }
                else if strName == Activity.Follows{
                    cell.cntrlSwitch.isOn = false
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
    //MARK: - Switch Event Method
    @objc func actionSwitch(sender: PVSwitch) {
        print("---------------Tag of Sender--------------",sender.tag)
        if sender.isOn{
            print("Switch on")
            let intId = arrGeneralData[sender.tag].id
            if sender.tag == 0{
                arrSelectedIds.append(intId!)
            }
            else if sender.tag == 1{
                arrSelectedIds.append(intId!)
            }
            else if sender.tag == 2{
                arrSelectedIds.append(intId!)
            }

        }
        else{
            print("Switch off")
            let intId = arrGeneralData[sender.tag].id
            if sender.tag == 0{
               arrSelectedIds.append(intId!)
            }
            else if sender.tag == 1{
               arrSelectedIds.append(intId!)
            }
            else if sender.tag == 2{
              arrSelectedIds.append(intId!)
            }
        }
        callSetAccountSettingsAPI(isInMainThread: true)
    }
    
    
    @objc func actionSwitchComment(sender: PVSwitch) {
        print("---------------Tag of Sender--------------",sender.tag)
        if sender.isOn{
            print("Switch on")
            let intId = arrActivityData[sender.tag].id
            if sender.tag == 0{
                arrSelectedIds.append(intId!)
            }
            else if sender.tag == 1{
                arrSelectedIds.append(intId!)
            }
            else if sender.tag == 2{
                arrSelectedIds.append(intId!)
            }
            else if sender.tag == 3{
                arrSelectedIds.append(intId!)
            }
            else if sender.tag == 4{
                arrSelectedIds.append(intId!)
            }
        }
        else{
            print("Switch off")
            let intId = arrActivityData[sender.tag].id
            if sender.tag == 0{
                arrSelectedIds.append(intId!)
            }
            else if sender.tag == 1{
                arrSelectedIds.append(intId!)
            }
            else if sender.tag == 2{
                arrSelectedIds.append(intId!)
            }
            else if sender.tag == 3{
                arrSelectedIds.append(intId!)
            }
            else if sender.tag == 4{
                arrSelectedIds.append(intId!)
            }
        }
         callSetAccountSettingsAPI(isInMainThread: true)
    }
    
    
    
    //MARK: - Custom Methods
    func setUpSwitch(notificationName: inout Bool,userDefaultName : String,cell : CellEmailNotification) {
        //Image change logic
        if notificationName {
            notificationName = false
            DefaultValue.shared.setBoolValue(value: notificationName, key: userDefaultName)
            DispatchQueue.main.async {
                cell.imgViewSwitch.image = UIImage(named : "back_arrow") //off image
            }
        }else{
            notificationName = true
            DefaultValue.shared.setBoolValue(value: notificationName, key: userDefaultName)
            DispatchQueue.main.async {
                cell.imgViewSwitch.image = UIImage(named : "calender")//on image
            }
        }
    }
    
}

extension EmailNotificationsVC{
    
//    @objc func actionSwitch(sender: PVSwitch) {
//        let path = IndexPath(row: sender.tag, section: 0)
//        arrGeneralData[sender.tag].read = !arrGeneralData[sender.tag].read
//        arySocialAccount[sender.tag].is_expanded = !arySocialAccount[sender.tag].is_expanded
//
//    }
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
                self.arrGeneralData = [GENERAL]()
                self.arrActivityData = [ACTIVITY]()
                
                self.arrGeneralData.append(contentsOf: (response.data?.gENERAL)!)
                self.arrActivityData.append(contentsOf: (response.data?.aCTIVITY)!)
        
                //print("\n-------------------------General :-----------------------\n",self.arrGeneralData)
                //print("\n-------------------------Activity :-----------------------\n",self.arrActivityData)
                
                self.tblNotification.reloadData()
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
        
    }
    
    func callSetAccountSettingsAPI(isInMainThread:Bool)  {
        
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
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                self.showToastMessage(title: (response.meta?.message)!)
                
                self.callGetAccountSettingsAPI(isInMainThread: false)
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
        
    }
    
}
