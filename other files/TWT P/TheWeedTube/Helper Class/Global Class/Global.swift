//
//  Global.swift
//  Capchur
//
//  Created by Hitesh Surani on 18/07/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import Foundation
import UIKit

typealias indexHandlerBlock = (( _ index:Int)->())?

class GLOBAL: NSObject {
    
    static let sharedInstance = GLOBAL()
    
    //For Theme Change
    var arrThemes = [Themes]()
    var strSelectedThemeID   = String()
    var strSelectedThemeName = String()
    
    //CMS Pages
    var TermsOfService = String()
    var PrivacyPolicy  = String()
    var AboutUs        = String()
    var ContactUs      = String()
    var Help           = String()
    var UserAgreement  = String()
    var EulaTerms      = String()
    
    //Notifications
    var isFromNotification = Bool()
    var Notification_uuid  = String()
    var Notification_type  = String()
    var Notification_count = String()
    var N_ID               = String()
    
    //Login
//    var isAgeVerified = Bool()
    var isAgreement = Bool()
    var isNewsletter = Bool()
    var isAutoPlay = true
    
    
    //Email Notification
    var isFromGlobalUpdates = Bool()
    var isFromWeedTubeUpdates = Bool()
    var isFromNewsLetter = Bool()
    var isFromActivityOnVideo = Bool()
    var isFromActivityOnComments = Bool()
    var isFromRepliesToComments = Bool()
    var isFromActivityOnOther = Bool()
    var isFromSomeoneFollows = Bool()
    
    //Upload Video
    var uploadProgress = Double()
    var isAdTapped = Bool()
    
    //ReportCategory
    var arrayReportCategoryData = [ReportCategoryData]()
    var arrayPlaylistData = [PlaylistData]()
    
    var selectedCatIDsToUpload  = String()
    var selectedCatNamesToUpload  = String()
    var arrCategory = NSMutableArray()
    
    private override init() {
        
    }
    
    //MARK:- AWS
    func getAwsPathForImage(storyID:String,fileExtension:String) -> String{
        
        /*
         
         bucket name: weedtube
         folder1: uuid
         folder2: storyuuid
         
         key = (uuid+timestamp) MD5
         
         IMG_key.jpg
         350xheight_IMG_key.jpg
         VID_key.mp4;
         
         */
        
        //let userInfo = DefaultValue.shared.getUserInfo() as! userData
        let userUuid = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID) as! String
        let timeStamp = String(Date().ticks)
        let key = "\(userUuid)\(timeStamp)"
        let encryptedText = self.md5(key)
        //let name = "\(storyID)/" + "IMG_\(encryptedText)." + fileExtension
        let name = "uploads/video_thumbs/" + "IMG_\(encryptedText)." + fileExtension
        
        return name
    }
    
    func getAwsPathForVid(storyID:String,fileExtension:String) -> String{
        
        
        //let userInfo = DefaultValue.shared.getUserInfo() as! userData
        let userUuid = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID) as! String
        let timeStamp = String(Date().ticks)
        //let key = "\(userInfo.user_detail!.uuid ?? "")\(timeStamp)"
        let key = "\(userUuid)\(timeStamp)"
        let encryptedText = self.md5(key)
        //let name = "\(userInfo.user_detail!.uuid!)/\(storyID)/" + "VID_\(encryptedText)." + fileExtension
        //let name = "\(storyID)/" + "VID_\(encryptedText)." + fileExtension
        let name = "uploads/videos/" + "VID_\(encryptedText)." + fileExtension
        
        return name
    }
    
    func getThumbImagePathFrom(storyID:String,orignalImagePath:String) -> String{
        
        //let userInfo = DefaultValue.shared.getUserInfo() as! userData
        //let userUuid = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID) as! String
        
        //        if orignalImagePath.contains("VID_"){
        //            return "\(userInfo.user_detail!.uuid!)/\(storyID)/THUMB_\(String(describing: orignalImagePath.components(separatedBy:"/").last!)).jpeg"
        //
        //        }else{
        return "\(storyID)/THUMB_\(orignalImagePath.components(separatedBy:"/").last?.components(separatedBy: ".").first ?? "")"
        //        }
    }
    
    func md5(_ string: String) -> String {
        
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        
        return hexString
    }
    
    //MARK:- Logout
    func logOutUserFromApp(){
        
        DefaultValue.shared.removeAllValueFromUserDefault()
        let loginNavigation = UIStoryboard.init(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation") as! UINavigationController
        loginNavigation.navigationBar.isHidden = true
        APPLICATION.appDelegate.window?.rootViewController =  loginNavigation
        APPLICATION.appDelegate.window?.makeKeyAndVisible()
        
//        clearLoginDetails()
//        
//        let topVC = UIApplication.topViewController()
//        let objOnBoardingVC = topVC?.MAKE_STORY_OBJ_R1(Identifier: "id_OnBoardingVC") as! OnBoardingVC
//        let objNav = UINavigationController(rootViewController: objOnBoardingVC)
//        UIApplication.shared.keyWindow?.rootViewController = objNav
    }
    
    //MARK:- Font Method
    func setLabelFontforXFamily(fontName : String , fontSize : CGFloat,label : UILabel) {
        if Device.IS_IPHONE_XS_MAX{
            label.font = UIFont.init(name: fontName, size: fontSize)
        }
    }
    
    //| GlobalStruct.Device.IS_IPHONE_X
    func setButtonFontforXFamily(fontName : String , fontSize : CGFloat,button : UIButton) {
        if Device.IS_IPHONE_XS_MAX {
            button.titleLabel?.font = UIFont.init(name: fontName, size: fontSize)
        }
    }
    
    func setTextfieldFontforXFamily(fontName : String , fontSize : CGFloat,textfield : UITextField) {
        if Device.IS_IPHONE_XS_MAX{
            textfield.font = UIFont.init(name: fontName, size: fontSize)
        }
    }
    
    //MARK: - File size Method
    func fileSize(fileSize: Float) -> String? {
        
        // bytes
        if fileSize < 1023.0 {
            return String(format: "%lu bytes", CUnsignedLong(fileSize))
        }
        // KB
        var floatSize = Float(fileSize / 1024.0)
        if floatSize < 1023.0 {
            return String(format: "%.2f KB", floatSize)
        }
        // MB
        floatSize = floatSize / 1024.0
        if floatSize < 1023.0 {
            return String(format: "%.2f MB", floatSize)
        }
        // GB
        floatSize = floatSize / 1024.0
        return String(format: "%.2f GB", floatSize)
    }
    
//    func resizeImage(image: UIImage) -> UIImage {
//        var actualHeight: Float = Float(image.size.height)
//        var actualWidth: Float = Float(image.size.width)
//        let maxHeight: Float = 300.0
//        let maxWidth: Float = 400.0
//        var imgRatio: Float = actualWidth / actualHeight
//        let maxRatio: Float = maxWidth / maxHeight
//        let compressionQuality: Float = 0.5
//        //50 percent compression
//
//        if actualHeight > maxHeight || actualWidth > maxWidth {
//            if imgRatio < maxRatio {
//                //adjust width according to maxHeight
//                imgRatio = maxHeight / actualHeight
//                actualWidth = imgRatio * actualWidth
//                actualHeight = maxHeight
//            }
//            else if imgRatio > maxRatio {
//                //adjust height according to maxWidth
//                imgRatio = maxWidth / actualWidth
//                actualHeight = imgRatio * actualHeight
//                actualWidth = maxWidth
//            }
//            else {
//                actualHeight = maxHeight
//                actualWidth = maxWidth
//            }
//        }
//
//        let rect = CGRect.init(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
//        UIGraphicsBeginImageContext(rect.size)
//        image.draw(in: rect)
//        let img = UIGraphicsGetImageFromCurrentImageContext()
//        let imageData = UIImageJPEGRepresentation(img!,CGFloat(compressionQuality))
//
//        UIGraphicsEndImageContext()
//        return UIImage(data: imageData!)!
//    }
    
    
  
//    func md5(_ string: String) -> String {
//
//        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
//        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
//        CC_MD5_Init(context)
//        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
//        CC_MD5_Final(&digest, context)
//        context.deallocate(capacity: 1)
//        var hexString = ""
//        for byte in digest {
//            hexString += String(format:"%02x", byte)
//        }
//
//        return hexString
//    }
   
    func getReminderDateForLocalNotification() -> Date{
        
        let calendar = Calendar.current
        var dateComponent = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        let strTime = "19:30"
//        if DefaultValue.shared.getStringValue(key: USERDEFAULTS_KEYS.trigerTime).count > 2{
//            strTime = DefaultValue.shared.getStringValue(key: USERDEFAULTS_KEYS.trigerTime)
//        }
        
        let aryAllComponent = strTime.components(separatedBy:":")
        let intHours = Int(aryAllComponent.first!)
        let intMinutes = Int(aryAllComponent.last!)
        dateComponent.hour = intHours //dateComponent.hour
        dateComponent.minute = intMinutes //dateComponent.minute! + 1

        let date = calendar.date(from: dateComponent)

        return date!
        
    }
    
    //MARK: Open sharing indicator
    func openSharingIndicator(url:String,completionBlock:sharingBlock){
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { [weak self] activityType, completed, returnedItems, activityError in
            completionBlock!()
        }
        let topNavigationVC = UIApplication.topViewController()
        topNavigationVC!.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Create Date Method
    func createDate1950Jan() -> Date{
        var dateComponents = DateComponents()
        dateComponents.year = 1950
        dateComponents.month = 1
        dateComponents.day = 1
        
        let userCalendar = Calendar.current // user calendar
        let dateThisPostWasUpdated = userCalendar.date(from: dateComponents)
        return dateThisPostWasUpdated!
    }
    
    func getDateAndTime()->String{
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd hh:mm aa"
        return formatter.string(from: date)
    }
 
    
    func getDeviceToken() -> String {
        return self.getUserDefault(KEYS_USERDEFAULTS.DEVICE_TOKEN) as? String ?? ""
    }
    
    //MARK: - Theme change Method
    func themeChangeForView(subview:UIView){
        
        if subview is ButtonControlModel {
            let v1 = subview as! ButtonControlModel
            v1.setup()
        }
        if subview is FollowButtonCtrlModel {
            let v2 = subview as! FollowButtonCtrlModel
            v2.setup()
        }
        if subview is darkGreyButtonCtrlModel {
            let v3 = subview as! darkGreyButtonCtrlModel
            v3.setup()
        }
        if subview is viewControlModel {
            let v4 = subview as! viewControlModel
            v4.setup()
        }
        if subview is underlineViewCtrlModel {
            let v5 = subview as! underlineViewCtrlModel
            v5.setup()
        }
        if subview is uploadingLightGreenViewCtrlModel {
            let v6 = subview as! uploadingLightGreenViewCtrlModel
            v6.setup()
        }
        if subview is uploadLightGreenViewCtrlModel {
            let v7 = subview as! uploadLightGreenViewCtrlModel
            v7.setup()
        }
        if subview is uploadDarkGreyViewCtrlModel {
            let v8 = subview as! uploadDarkGreyViewCtrlModel
            v8.setup()
        }
        if subview is errorRedViewCtrlModel {
            let v9 = subview as! errorRedViewCtrlModel
            v9.setup()
        }
        if subview is blackLabelCtrlModel {
            let v10 = subview as! blackLabelCtrlModel
            v10.setup()
        }
        if subview is darkGreyLabelCtrlModel {
            let v11 = subview as! darkGreyLabelCtrlModel
            v11.setup()
        }
        if subview is lightGreyLabelCtrlModel {
            let v12 = subview as! lightGreyLabelCtrlModel
            v12.setup()
        }
        if subview is whiteLabelCtrlModel {
            let v13 = subview as! whiteLabelCtrlModel
            v13.setup()
        }
        if subview is greenLabelCtrlModel {
            let v14 = subview as! greenLabelCtrlModel
            v14.setup()
        }
        if subview is yellowLabelCtrlModel {
            let v15 = subview as! yellowLabelCtrlModel
            v15.setup()
        }
        if subview is textFieldCtrlModel {
            let v16 = subview as! textFieldCtrlModel
            v16.setup()
        }
        if subview is textViewCtrlModel {
            let v17 = subview as! textViewCtrlModel
            v17.setup()
        }
        if subview is topNavigationModel {
            let v18 = subview as! topNavigationModel
            v18.setup()
        }
        if subview is bottomNavigationModel {
            let v19 = subview as! bottomNavigationModel
            v19.setup()
        }
        if subview is sideNavigationModel {
            let v20 = subview as! sideNavigationModel
            v20.setup()
        }
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

//MARK: - API GLOBALLY USED
extension GLOBAL{
    
    //Get CMS Pages
    func callAPIForCMSPages(){
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: CMSModel.self,apiName:APIName.CMSLinks, requestType: .get, paramValues: nil, headersValues: nil, SuccessBlock: { (response) in
            
             print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta){
                GLOBAL.sharedInstance.TermsOfService = response.data?.TermsOfService ?? "https://www.theweedtube.com"
                GLOBAL.sharedInstance.PrivacyPolicy = response.data?.PrivacyPolicy ?? "https://www.theweedtube.com"
                GLOBAL.sharedInstance.AboutUs = response.data?.AboutUs ?? "https://www.theweedtube.com"
                GLOBAL.sharedInstance.ContactUs = response.data?.ContactUs ?? "https://www.theweedtube.com"
                GLOBAL.sharedInstance.Help = response.data?.Help ?? "https://www.theweedtube.com"
                GLOBAL.sharedInstance.UserAgreement = response.data?.UserAgreement ?? "https://www.theweedtube.com"
                GLOBAL.sharedInstance.EulaTerms = response.data?.EulaTerms ?? "https://www.theweedtube.com"

            }
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
    
    func callReportcategorylistAPI(isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,]
        
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: ReportCategoryModel.self,apiName:APIName.Reportcategorylist, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if isInMainThread{
                self.hideLoader()
            }
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                self.arrayReportCategoryData = response.data ?? [ReportCategoryData]()
                completionBlock(true,response.meta?.message ?? "success")
            }
            else{
                completionBlock(false,response.meta?.message ?? "fail")
            }
            
        }, FailureBlock: { (error) in
            if isInMainThread{
                self.hideLoader()
                completionBlock(false,error.localizedDescription)
            }
        })
    }
    
    func callAddReportAPI(strCategoryId : String, strVideoId : String, strDescription : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.category_id : strCategoryId,
                                          KEYS_API.video_id : strVideoId,
                                          KEYS_API.description : strDescription,]
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:APIName.AddReport, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
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
    
    func callReportUserAPI(strCategoryId : String, strUserId : String, strDescription : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.reported_id : strUserId,
                                          KEYS_API.description : strDescription,
                                          KEYS_API.category_id : strCategoryId]
        
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:APIName.ReportUser, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
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
    
    func callAddToStashAPI(strUserId : String, strVideoId : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.user_id : strUserId,
                                          KEYS_API.video_id : strVideoId,]
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:APIName.AddToStash, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
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
    
    func callGetUserPlaylistAPI(isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
                        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,]
        
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: UserPlaylistModel.self,apiName:APIName.GetUserPlaylist, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if isInMainThread{
                self.hideLoader()
            }
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                self.arrayPlaylistData = response.data ?? [PlaylistData]()
                completionBlock(true,response.meta?.message ?? "success")
            }
            else{
                completionBlock(false,response.meta?.message ?? "fail")
            }
            
        }, FailureBlock: { (error) in
            if isInMainThread{
                self.hideLoader()
                completionBlock(false,error.localizedDescription)
            }
        })
    }
    
    func callAddToPlaylistAPI(strPlaylistId : String, strVideoId : String, strPlaylistName : String,strPlaylistType : String, isFromCreate:Bool, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        var queryParams: [String: Any]
        if isFromCreate{
            queryParams = [KEYS_API.platform : APIConstant.platform,
                           KEYS_API.version : KEYS_API.app_version,
                           KEYS_API.type : strPlaylistType,
                           KEYS_API.name : strPlaylistName,
                           KEYS_API.video_id : strVideoId,
                           KEYS_API.operation : "New"]
        }
        else{
            queryParams = [KEYS_API.platform : APIConstant.platform,
                                              KEYS_API.version : KEYS_API.app_version,
                                              KEYS_API.playlist_id : strPlaylistId,
                                              KEYS_API.video_id : strVideoId,
                                              KEYS_API.operation : ""]
        }
        
        
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:APIName.AddToPlaylist, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
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
    
    func callCreatePlaylistAPI(strPlaylistName : String, strType : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.name : strPlaylistName,
                                          KEYS_API.type : strType,]
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:APIName.CreatePlaylist, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
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
    
    func callVideoLikeUnlikeAPI(strVideoUUID : String, strIsLike : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.video_uuid : strVideoUUID,
                                          KEYS_API.is_like : strIsLike,]
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:APIName.VideoLikeUnlike, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
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
    
    func callVideoCommentLikeUnlikeAPI(strCommentUUID : String, strIsLike : String,strApiName : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.comment_uuid : strCommentUUID,
                                          KEYS_API.is_like : strIsLike,]
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:strApiName, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
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
    
    func callFollowUpfollowAPI(strFollowingID : String, strIsFollowUnFollow : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.following_id : strFollowingID,
                                          KEYS_API.follow_unfollow : strIsFollowUnFollow,]
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:APIName.FollowUnFollow, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
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
    
    func callVideoAddCommentAPI(strVideoUUID : String, strComment : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String, _ modelComment:Model_CommentListingData?) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.video_uuid : strVideoUUID,
                                          KEYS_API.comment : strComment,]
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_AddCommentResponse.self,apiName:APIName.VideoAddComment, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if isInMainThread{
                self.hideLoader()
            }
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                completionBlock(true,response.meta?.message ?? "success", response.data)
            }
            else{
                completionBlock(false,response.meta?.message ?? "fail",response.data)
            }
            
        }, FailureBlock: { (error) in
            if isInMainThread{
                self.hideLoader()
            }
            completionBlock(false,error.localizedDescription,nil)
        })
    }
    
    func callVideoAddCommentReplyAPI(strCommentUUID : String, strComment : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String, _ modelComment:Model_CommentListingData?) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.comment_uuid : strCommentUUID,
                                          KEYS_API.comment : strComment,]
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_AddCommentResponse.self,apiName:APIName.VideoAddCommentReply, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if isInMainThread{
                self.hideLoader()
            }
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                completionBlock(true,response.meta?.message ?? "success", response.data)
            }
            else{
                completionBlock(false,response.meta?.message ?? "fail",response.data)
            }
            
        }, FailureBlock: { (error) in
            if isInMainThread{
                self.hideLoader()
            }
            completionBlock(false,error.localizedDescription,nil)
        })
    }
    
    func callDeleteCommentAPI(strCommentID : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version]
        if isInMainThread{
            self.showLoader()
        }
        
        let strApiName = APIName.VideoDeleteComment + strCommentID
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:strApiName, requestType: .delete, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
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
    
    func callReplyDeleteCommentAPI(strCommentID : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version]
        if isInMainThread{
            self.showLoader()
        }
        
        let strApiName = APIName.VideoReplyDeleteComment + strCommentID
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_HomeResponse.self,apiName:strApiName, requestType: .delete, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
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
    
    func callEditCommentAPI(strCommentID : String,strComment : String, isInMainThread:Bool, completionBlock:@escaping (_ status:Bool,_ message:String, _ modelComment:Model_CommentListingData?) -> Void){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.comment_uuid : strCommentID,
                                            KEYS_API.comment : strComment,
                                            KEYS_API.platform : APIConstant.platform,
                                            KEYS_API.version : KEYS_API.app_version]
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_AddCommentResponse.self,apiName:APIName.VideoEditComment, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if isInMainThread{
                self.hideLoader()
            }
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                completionBlock(true,response.meta?.message ?? "success",  response.data)
            }
            else{
                completionBlock(false,response.meta?.message ?? "fail",  response.data)
            }
            
        }, FailureBlock: { (error) in
            if isInMainThread{
                self.hideLoader()
            }
            completionBlock(false,error.localizedDescription, nil)
        })
    }
}
