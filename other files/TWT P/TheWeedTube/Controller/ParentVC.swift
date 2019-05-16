//
//  ParentVC.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 04/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit
import SideMenu
import UIScrollView_InfiniteScroll
import ActionSheetPicker_3_0
import Firebase
import MoPub

typealias sharingBlock = (()->())?


//struct APPLICATION {
//    
//    @available(iOS 9.0, *)
//    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    
//    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
//    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom  == .phone
//    
//    static var APP_STATUS_BAR_COLOR = UIColor(red: CGFloat(27.0/255.0), green: CGFloat(32.0/255.0), blue: CGFloat(42.0/255.0), alpha: 1)
//    static var APP_NAVIGATION_BAR_COLOR = UIColor(red: CGFloat(41.0/255.0), green: CGFloat(48.0/255.0), blue: CGFloat(63.0/255.0), alpha: 1)
//    static let applicationName = App_Name
//    static let googleClientID = "1019988643660-gt0p5f235oi0qt244ebdplb7a68avn1t.apps.googleusercontent.com"
//}


class ParentVC: UIViewController, UISideMenuNavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    static var aryOwnerSideMenuData = NSMutableArray()
    var isLoadingData = false
    var navigationTitle = ""
    var webURL = ""
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var imgNavigationLeft: UIImageView!

    var adHomeTop : MPAdView!
    var adHomeBottom : MPAdView!
    var adSubscriptionList : MPAdView!
    var adCatVideoListTop : MPAdView!
    var adCatVideoListInside : MPAdView!
    var adSearchTop : MPAdView!
    var adSearchInside : MPAdView!
    var adVideoDetail300 : MPAdView!
    var adVideoDetailBeforeComment : MPAdView!
    
    @IBInspectable var isMenuGestureEnable : Bool = false{
        didSet {
            SideMenuManager.default.menuEnableSwipeGestures = isMenuGestureEnable
        }
    }
    
    //MARK:- UIViewController Methods
    override func viewDidLoad() {
        print("--------------------------------Class Name:-----------------------------------\n \(self)")
        super.viewDidLoad()
    
        //sam
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        //SMP: Change
        if self.navigationController?.viewControllers.count ?? 0 > 1{
            addBackButton()
        }else if isMenuGestureEnable{
//            if !(UIApplication.topViewController()?.isKind(of: SideDrawerVC.self))! {
                addSidemenuButtonToNavigationBar()
//            }
        }
    }

    //sam
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        SideMenuManager.default.menuEnableSwipeGestures = isMenuGestureEnable
        self.themeChange(forView: self.view)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
    @objc func redirectToHomeScreen() {

        let sideDrawer = MAIN_STORYBOARD_SIDE_DRAWER.instantiateViewController(withIdentifier: "SideDrawerMenu") as? UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = sideDrawer

        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuBlurEffectStyle = UIBlurEffect.Style.dark
        SideMenuManager.default.menuWidth = SCREEN_WIDTH * RATIO
        SideMenuManager.default.menuShadowOpacity = 0.6
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuAnimationFadeStrength = 0.0
        let objHome = MAKE_STORY_OBJ_TABBAR(Identifier: "Tabbar_Main")
        APPLICATION.appDelegate.window?.rootViewController = objHome
    }
    
    //MARK:- Navigation Helper Methods
    func removeRightBarItemWithTag(tag:Int) {
        let arrayRightButtons = self.navigationItem.rightBarButtonItems ?? []
        var aryNewRightItem = [UIBarButtonItem]()
        for rightItem in arrayRightButtons {
            if rightItem.tag != tag{
                aryNewRightItem.append(rightItem)
            }
        }
        self.navigationItem.rightBarButtonItems = aryNewRightItem
    }
    
    //MARK:- Push like Present
    func pushVCWithPresentAnimation(controller:UIViewController){
        let transition:CATransition = CATransition()
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    func popVCWithDismisAnimation(){
        let transition = CATransition()
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK:- Helper Methods
//    func enableAutoPlayFunctionality() {
//        
//        let autoPlaySwitch = DefaultValue.shared.getStringValue(key: KEYS_USERDEFAULTS.IS_AUTO_PLAY_ENABLE)
//        if autoPlaySwitch == ""{
//            if !DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_AGE_VERIFIED){
//                DefaultValue.shared.setStringValue(value: "true", key: KEYS_USERDEFAULTS.IS_AUTO_PLAY_ENABLE)
//            }
//        }
//    }
    
    func firstDateOfMonth() -> String {
        
        var strFromDate = String()
        
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        let startOfMonth = Calendar.current.date(from: comp)!
        strFromDate = dateFormatter.string(from: startOfMonth)
        
        return strFromDate
    }
    
    func addSidemenuButtonToNavigationBar(){
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0, bottom: 0, right: 0)
        backButton.setImage(UIImage(named: "Nav_Menu"), for: .normal)
        backButton.addTarget(self, action: #selector(btnMenuTap), for: .touchUpInside)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//        backButton.backgroundColor = UIColor.red
        var arrayLeftButtons = self.navigationItem.leftBarButtonItems ?? []
        arrayLeftButtons.insert(UIBarButtonItem(customView: backButton), at: 0)
        self.navigationItem.leftBarButtonItems = arrayLeftButtons

    }
    
    func HSReloadData(tableView:UITableView?){
        if (tableView != nil) {
            self.isLoadingData = true
            tableView!.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoadingData = false
            }
        }
    }
    
    func addBackButton(){
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0, bottom: 0, right: 0)

//        backButton.backgroundColor = UIColor.red
        backButton.setImage(UIImage(named: "Nav_back"), for: .normal)
        backButton.addTarget(self, action: #selector(btnBackTap), for: .touchUpInside)

        //SMP: Change
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        var arrayLeftButtons = self.navigationItem.leftBarButtonItems ?? []
        arrayLeftButtons.insert(UIBarButtonItem(customView: backButton), at: 0)
        self.navigationItem.leftBarButtonItems = arrayLeftButtons
    }
    
    func addShadowToView(view:UIView) {
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        view.layer.shadowRadius = 1
        view.layer.masksToBounds = false
    }
    
    func addShadowToButton(button: UIButton) {
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 1
        button.layer.masksToBounds = false
        button.layer.cornerRadius = button.frame.height / 2
    }
    
    func addRadius(button: UIButton) {
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
    }
    
    func addRound(control: UIControl) {
        control.layer.cornerRadius = control.frame.height/2
        control.layer.masksToBounds = true
    }
    
    @objc func toggleSideMenuBtn() {
        
    }
    
    @IBAction func PopViewController(){
        POP_VC()
    }
    
    @IBAction func btnBackTap(){
         POP_VC()
    }
    
    @IBAction func btnMenuTap(){
        
//        if GLOBAL.sharedInstance.isSideMenuOpened {
//            return
//        }
        
        print("Menu Tapped")
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }

    //MARK: - Theme change Method
    func themeChange(forView:UIView){
        
        let arrViews = self.view.allSubViewsOf()
        for subview in arrViews{
            GLOBAL.sharedInstance.themeChangeForView(subview: subview)
        }
    }
    
    //MARK: - AttributedString Method
    func setAttributedString(string: String,defaultfontName:String,defaultsize:CGFloat,changefontname:String,changesize:CGFloat,range:NSRange,changeColor:UIColor,changeColorRange:NSRange) -> NSMutableAttributedString {
        let myString : String = string
        var mutableString = NSMutableAttributedString()
        mutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedString.Key.font:UIFont(name: defaultfontName, size: defaultsize)!])
        mutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: changefontname, size: changesize)!, range: range)
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: changeColor, range: changeColorRange)
        return mutableString
    }
    
    func appendAttributedString(left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
    {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
    
    //MARK: - Dynamic width Method
    func setLabelWidth(label:UILabel){
        let expectedLabelSize : CGSize = label.intrinsicContentSize
        var newFrame: CGRect = label.frame
        newFrame.size.width = expectedLabelSize.width
        label.frame = newFrame
    }
    
    //MARK: - Label Height Method
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
   
     //MARK: - Delay Method
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
     //MARK: - Border Method
    func makeBorder(yourView:UIView,cornerRadius:CGFloat,borderWidth:CGFloat,borderColor:UIColor,borderColorAlpha:CGFloat) {
        yourView.layer.cornerRadius = cornerRadius
        yourView.layer.borderWidth = borderWidth
        yourView.layer.borderColor = borderColor.withAlphaComponent(borderColorAlpha).cgColor
        yourView.clipsToBounds = true
    }
    
    //MARK: - Dateformatter Method
    func sendDateforAPI(stringDate: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MMM-yyyy"
        //2018-07-16
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd" //16-jul-2018
        let date: Date? = dateFormatterGet.date(from: stringDate)
        print("-------DATE-----",dateFormatterPrint.string(from: date!))
        return dateFormatterPrint.string(from: date!);
    }
    
    func getFormattedDate(stringDate: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        //1996-01-01
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM/dd/yyyy" //01/01/1996
        let date: Date? = dateFormatterGet.date(from: stringDate)
        print("-------DATE-----",dateFormatterPrint.string(from: date!))
        return dateFormatterPrint.string(from: date!);
    }
    
    func getOnlyDateFrom(stringDate: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //2018-07-16 11:29:13
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
        dateFormatterPrint.amSymbol = "AM"
        dateFormatterPrint.pmSymbol = "PM"
        
        let date: Date? = dateFormatterGet.date(from: stringDate)
        
        return dateFormatterPrint.string(from: date!)
    }

    func getOnlyTimeFrom(stringDate: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //2018-07-16 11:29:13
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "hh:mm a"
        dateFormatterPrint.amSymbol = "AM"
        dateFormatterPrint.pmSymbol = "PM"
        
        let date: Date? = dateFormatterGet.date(from: stringDate)
        
        return dateFormatterPrint.string(from: date!)
    }

    func getDateFromString(strdate: String) -> Date {
        
        var selectedDate = Date()
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MMM-yyyy"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        selectedDate = dateFormatterGet.date(from: strdate)!
        
        return selectedDate
    }
    
    //MARK: - Email Validation
    func isValidEmail(_ testStr:String) -> Bool {
        debugPrint("validate string: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        if let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx) as NSPredicate? {
            return emailTest.evaluate(with: testStr)
        }
        return false
    }
}

//MARK: -
extension ParentVC : MPAdViewDelegate{
    
    //MARK: - Ad Methods
    //Home Top
    func loadMopubAdForHomeTop(inView: UIView){
        
        self.adHomeTop = MPAdView.init(adUnitId: MOPUP_AD.HOME_TOP, size: MOPUB_BANNER_SIZE)
        
        self.adHomeTop.delegate = self
        self.adHomeTop.frame = CGRect.init(x: (SCREEN_WIDTH - MOPUB_BANNER_SIZE.width) / 2, y: 0, width: MOPUB_BANNER_SIZE.width, height: MOPUB_BANNER_SIZE.height)
        self.adHomeTop.backgroundColor = .white
        inView.addSubview(self.adHomeTop)
        self.adHomeTop.loadAd()
    }
    
    //Home Bottom
    func loadMopubAdForHomeBottom(inView: UIView){
        
        self.adHomeBottom = MPAdView.init(adUnitId: MOPUP_AD.HOME_BOTTOM, size: MOPUB_BANNER_SIZE)
        
        self.adHomeBottom.delegate = self
        self.adHomeBottom.frame = CGRect.init(x: (SCREEN_WIDTH - MOPUB_BANNER_SIZE.width) / 2, y: 0, width: MOPUB_BANNER_SIZE.width, height: MOPUB_BANNER_SIZE.height)
        self.adHomeBottom.backgroundColor = .white
        inView.addSubview(self.adHomeBottom)
        self.adHomeBottom.loadAd()
    }
    
    //Category Top
    func loadMopubAdForCategoryVideoListTop(inView: UIView){
        
        self.adCatVideoListTop = MPAdView.init(adUnitId: MOPUP_AD.CATEGORY_TOP, size: MOPUB_BANNER_SIZE)
        
        self.adCatVideoListTop.delegate = self
        self.adCatVideoListTop.frame = CGRect.init(x: (SCREEN_WIDTH - MOPUB_BANNER_SIZE.width) / 2, y: 0, width: MOPUB_BANNER_SIZE.width, height: MOPUB_BANNER_SIZE.height)
        self.adCatVideoListTop.backgroundColor = .white
        inView.addSubview(self.adCatVideoListTop)
        self.adCatVideoListTop.loadAd()
    }
    
    //Category Inside
    func loadMopubAdForCategoryVideoListInside(inView: UIView){
        
        self.adCatVideoListInside = MPAdView.init(adUnitId: MOPUP_AD.CATEGORY_INSIDE, size: MOPUB_BANNER_SIZE)
        
        self.adCatVideoListInside.delegate = self
        self.adCatVideoListInside.frame = CGRect.init(x: (SCREEN_WIDTH - MOPUB_BANNER_SIZE.width) / 2, y: 0, width: MOPUB_BANNER_SIZE.width, height: MOPUB_BANNER_SIZE.height)
        self.adCatVideoListInside.backgroundColor = .white
        inView.addSubview(self.adCatVideoListInside)
        self.adCatVideoListInside.loadAd()
    }
    
    //Search Top
    func loadMopubAdForSearchScreenTop(inView: UIView){
        
        self.adSearchTop = MPAdView.init(adUnitId: MOPUP_AD.SEARCH_TOP, size: MOPUB_BANNER_SIZE)
        
        self.adSearchTop.delegate = self
        self.adSearchTop.frame = CGRect.init(x: (SCREEN_WIDTH - MOPUB_BANNER_SIZE.width) / 2, y: 0, width: MOPUB_BANNER_SIZE.width, height: MOPUB_BANNER_SIZE.height)
        self.adSearchTop.backgroundColor = .white
        inView.addSubview(self.adSearchTop)
        self.adSearchTop.loadAd()
    }
    
    //Search Inside
    func loadMopubAdForSearchScreenInside(inView: UIView){
        
        self.adSearchInside = MPAdView.init(adUnitId: MOPUP_AD.SEARCH_INSIDE, size: MOPUB_BANNER_SIZE)
        
        self.adSearchInside.delegate = self
        self.adSearchInside.frame = CGRect.init(x: (SCREEN_WIDTH - MOPUB_BANNER_SIZE.width) / 2, y: 0, width: MOPUB_BANNER_SIZE.width, height: MOPUB_BANNER_SIZE.height)
        self.adSearchInside.backgroundColor = .white
        inView.addSubview(self.adSearchInside)
        self.adSearchInside.loadAd()
    }
    
    //Video 300x300
    func loadMopubAdForVideoDetail_300(inView: UIView){
        
        self.adVideoDetail300 = MPAdView.init(adUnitId: MOPUP_AD.VID_DETAIL_AFTER_CHANNEL, size: MOPUB_BANNER_SIZE)
        
        self.adVideoDetail300.delegate = self
        self.adVideoDetail300.frame = CGRect.init(x: (SCREEN_WIDTH - MOPUB_BANNER_SIZE.width) / 2, y: 0, width: MOPUB_BANNER_SIZE.width, height: MOPUB_BANNER_SIZE.height)
        self.adVideoDetail300.backgroundColor = .white
        inView.addSubview(self.adVideoDetail300)
        self.adVideoDetail300.loadAd()
    }
    
    //Video before Comment
    func loadMopubAdForVideoDetailBeforeComment(inView: UIView){
        
        self.adVideoDetailBeforeComment = MPAdView.init(adUnitId: MOPUP_AD.VID_DETAIL_BEFORE_COMMENT, size: MOPUB_BANNER_SIZE)
        
        self.adVideoDetailBeforeComment.delegate = self
        self.adVideoDetailBeforeComment.frame = CGRect.init(x: (SCREEN_WIDTH - MOPUB_BANNER_SIZE.width) / 2, y: 0, width: MOPUB_BANNER_SIZE.width, height: MOPUB_BANNER_SIZE.height)
        self.adVideoDetailBeforeComment.backgroundColor = .white
        inView.addSubview(self.adVideoDetailBeforeComment)
        self.adVideoDetailBeforeComment.loadAd()
    }
    
    //Subscription Top
    func loadMopubAdForSubscriptionList(inView: UIView){
        
        self.adSubscriptionList = MPAdView.init(adUnitId: MOPUP_AD.SUBSCRIPTION_TOP, size: MOPUB_BANNER_SIZE)
        
        self.adSubscriptionList.delegate = self
        self.adSubscriptionList.frame = CGRect.init(x: (SCREEN_WIDTH - MOPUB_BANNER_SIZE.width) / 2, y: 0, width: MOPUB_BANNER_SIZE.width, height: MOPUB_BANNER_SIZE.height)
        self.adSubscriptionList.backgroundColor = .white
        inView.addSubview(self.adSubscriptionList)
        self.adSubscriptionList.loadAd()
    }
    
    //MARK: - MPAdViewDelegate Methods
    func adViewDidLoadAd(_ view: MPAdView!) {
        print("\n\n*** adViewDidLoadAd ***\n\n")
        /*
         let size: CGSize = view.adContentViewSize()
         let centeredX: CGFloat = (view.bounds.size.width - size.width) / 2
         let bottomAlignedY: CGFloat = view.bounds.size.height - size.height
         view.frame = CGRect(x: centeredX, y: bottomAlignedY, width: size.width, height: size.height)
         */
    }
    
    func adViewDidFail(toLoadAd view: MPAdView!) {
        print("\n\n*** adViewDidFail ***\n\n")
    }
    
    func willPresentModalView(forAd view: MPAdView!) {
    }
    
    func viewControllerForPresentingModalView() -> UIViewController! {
        print("\n\n*** viewControllerForPresentingModalView ***\n\n")
        return self
    }
    
    func didDismissModalView(forAd view: MPAdView!) {
    }
    
    func willLeaveApplication(fromAd view: MPAdView!) {
    }
}

//MARK: -
extension NSObject{
    func LogoutFromApplication(){
        
        Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Logout_message, buttonsTitles: [Cons_No, Cons_Yes], showAsActionSheet: false, handler: { (index) in
            switch(index){
                
            case 1:
                self.callLogoutAPI()
            default:
                print("Nothing")
            }
        })
        
    }
    
    func callLogoutAPI(){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        self.showLoader()
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform]
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_Logout.self,apiName:APIName.Logout, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
//                let instance = InstanceID.instanceID()
//                instance.deleteID { (error) in
//                    print(error.debugDescription)
//                }
                
                self.redirctToLoginScreen()
//                self.redirctToHomeScreenAfterLogout()  //Remove Skip
            }
            else{
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
    
    func redirctToHomeScreenAfterLogout(){
        DefaultValue.shared.removeAllValueFromUserDefault()
        let sideDrawer = UIStoryboard.init(name: ("SideDrawer"), bundle: nil).instantiateViewController(withIdentifier: "SideDrawerMenu") as? UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = sideDrawer
        
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuBlurEffectStyle = UIBlurEffect.Style.dark
        SideMenuManager.default.menuWidth = SCREEN_WIDTH * RATIO
        SideMenuManager.default.menuShadowOpacity = 0.6
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuAnimationFadeStrength = 0.0
        let objHome = UIStoryboard.init(name: ("Tabbar"), bundle: nil).instantiateViewController(withIdentifier: "Tabbar_Main")
        APPLICATION.appDelegate.window?.rootViewController = objHome
    }
    
    func redirctToLoginScreen(){
        DefaultValue.shared.removeAllValueFromUserDefault()
        let loginNavigation = UIStoryboard.init(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation") as! UINavigationController
        loginNavigation.navigationBar.isHidden = true
        APPLICATION.appDelegate.window?.rootViewController =  loginNavigation
        APPLICATION.appDelegate.window?.makeKeyAndVisible()
    }
    
    func suffixNumber(number:NSNumber) -> String {
        
        var num:Double = number.doubleValue
        let sign = ((num < 0) ? "-" : "" )
        
        num = fabs(num)
        
        if (num < 1000.0){
            return "\(sign)\(Int(num))"
        }
        
        let exp:Int = Int(log10(num) / 3.0 )
        
        let units:[String] = ["K","M","B","T","P","E"] // "G"
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10
        
        return "\(sign)\(Int(roundedNum))\(units[exp-1])"
    }
    
    func timeFormatted(totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        
        if(hours > 0){
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

//MARK: -
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}


//extension UIView {
//    @IBInspectable var ignoresThemeColors: Bool {
//        get {
//            if #available(iOS 11.0, *) {
//                return accessibilityIgnoresInvertColors
//            }
//            return false
//        }
//        set {
//            if #available(iOS 11.0, *) {
//                accessibilityIgnoresInvertColors = newValue
//            }
//        }
//    }
//}


/*
 
extension ParentVC{
    //MARK: - UISideMenuNavigationControllerDelegate Method
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
//        print("SideMenu Disappeared! (animated: \(animated))")
    }
}

 */
