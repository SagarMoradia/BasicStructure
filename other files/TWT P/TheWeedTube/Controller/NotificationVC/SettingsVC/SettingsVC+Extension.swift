//
//  SettingsVC+Extension.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 11/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import Foundation

extension SettingsVC{
    //MARK: - Tableview Datasource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSettings.dequeueReusableCell(withIdentifier: "CellSettings", for: indexPath) as! CellSettings
        cell.textLabel?.backgroundColor = UIColor.clear
        
        cell.lblName.text = arrSettings[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 41
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.PUSH_STORY_R1(Identifier: STORYBOARD_IDENTIFIER.ChangePasswordVC)
        }
        else if indexPath.row == 1{
            self.PUSH_STORY_R1(Identifier: STORYBOARD_IDENTIFIER.EmailNotificationsVC)
        }
        else if indexPath.row == 2{
            self.PUSH_STORY_R1(Identifier: STORYBOARD_IDENTIFIER.BlockedChannelsVC)
        }
    }
}
