//
//  SideDrawerVC.swift
//  DELRentals
//
//  Created by Sagar Moradia on 15/10/18.
//  Copyright © 2018 Sweta Vani. All rights reserved.
//

import UIKit
import SideMenu

let sideMenuRowHeight = 47.0 * (UIScreen.main.bounds.size.height/568.0)

struct SideMenuHexColor {
    static let TextColor = "868686"
    static let Background = "005528"
    static let BackgroundDisable = "F8F8F8"
    static let TextDisable = "DEDEDE"
    static let BackgroundCircle = "F4F4F4"
}

// Storyboard Name
enum StoryboardName:String {
    case Main = "Main"
    case Main_R1 = "Main_R1"
    case Main_R2 = "Main_R2"
    case Tabbar = "Tabbar"
    case SideDrawer = "SideDrawer"
}

// Storyboard IDs
enum StoryboardIDSideMenu:String {
    case Category = "CategorylistVC"
    case UploadVideo = "UploadVideoStep1VC"
    //case FAQ = "PlaylistVC" //Temp
    case CMS = "CmsVC"
    case RateTheApp = "RateTheApp_Redirection"
    case LogOut = "LoginNavigation"
}

//URL
struct WebURL {
    let FAQ = GLOBAL.sharedInstance.Help //"https://google.com"
    let AboutUs = GLOBAL.sharedInstance.AboutUs //"https://google.com"
    let ContactUs = GLOBAL.sharedInstance.ContactUs //"https://google.com"
    let TermsOfService = GLOBAL.sharedInstance.TermsOfService //"https://google.com"
    let Privacy = GLOBAL.sharedInstance.PrivacyPolicy //"https://google.com"
    let Help = GLOBAL.sharedInstance.Help //"https://google.com"
}

//Navigation Title
struct WebViewTitle {
    static let FAQ = "FAQ"
    static let AboutUs = "About Us"
    static let ContactUs = "Contact Us"
    static let TermsOfService = "Terms of Service"
    static let Privacy = "Privacy Policy"
    static let Help = "Help"
}

//Side Menu Model class
struct MenuSection {
    let title:String?
    let menuItems:[MenuItem]
}

struct MenuItem {
    let title:String
    let image:UIImage?
    let stotyboardName:StoryboardName!
    let stotyboardID:StoryboardIDSideMenu!
    let isTabbarHidden:Bool!
    var webURL:String!
    var navigationTitle:String!
    
    init(title: String, image: UIImage, stotyboardName: StoryboardName,stotyboardID: StoryboardIDSideMenu,isTabbarHidden:Bool,webURL:String? = "",navigationTitle:String? = "") {
        self.title = title
        self.image = image
        self.stotyboardName = stotyboardName
        self.stotyboardID = stotyboardID
        self.isTabbarHidden = isTabbarHidden
        self.webURL = webURL
        self.navigationTitle = navigationTitle
    }
    
}

//Side Menu Titles
struct SideMenuConstant {
    static let Category = "Categories"//"Category"
    static let UploadVideo = "Upload Video"
    static let FAQ = "FAQ"
    static let AboutUs = "About Us"
    static let ContactUs = "Contact Us"
    static let RateTheApp = "Rate The App"
    static let TermsServices = "Terms of Service"//"Terms & Services"
    static let PrivacyPolicy = "Privacy Policy"
    static let LogOut = "Log Out"
    static let OtherLinks = "Other Links"
}


class SideDrawerVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var arySideMenuItems = [MenuSection]()
    
    //MARK: - Outlets Methods
    @IBOutlet weak var tblvSideDrawer: UITableView!
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var lblUserNameOrGuest: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgGuestProfile: UIImageView!
    @IBOutlet weak var viewProfileBorder: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var cntrlTap: UIControl!
    
    @IBOutlet weak var constainLoginWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.prepareViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setProfileImage()
    }
}

//MARK: UI Design
extension SideDrawerVC{
    
    fileprivate func prepareViews(){
        
        lblVersion.text = "Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "1.0")"
        let nibProfileName = UINib(nibName: "CellSideMenu", bundle: nil)
        tblvSideDrawer.register(nibProfileName, forCellReuseIdentifier: "ID_CellSideMenu")
        viewProfileBorder.layer.cornerRadius = viewProfileBorder.frame.width/2
        viewProfileBorder.layer.borderWidth = 1.0
        viewProfileBorder.layer.borderColor = UIColor(hex:SideMenuHexColor.TextColor).cgColor
        viewProfileBorder.layer.masksToBounds = true
        setUserOrGuestInfo()
        populateSideMenuData()
    }
    
    fileprivate func populateSideMenuData() {
        
        //Section : 1
        var aryItemsValue = [MenuItem]()
        let objCategory = MenuItem(title: SideMenuConstant.Category, image:#imageLiteral(resourceName: "Category"), stotyboardName: .Main_R2, stotyboardID: .Category, isTabbarHidden: true,webURL:"",navigationTitle:"https://google.com")
        let objUploadVideo = MenuItem(title: SideMenuConstant.UploadVideo, image:#imageLiteral(resourceName: "Upload"), stotyboardName: .Main_R1, stotyboardID: .UploadVideo, isTabbarHidden: true)
        aryItemsValue.append(objCategory)
        aryItemsValue.append(objUploadVideo)
        
        let objMenuSection1 = MenuSection(title: "", menuItems: aryItemsValue)
        arySideMenuItems.append(objMenuSection1)
        aryItemsValue.removeAll()
        
        //Section : 2
        let objFAQ = MenuItem(title: SideMenuConstant.FAQ, image:#imageLiteral(resourceName: "Faq"), stotyboardName: .Main, stotyboardID: .CMS, isTabbarHidden: true,webURL:WebURL().FAQ,navigationTitle:WebViewTitle.FAQ)
        let objAboutUs = MenuItem(title: SideMenuConstant.AboutUs, image:#imageLiteral(resourceName: "AboutUs"), stotyboardName: .Main, stotyboardID: .CMS, isTabbarHidden: true,webURL:WebURL().AboutUs,navigationTitle:WebViewTitle.AboutUs)
        let objContactUs = MenuItem(title: SideMenuConstant.ContactUs, image:#imageLiteral(resourceName: "Contact"), stotyboardName: .Main, stotyboardID: .CMS, isTabbarHidden: true,webURL:WebURL().ContactUs,navigationTitle:WebViewTitle.ContactUs)
        let objRateApp = MenuItem(title: SideMenuConstant.RateTheApp, image:#imageLiteral(resourceName: "Rate"), stotyboardName: .Main, stotyboardID: .RateTheApp, isTabbarHidden: true)
        let objTermAndService = MenuItem(title: SideMenuConstant.TermsServices, image:#imageLiteral(resourceName: "Termsandservices"), stotyboardName: .Main, stotyboardID:.CMS, isTabbarHidden: true,webURL:WebURL().TermsOfService,navigationTitle:WebViewTitle.TermsOfService)
        let objPrivacy = MenuItem(title: SideMenuConstant.PrivacyPolicy, image:#imageLiteral(resourceName: "Privacypolicy"), stotyboardName: .Main, stotyboardID:.CMS, isTabbarHidden: true,webURL:WebURL().Privacy,navigationTitle:WebViewTitle.Privacy)
        let objLogout = MenuItem(title: SideMenuConstant.LogOut, image:#imageLiteral(resourceName: "Logout"), stotyboardName: .Main, stotyboardID: .LogOut, isTabbarHidden: true)
        
        aryItemsValue.append(objFAQ)
        aryItemsValue.append(objAboutUs)
        aryItemsValue.append(objContactUs)
        aryItemsValue.append(objRateApp)
        aryItemsValue.append(objTermAndService)
        aryItemsValue.append(objPrivacy)
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) != nil{
            aryItemsValue.append(objLogout)
        }
        
        let objMenuSection2 = MenuSection(title: SideMenuConstant.OtherLinks, menuItems: aryItemsValue)
        arySideMenuItems.append(objMenuSection2)
        aryItemsValue.removeAll()
    }
    
    fileprivate func setUserOrGuestInfo(){
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            lblUserNameOrGuest.text = "Guest User"
            constainLoginWidth.constant = 70.0
            imgGuestProfile.isHidden = false
            imgProfile.isHidden = true
            cntrlTap.addTarget(self, action: #selector(navigateToLoginScreen), for: UIControl.Event.touchUpInside)
        }else{
            lblUserNameOrGuest.text = self.getUserDefault(KEYS_USERDEFAULTS.USER_FULLNAME) as? String
            constainLoginWidth.constant = 0
            cntrlTap.addTarget(self, action: #selector(cntrlUserProfileTap), for: UIControl.Event.touchUpInside)
        }
        //setProfileImage()
    }
    
    fileprivate func setProfileImage(){
        
        if self.getUserDefault(KEYS_USERDEFAULTS.USER_PHOTO) == nil{
            imgGuestProfile.isHidden = false
            imgProfile.isHidden = true
        }else if let profileURL = self.getUserDefault(KEYS_USERDEFAULTS.USER_PHOTO) as? String,profileURL.count > 0{
            imgGuestProfile.isHidden = true
            imgProfile.isHidden = false
            loadImageWith(imgView: imgProfile, url: profileURL)
        }else{
            imgGuestProfile.isHidden = false
            imgProfile.isHidden = true
        }
    }
    
}


//MARK: Side menu delegates
extension SideDrawerVC{
    
    //MARK:- UITableViewDataSource and UITableViewDelegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return arySideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arySideMenuItems[section].menuItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arySideMenuItems[section].title
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.font = fontType.InterUI_Regular_12
        header.textLabel?.textColor = UIColor(hex: SideMenuHexColor.TextColor)
        header.backgroundView?.backgroundColor = UIColor.white
        header.textLabel?.textAlignment = NSTextAlignment.left
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sideMenuRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID_CellSideMenu", for: indexPath) as! CellSideMenu
        cell.objMenuItem = arySideMenuItems[indexPath.section].menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            
            guard let navigationController = UIApplication.topNavigationController() else{
                return
            }
            
            let menuItem = self.arySideMenuItems[indexPath.section].menuItems[indexPath.row]
            
            let storyBoardName = menuItem.stotyboardName
            let storyBoardID = menuItem.stotyboardID
            let isTabbarHidden = menuItem.isTabbarHidden!
            
            if storyBoardID?.rawValue == "LoginNavigation"{
                self.LogoutFromApplication()
            }
            else if storyBoardID?.rawValue == "UploadVideoStep1VC"{
                /* if user could not login then can't upload video show pop up for login*/
                let isGuestUser = self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) != nil ? false : true
                
                if !isGuestUser{
                    self.alertForUploadVideo()
                }else{
                   self.alerForLogin()
                }
                
                
            }
            else if storyBoardID!.rawValue.contains("RateTheApp_Redirection"){
                //Alert.shared.showAlert(title: App_Name, message: "Under Progress")
                
                guard
                    let url = URL(string: Cons_App_Rate_This_App)
                    else { return }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            else if !storyBoardID!.rawValue.contains("2"){
                let viewController = self.MAKE_STORY_OBJ(storyboardName:storyBoardName!, Identifier: storyBoardID!.rawValue) as! ParentVC
                viewController.navigationTitle = menuItem.navigationTitle
                viewController.webURL = menuItem.webURL
                viewController.hidesBottomBarWhenPushed = isTabbarHidden
                var aryViewController = navigationController.viewControllers
                aryViewController.append(viewController)
                navigationController.setViewControllers(aryViewController, animated: false)
            }
            self.dismiss(animated: true) {}
        }
    }
   // MARK:- Helper method for if user could not login then can't upload video show pop up for login
    func alerForLogin()  {
        Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_upload_video, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
            switch(index){
            case 1:
                self.redirctToLoginScreen()
            default:
                // self.redirectToHomeScreen()
                print("Cancel tapped")
            }
        })
    }
    
    func alertForUploadVideo(){
        
        Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Upload_Redirection_message, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
            switch(index){
                
            case 1:
                print("Redirect")
                self.redirectToUploadScreen()
            default:
                print("Nothing")
            }
        })
    }
    
    func redirectToUploadScreen(){
        guard let navigationController = UIApplication.topNavigationController() else{
            return
        }
        
        let viewController = self.MAKE_STORY_OBJ(storyboardName:StoryboardName(rawValue: "Main_R1")!, Identifier: "UploadVideoStep1VC") as! ParentVC
        viewController.hidesBottomBarWhenPushed = true
        var aryViewController = navigationController.viewControllers
        aryViewController.append(viewController)
        navigationController.setViewControllers(aryViewController, animated: true)
    }
}

//MARK: Tap events
extension SideDrawerVC{
    @IBAction func navigateToLoginScreen(){
        dismiss(animated: true) {
            self.redirctToLoginScreen()            
        }
    }
    
    @IBAction func cntrlUserProfileTap(){
        
        DispatchQueue.main.async {
            if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) != nil{
//                    let viewController = self.MAKE_STORY_OBJ_MAIN(Identifier: "ProfileMainVC")
                let viewController = self.MAKE_STORY_OBJ_R1(Identifier: "MoreVC")
                    viewController.hidesBottomBarWhenPushed = true
                    
                    guard let navigationController = UIApplication.topNavigationController() else{
                        return
                    }
                    var aryViewController = navigationController.viewControllers
                    aryViewController.append(viewController)
                    navigationController.setViewControllers(aryViewController, animated: false)
                self.dismiss(animated: true) {}
            }
        }
    }
}
