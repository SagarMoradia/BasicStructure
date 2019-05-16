//
//  MoreVC.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 12/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class MoreVC: ParentVC,UITableViewDataSource,UITableViewDelegate{

    //MARK: - Outlets
    @IBOutlet weak var tblMore: UITableView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgvProfile: UIImageView!
    @IBOutlet weak var lblName: blackLabelCtrlModel!
    
    
    //MARK: - Properties
    var arrData = NSMutableArray()
    let dicNotification :[String:Any]    = [K_title : MORE.Notifications,
                                            K_img_name : "notifications"]
    let dicSettings :[String:Any]    = [K_title : MORE.Settings,
                                            K_img_name : "settings"]
    let dicHelp :[String:Any]    = [K_title : MORE.Help,
                                        K_img_name : "help"]
    let dicLogout :[String:Any]    = [K_title : MORE.Logout,
                                        K_img_name : "logout"]
    
    var arrLogout = NSMutableArray()
    
    var arrTheme = ["Dark Theme"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        prepareViews()
        
    }

    //MARK: - Intial Methods
    func prepareViews() {
        
        viewTop.layer.cornerRadius = viewTop.frame.width/2
        viewTop.layer.borderWidth = 1.0
        viewTop.layer.borderColor = UIColor(hex:SideMenuHexColor.TextColor).cgColor
        viewTop.layer.masksToBounds = true

        lblName.text = self.getUserDefault(KEYS_USERDEFAULTS.USER_FULLNAME) as? String
        let profileURL = self.getUserDefault(KEYS_USERDEFAULTS.USER_PHOTO) as? String
        if self.verifyUrl(urlString: profileURL){
            imgvProfile.frame = CGRect(x: 0.0, y: 0.0, width: viewTop.frame.width, height: viewTop.frame.height)
            loadImageWith(imgView: imgvProfile, url: profileURL)
            imgvProfile.contentMode = .scaleAspectFill
        }else{
            imgvProfile.frame = CGRect(x: 12.0, y: 12.0, width: viewTop.frame.width-24.0, height: viewTop.frame.height-24.0)
            imgvProfile.image = UIImage(named: Cons_Profile_Image_Name)
            imgvProfile.contentMode = .scaleAspectFit
        }
        
        //self.navigationItem.title = Cons_Settings
        tblMore.register(UINib.init(nibName: "CellMore", bundle: nil), forCellReuseIdentifier: "CellMore")
        tblMore.register(UINib.init(nibName: "CellTheme", bundle: nil), forCellReuseIdentifier: "CellTheme")
        tblMore.tableFooterView = UIView()

        arrData = NSMutableArray.init(array: [dicNotification, dicSettings, dicHelp])
        arrLogout = NSMutableArray.init(array: [dicLogout])
    }
   

}
