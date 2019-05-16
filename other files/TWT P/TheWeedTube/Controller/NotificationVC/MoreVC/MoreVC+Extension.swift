//
//  MoreVC+Extension.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 13/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

extension MoreVC{
    //MARK: - Tableview Datasource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 //3 //need to add for theme changes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return arrData.count
        }
        else if section == 1{
            return arrLogout.count //return arrTheme.count //need to add for theme changes
        }
//        if section == 2{ //need to add for theme changes
//            return arrLogout.count
//        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tblMore.dequeueReusableCell(withIdentifier: "CellMore", for: indexPath) as! CellMore
            cell.textLabel?.backgroundColor = UIColor.clear
            
            let data = arrData[indexPath.row] as! NSDictionary
            
            let title = data.object(forKey: K_title) as! String
            cell.lblName.text = title
            
            let img_name = data.object(forKey: K_img_name) as! String
            cell.imgView.image = UIImage(named: img_name)
            
            if indexPath.row == 0{
                cell.viewBadge.isHidden = true
            }else{
                cell.viewBadge.isHidden = true
            }
            return cell
        }
//        else if indexPath.section == 1{ //need to add for theme changes
//            let cell = tblMore.dequeueReusableCell(withIdentifier: "CellTheme", for: indexPath) as! CellTheme
//            cell.textLabel?.backgroundColor = UIColor.clear
//
//            cell.lblName.text = arrTheme[indexPath.row]
//            cell.cntrlSwitch.tag = indexPath.row
//            cell.cntrlSwitch.addTarget(self, action: #selector(actionSwitch(sender:)), for: .valueChanged)
//
//            return cell
//        }
        else if indexPath.section == 1{ //2 //need to add for theme changes
            let cell = tblMore.dequeueReusableCell(withIdentifier: "CellMore", for: indexPath) as! CellMore
            cell.textLabel?.backgroundColor = UIColor.clear
            
            let data = arrLogout[indexPath.row] as! NSDictionary
            
            let title = data.object(forKey: K_title) as! String
            cell.lblName.text = title
            
            let img_name = data.object(forKey: K_img_name) as! String
            cell.imgView.image = UIImage(named: img_name)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let data = arrData[indexPath.row] as! NSDictionary
            let title = data.object(forKey: K_title) as! String
            if title == MORE.Notifications{
                //Redirect to Notification
                //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                self.PUSH_STORY_TABBAR(Identifier: STORYBOARD_IDENTIFIER.NotificationVC)
            }
            else if title == MORE.Settings{
                //Redirect to Settings
                self.PUSH_STORY_R1(Identifier: STORYBOARD_IDENTIFIER.SettingsVC)
            }
            else if title == MORE.Help{
                //Redirect to help CMS page
                let objHelp = self.MAKE_STORY_OBJ_MAIN(Identifier: STORYBOARD_IDENTIFIER.CmsVC) as! CmsVC
                objHelp.navigationTitle = WebViewTitle.Help
                objHelp.webURL = WebURL().Help
                self.navigationController?.pushViewController(objHelp, animated: true)
            }
        }
        else if indexPath.section == 1{
            ////Theme
            //Logout
            self.LogoutFromApplication()
        }
//        else if indexPath.section == 2{ //need to add for theme changes
//            //Logout
//            self.LogoutFromApplication()
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        footerView.backgroundColor = UIColor.seperator_color
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    //MARK: - Switch Event Method
    @objc func actionSwitch(sender: PVSwitch) {
        print("---------------Tag of Sender--------------",sender.tag)
        if sender.isOn{
            print("Switch Dark Theme on")
            print("Dark Theme")
//            GLOBAL.sharedInstance.strSelectedThemeID = "2"
//            GLOBAL.sharedInstance.strSelectedThemeName = "Dark"
//            self.themeChange(forView: self.view)
        }
        else{
            print("Switch Dark Theme off")
            print("Light Theme")
//            GLOBAL.sharedInstance.strSelectedThemeID = "1"
//            GLOBAL.sharedInstance.strSelectedThemeName = "Light"
//            self.themeChange(forView: self.view)
        }
    }
    
    @IBAction func actionProfileTap(sender: UIButton) {
        let profileVC = self.MAKE_STORY_OBJ_MAIN(Identifier: "ProfileMainVC") as! ProfileMainVC
        profileVC.isForOwnProfile = true
        let topNavigationVC = UIApplication.topViewController()
        topNavigationVC?.navigationController?.pushViewController(profileVC, animated: true)
        //self.PUSH_STORY_MAIN(Identifier: STORYBOARD_IDENTIFIER.ProfileMainVC)
    }
}
