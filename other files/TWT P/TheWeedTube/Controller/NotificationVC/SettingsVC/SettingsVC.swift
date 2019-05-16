//
//  SettingsVC.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 11/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class SettingsVC: ParentVC,UITableViewDataSource,UITableViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var tblSettings: UITableView!

    //MARK: - Properties
    var arrSettings = ["Change Password","Push Notifications","Blocked Channels"]
    
    //MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
    }
    
    //MARK: - Intial Methods
    func prepareViews() {
       // self.navigationController?.isNavigationBarHidden = false
        //self.navigationItem.title = Cons_Settings
        tblSettings.register(UINib.init(nibName: "CellSettings", bundle: nil), forCellReuseIdentifier: "CellSettings")
        tblSettings.tableFooterView = UIView()
    }
  
}
