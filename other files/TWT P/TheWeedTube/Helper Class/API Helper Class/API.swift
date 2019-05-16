//
//  API.swift
//  Created by Sandip Patel (SM) on 19/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

//Alamofire Help Guide: https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#response-validation


import UIKit
import Alamofire
import NotificationBannerSwift


var alamofireUploadManager : Alamofire.SessionManager!

//MARK: BASE URL  //SMP: CONFIG SETUP

//let strBaseUrl = "https://api-theweedtube.demo.brainvire.com/front/api/v1/"  // ==> Development

//let strBaseUrl = "https://theweedapi-stag.demo.brainvire.com/front/api/v1/"  // ==> Staging

let strBaseUrl = "https://api.theweedtube.com/front/api/v1/"  // ==> Production



//Upload ProgressBlock
typealias MyProgressHandler = ((_ progress:Progress) -> ())?

//MARK:- Code Constant
let arySuccessCode = [200,201]  //To consider as success
let aryFailureCode = [400,404,422]  //To show server multiple messages

//MARK:- Status Code
struct STATUS_CODE{
    static let SUCCESS          = 200
    static let SUCCESS_201      = 201
    static let FAILED           = 400
    static let FAILED_401       = 401
    static let FAILED_404       = 404
    static let FAILED_422       = 422
}

//struct BASIC_AUTH{
//    static let username         = "hasya.panchasara@brainvire.com"
//    static let password         = "Brain@2019"
//    static let basic_auth_token = "Brain@2019"
//
//    static func getBasicAuthToken() -> String{
//        let loginString = String(format: "%@:%@", username, password)
//        let loginData = loginString.data(using: String.Encoding.utf8)!
//        let base64LoginString = loginData.base64EncodedString()
//        return "Basic \(base64LoginString)"
//    }
//}


//MARK:- Status Code custom messages
struct STATUS_CODE_MSG{
    static let MSG_401 = "Your session has been expired. Please login again. Thank you." //"You have been logged out because you signed in on another device OR your account is inactive"
}

var responseServerErrorDict = [String: AnyObject]()

//MARK:- API Constant
struct APIConstant {
    static let parseErrorDomain = "ParseError"
    static let parseErrorMessage = "Unable to parse data"
    static let parseErrorCode = Int(UInt8.max)
    static let content_type = "Content-Type"
    static let Authorization = "Authorization"
    static let content_value_urlencoded = "application/x-www-form-urlencoded"
    static let content_value_Json = "application/json"
    static let content_value_Form_Data = "multipart/form-data"

    static let platform = "iOS"
    static let timezoneUTC = "UTC"
    static let languageCode = "lang-code"
    
    static let RecordsPerPage = "10"
}

//MARK:- API Methods Name
struct APIName {
    
    //Version Check
    static let VersionCheck = "oauth/get-latest-version-app"
    
    static let CMSLinks = "content_page/get-static-pages"
    
    //User Module
    static let Login = "oauth/signin"
    static let Register = "user/register"
    static let ChangePassword = "oauth/password/change"
    static let ForgotPassword = "oauth/password/forgot"
    
    //Settings
    static let GetAccountSetting = "user/getUserAccountSettings"
    static let SetAccountSetting = "user/setUserAccountSettings"
    
    //Profile
    static let GetProfile          = "user/getProfile"
    static let GetProfileVideolist = "myprofile/videolist"
    static let GetProfilePlaylist  = "myprofile/playlist"
    static let SetProfile          = "user/setProfile"
    static let VideoDelete         = "video/delete/"
    
    static let GetVisitorProfile          = "user/get-profile"
    static let GetVisitorProfileVideolist = "visitorsprofile/videolist"
    static let GetVisitorProfilePlaylist  = "visitorsprofile/playlist"
    
    static let BlockUser = "user/block-unblock"
    static let ReportUser = "report/user"
    
    //Category
    static let VideoAutoComplete = "video/autocomplete"
    
    //Category
    static let GetCategories = "category/list"
    static let GetCategoryVideo = "video/list"
    static let GetPlaylist = "playlist/list"
    static let GetUserSearchlist = "user/search"
    
    //Home
    static let GetTrendingVideo = "home/getTrendingVideo"
    static let GetRecommendedVideo = "home/getRecommendedVideo"
    static let GetRecentlyUploadedVideo = "home/getRecentlyUploadedVideo"
    static let GetFeaturedVideo = "home/getFeaturedVideo"
    static let GetHomeCategoryVideos = "home/getHomeCategotySection"
    static let GetHomeDynamicContent = "home/getHomeContentSection"
    
    static let GetAllRecentlyUploadedVideo = "home/getViewAllRecentlyUploadedVideo"
    
    //All Popup APIs
    static let Reportcategorylist = "reportabuse/reportcategorylist"
    static let AddReport = "reportabuse/add-report"
    static let AddToStash = "playlist/addtowatchlater"
    static let GetUserPlaylist = "playlist/getUserPlayList"
    static let AddToPlaylist = "playlist/addtoplaylist"
    static let CreatePlaylist = "playlist/create"
    
    //Video Detail
    static let VideoDetail = "video/details"
    static let VideoLikeUnlike = "video/like-unlike"
    static let VideoCommentLikeUnlike = "video/comment/like-unlike"
    static let VideoReplyCommentLikeUnlike = "video/like-unlike-reply"
    
    //Video Comment
    static let VideoCommentList = "video/list-comment"
    static let VideoAddComment = "video/add-comment"
    static let VideoEditComment = "video/edit-comment"
    static let VideoDeleteComment = "video/delete-comment/"
    static let VideoReplyDeleteComment = "video/delete-reply/"
    
    
    //Video Playlist
    static let VideoPlaylist = "playlistvideo/list"
 
    //Comment Reply
    static let VideoCommentReplyList = "video/comment/reply-list"
    static let VideoAddCommentReply = "video/comment/reply"
    static let VideoEditCommentReply = "video/edit-reply"
    static let VideoDeleteCommentReply = "video/delete-reply/"
    
    
    //Upload Video
    static let VideoCreate = "video/create"
    static let VideoUpdate = "video/update"
    
    //My Stash
    static let MyStash = "myprofile/mystash"
    static let DeleteFromMyStash = "playlist/destroywatchlatervideo/"
    
    // Blocked User List
    static let BlockedUserListing = "block/userlisting"
    
    //Check Username
    static let Username = "check/username"
    
    //Followers List
    static let FollowersList = "follow/followedToList"
    
    //Notification List
    static let NotificationList = "notif/listing" //notification/listing    notif/listing
    
    // Notification read
    static let NotificationRead = "notification/changeStatus"
    
    //Follow/UnFollow
    static let FollowUnFollow = "follow/followUnfollow"
    
    //Feed
    static let FeedList = "video/subscrption-feed-list"
    
    //Logout
    static let Logout = "oauth/signoutuser"
    
}

class API: NSObject {
    
    static let sharedInstance = API() 
    
    private override init() {
        SMNetworkManager.shared.startNetworkReachabilityObserver()
    }
    
    //MARK: - API calling with Model Class response
    func apiRequestWithModalClass<T:Decodable>(modelClass:T.Type?, apiName:String, requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, SuccessBlock:@escaping (T) -> Void, FailureBlock:@escaping (Error)-> Void) {
        
        
        //Adding Extra Headers...
        /*
         let newHeadersValues = NSMutableDictionary()
         newHeadersValues.setDictionary(headersValues ?? [:])
         
         newHeadersValues.setValue(APIConstant.content_value_Json, forKey:APIConstant.content_type)
         newHeadersValues.setValue("\(self.getUserDefault(KEYS_USERDEFAULTS.TOKEN_TYPE) as? String ?? "") \(self.getUserDefault(KEYS_USERDEFAULTS.ACCESS_TOKEN) as? String ?? "")", forKey: APIConstant.Authorization)
         */
        //=========================
        
        let url = strBaseUrl + apiName
        
        print("\n<<<=================================>>>\n")
        print("API Call: \(url)\n")
        print("Headers: \(String(describing: headersValues))\n")
        print("Parameters: \(String(describing: paramValues))\n")
        
        if !(SMNetworkManager.shared.isReachable!) {
            
            let view = Bundle.loadView(fromNib:"HSNetworkAlert", withType:HSNetworkAlert.self)
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    self.showLoader()
                    self.apiRequestWithModalClass(modelClass: modelClass, apiName: apiName, requestType: requestType, paramValues: paramValues, headersValues: headersValues, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock)
                    //self.hideLoader()
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let viewToAdd = UIApplication.topViewController()?.view.viewWithTag(5022) ?? UIApplication.topViewController()?.view{
                    view.frame = viewToAdd.bounds
                    viewToAdd.addSubview(view)
                }
                self.hideLoader()
            }
            return
        }
        
        //URLEncoding.httpBody
        //JSONEncoding.default
        
        //SMP: Fix
        let apiContentType = (headersValues?[APIConstant.content_type]) ?? APIConstant.content_value_Json
        let apiEncodingType = ((apiContentType == APIConstant.content_value_Form_Data) ? URLEncoding.httpBody : JSONEncoding.default as ParameterEncoding)
        
        Alamofire.request(url, method: requestType, parameters: paramValues, encoding: apiEncodingType, headers: headersValues).response { (response) in
            
            if((response.error) != nil){
                //self.showToastMessage(title:(response.error?.localizedDescription)!)
                self.alertOnTop(message: (response.error?.localizedDescription)!) //sam
                logw(String(describing: response.error))
                FailureBlock(response.error!)
            }
            else{
                guard let data = response.data else {
                    FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                    return
                }
                
                //Just for printing response in Json to visualise...
                do {
                    guard let jsonResult = try JSONSerialization.jsonObject(with: data, options:
                        JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary else{
                            FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                            return
                    }
                    
                    //Server Side error handling...
                    if let errorDict = jsonResult["errors"] as? [String: AnyObject]{
                        responseServerErrorDict = errorDict
                        print(responseServerErrorDict)
                        //print(responseServerErrorDict.keys)
                    }
                    //==========================
                    
                    print(jsonResult)
                    
                }catch let error{
                    print(error)
                    let errorResponseString = data.toString()
                    print("\n\n Error Response Print: \n\n \(errorResponseString) \n\n")
                    FailureBlock(error)
                    //self.showToastMessage(title: msg_NoValidResponseInAPI)
                    self.alertOnTop(message: msg_NoValidResponseInAPI)
                    return
                }
                
                
                //Model Parsing...
                do {
                    let objModalClass = try JSONDecoder().decode(modelClass!,from: data)
                    //print(objModalClass)
                    SuccessBlock(objModalClass)
                    responseServerErrorDict = [:]
                } catch let error { //If model class parsing fail
                    
                    print(error)
                    logw(String(describing: error))
                    //self.showToastMessage(title: msg_NoValidResponseInAPI)
                    self.alertOnTop(message: msg_NoValidResponseInAPI) //sam
                    FailureBlock(error)
                }
            }
        }
    }
    
    func apiRequestBackgroundWithModalClass<T:Decodable>(modelClass:T.Type?, apiName:String, requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, SuccessBlock:@escaping (T) -> Void, FailureBlock:@escaping (Error)-> Void) { //Note: Don't show error message, Don't show Network reachability screen
        
        let url = strBaseUrl + apiName
        
        print("\n<<<=================================>>>\n")
        print("API Call: \(url)\n")
        print("Headers: \(String(describing: headersValues))\n")
        print("Parameters: \(String(describing: paramValues))\n")
        
        if !(SMNetworkManager.shared.isReachable!) {
            
            let view = Bundle.loadView(fromNib:"HSNetworkAlert", withType:HSNetworkAlert.self)
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    //self.showLoader()
                    self.apiRequestBackgroundWithModalClass(modelClass: modelClass, apiName: apiName, requestType: requestType, paramValues: paramValues, headersValues: headersValues, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock)
                    //self.hideLoader()
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let viewToAdd = UIApplication.topViewController()?.view.viewWithTag(5022) ?? UIApplication.topViewController()?.view{
                    view.frame = viewToAdd.bounds
                    viewToAdd.addSubview(view)
                }
                //self.hideLoader()
            }
            return
        }
        
        //URLEncoding.httpBody
        //JSONEncoding.default
        
        //SMP: Fix
        let apiContentType = (headersValues?[APIConstant.content_type]) ?? APIConstant.content_value_Json
        let apiEncodingType = ((apiContentType == APIConstant.content_value_Form_Data) ? URLEncoding.httpBody : JSONEncoding.default as ParameterEncoding)
        
        Alamofire.request(url, method: requestType, parameters: paramValues, encoding: apiEncodingType, headers: headersValues).response { (response) in
            
            if((response.error) != nil){
                //self.showToastMessage(title:(response.error?.localizedDescription)!)
                self.alertOnTop(message: (response.error?.localizedDescription)!) //sam
                logw(String(describing: response.error))
                FailureBlock(response.error!)
            }
            else{
                guard let data = response.data else {
                    FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                    return
                }
                
                //Just for printing response in Json to visualise...
                do {
                    guard let jsonResult = try JSONSerialization.jsonObject(with: data, options:
                        JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary else{
                            return
                    }
                    
                    //Server Side error handling...
                    if let errorDict = jsonResult["errors"] as? [String: AnyObject]{
                        responseServerErrorDict = errorDict
                        print(responseServerErrorDict)
                        //print(responseServerErrorDict.keys)
                    }
                    //==========================
                    
                    print(jsonResult)
                    
                }catch let error{
                    print(error)
                    let errorResponseString = data.toString()
                    print("\n\n Error Response Print: \n\n \(errorResponseString) \n\n")
                    //self.showToastMessage(title: msg_NoValidResponseInAPI)
                    self.alertOnTop(message: msg_NoValidResponseInAPI)
                }
                
                
                //Model Parsing...
                do {
                    let objModalClass = try JSONDecoder().decode(modelClass!,from: data)
                    //print(objModalClass)
                    SuccessBlock(objModalClass)
                    responseServerErrorDict = [:]
                } catch let error { //If model class parsing fail
                    
                    print(error)
                    logw(String(describing: error))
                    //self.showToastMessage(title: msg_NoValidResponseInAPI)
                    FailureBlock(error)
                }
            }
        }
    }
    
    //MARK: - API calling with JSON data response
    func apiRequestWithJsonResponse(apiName:String, requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, SuccessBlock:@escaping (AnyObject) -> Void, FailureBlock:@escaping (Error)-> Void) {
        
        //Adding Extra Headers...
        /*
         let newHeadersValues = NSMutableDictionary()
         newHeadersValues.setDictionary(headersValues ?? [:])
         
         //newHeadersValues.setValue(APIConstant.content_value_Json, forKey:APIConstant.content_type)
         newHeadersValues.setValue("\(self.getUserDefault(KEYS_USERDEFAULTS.TOKEN_TYPE) as? String ?? "") \(self.getUserDefault(KEYS_USERDEFAULTS.ACCESS_TOKEN) as? String ?? "")", forKey: APIConstant.Authorization)
         */
        //=========================
        
        let url = strBaseUrl + apiName
        
        print("\n<<<=================================>>>\n")
        print("API Call: \(url)\n")
        print("Headers: \(String(describing: headersValues))\n")
        print("Parameters: \(String(describing: paramValues))\n")
        
        if !(SMNetworkManager.shared.isReachable!) {
            
            let view = Bundle.loadView(fromNib:"HSNetworkAlert", withType:HSNetworkAlert.self)
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    self.showLoader()
                    self.apiRequestWithJsonResponse(apiName: apiName, requestType: requestType, paramValues: paramValues, headersValues: headersValues, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock)
                    //self.hideLoader()
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let viewToAdd = UIApplication.topViewController()?.view.viewWithTag(5022) ?? UIApplication.topViewController()?.view{
                    view.frame = viewToAdd.bounds
                    viewToAdd.addSubview(view)
                }
                self.hideLoader()
            }
            
            return
        }
        
        //URLEncoding.httpBody
        //JSONEncoding.default
        
        //SMP: Fix
        let apiContentType = (headersValues?[APIConstant.content_type]) ?? APIConstant.content_value_Json
        let apiEncodingType = ((apiContentType == APIConstant.content_value_Form_Data) ? URLEncoding.httpBody : JSONEncoding.default as ParameterEncoding)
        
        Alamofire.request(url, method: requestType, parameters: paramValues, encoding: apiEncodingType, headers: headersValues).responseJSON { (response) in
            
            switch response.result {
            case .success:
                //print("Validation Successful")
                
                //Server Side error handling...
                if let responseDict = response.value as? [String: AnyObject] {
                    //print(responseDict)
                    if let errorDict = responseDict["errors"] as? [String: AnyObject]{
                        responseServerErrorDict = errorDict
                        print(responseServerErrorDict)
                        //print(responseServerErrorDict.keys)
                    }
                }
                //==========================
                
                SuccessBlock(response.result.value as AnyObject)
                responseServerErrorDict = [:]
            case .failure(let error):
                print(error)
                logw(String(describing: error))
                //self.showToastMessage(title:(error.localizedDescription))
                self.alertOnTop(message: (error.localizedDescription)) //sam
                FailureBlock(error)
            }
        }
    }
    
    //MARK:- Upload API (Multi Part Api)
    func apiRequestUploadWithModalClass<T:Decodable>(modelClass:T.Type?, apiName:String, requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, imagesData:[Data], uploadKey:String, SuccessBlock:@escaping (T) -> Void, FailureBlock:@escaping (Error)-> Void, ProgressHandler:MyProgressHandler){
        
        let url = strBaseUrl + apiName
        
        //Adding Extra Headers...
        /*
         let newHeadersValues = NSMutableDictionary()
         newHeadersValues.setDictionary(headersValues ?? [:])
         
         //newHeadersValues.setValue(APIConstant.content_value_Json, forKey:APIConstant.content_type)
         newHeadersValues.setValue("\(self.getUserDefault(KEYS_USERDEFAULTS.TOKEN_TYPE) as? String ?? "") \(self.getUserDefault(KEYS_USERDEFAULTS.ACCESS_TOKEN) as? String ?? "")", forKey: APIConstant.Authorization)
         */
        //=========================
        
        print("\n<<<=================================>>>\n")
        print("API Call: \(url)\n")
        print("Headers: \(String(describing: headersValues))\n")
        print("Parameters: \(String(describing: paramValues))\n")
        
        
        if !(SMNetworkManager.shared.isReachable!) {
            
            let view = Bundle.loadView(fromNib:"HSNetworkAlert", withType:HSNetworkAlert.self)
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    self.showLoader()
                    self.apiRequestUploadWithModalClass(modelClass: modelClass, apiName: apiName, requestType: requestType, paramValues: paramValues, headersValues: headersValues, imagesData: imagesData, uploadKey: uploadKey, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock, ProgressHandler: ProgressHandler)
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let viewToAdd = UIApplication.topViewController()?.view.viewWithTag(5022) ?? UIApplication.topViewController()?.view{
                    view.frame = viewToAdd.bounds
                    viewToAdd.addSubview(view)
                }
                self.hideLoader()
            }
            
            return
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            for imageData in imagesData {
                //Multiple File Upload as Array
                multipartFormData.append(imageData, withName: "\(uploadKey)", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                
                //Single File Upload
                //multipartFormData.append(imageData, withName:uploadKey as String, fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/png")
            }
            for (key, value) in paramValues! {
                
                /*
                if  (value as AnyObject).isKind(of: NSMutableArray.self) || (value as AnyObject).isKind(of: NSArray.self)
                {
                    let arrayObj = (value as! NSArray).mutableCopy() as! NSMutableArray

                    let count : Int  = arrayObj.count
                    for i in 0  ..< count
                    {
                        let valueObj = "\(arrayObj[i])"
                        let keyObj = key + "[" + String(i) + "]"

                        print("Key : \(keyObj) , Value : \(valueObj) , Encoding Value : \((valueObj as AnyObject).data(using: String.Encoding.utf8.rawValue)!)")

                        multipartFormData.append(valueObj.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: keyObj)
                    }
                }
                else{
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                */
                
                ///*
                if  (value as AnyObject).isKind(of: NSMutableArray.self) || (value as AnyObject).isKind(of: NSArray.self) || (value as AnyObject).isKind(of: NSMutableDictionary.self) || (value as AnyObject).isKind(of: NSDictionary.self)
                {
                    
                    print(value)
                    
                    //Jsong Convert...
                    let json = try? JSONSerialization.data(withJSONObject: value, options: [.prettyPrinted])
                    let jsonPresentation = String(data: json!, encoding: .utf8)
                    print(jsonPresentation!)
                    multipartFormData.append((jsonPresentation?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
                    
                    /* //Data...
                    //let data = NSKeyedArchiver.archivedData(withRootObject: arrayObj)
                    let data =  try! JSONSerialization.data(withJSONObject: arrayObj)
                    print(data)
                    multipartFormData.append(data, withName: key)
                    */
                    
                }
                else{
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                //*/
            }
            
        }, to: strBaseUrl + apiName, method: .post, headers: headersValues)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (currentProgress) in
                    //print("upload progress \(currentProgress.fractionCompleted)")
                    if(ProgressHandler != nil){
                        ProgressHandler!(currentProgress)
                    }
                })
                
                upload.responseJSON { response in
                    
                    print(response)
                    
                    if((response.error) != nil){
                        //self.showToastMessage(title:(response.error?.localizedDescription)!)
                        self.alertOnTop(message: (response.error?.localizedDescription)!) //sam
                        logw(String(describing: response.error))
                        FailureBlock(response.error!)
                    }
                    
                    guard let data = response.data else {
                        FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                        return
                    }
                    
                    do {
                        
                        //Server Side error handling...
                        if let responseDict = response.value as? [String: AnyObject] {
                            //print(responseDict)
                            if let errorDict = responseDict["errors"] as? [String: AnyObject]{
                                responseServerErrorDict = errorDict
                                print(responseServerErrorDict)
                                //print(responseServerErrorDict.keys)
                            }
                        }
                        //==========================
                        
                        //To display json redable format...
                        let dataToString = data.toString()
                        print("\nResponse:\n \(String(describing: dataToString))\n")
                        
                        //Model Parsing...
                        let objModalClass = try JSONDecoder().decode(modelClass!,from: data)
                        //print(objModalClass)
                        SuccessBlock(objModalClass)
                        responseServerErrorDict = [:]
                    } catch let error { //If model class parsing fail
                        
                        print(error)
                        logw(String(describing: error))
                        //self.showToastMessage(title: msg_NoValidResponseInAPI)
                        self.alertOnTop(message: msg_NoValidResponseInAPI) //sam
                        FailureBlock(error)
                    }
                    
                }
                
            case .failure(let error):
                
                print("Uploaded Failed:\n Error:\n \(error)")
                logw(String(describing: error))
                //self.showToastMessage(title:(error.localizedDescription))
                self.alertOnTop(message: (error.localizedDescription)) //sam
                FailureBlock(error)
            }
        }
    }
    
    func multipartRequestWithModalClassForMedia<T:Decodable>(modelClass:T.Type?,apiName:String, fileName:[String],keyName:[String],fileData:[Data?],requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, SuccessBlock:@escaping (T) -> Void, FailureBlock:@escaping (Error)-> Void) {
        
        if !(SMNetworkManager.shared.isReachable!) {
            
            let view  = UINib(nibName: "HSNetworkAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HSNetworkAlert
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    self.showLoader()
                    self.multipartRequestWithModalClassForMedia(modelClass: modelClass, apiName: apiName, fileName: fileName, keyName: keyName, fileData: fileData, requestType: requestType, paramValues: paramValues, headersValues: headersValues, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock)
                    //self.hideLoader()
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let viewToAdd = UIApplication.topViewController()?.view.viewWithTag(5022) ?? UIApplication.topViewController()?.view{
                    view.frame = viewToAdd.bounds
                    viewToAdd.addSubview(view)
                }
                self.hideLoader()
            }
            
            return
        }
        
        let url = strBaseUrl + apiName
        
        print("\n------------------------API URL---------------------\n",url)
        
        print("\n------------------------API Request Parameters---------------------\n",paramValues as Any)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (index,fData) in fileData.enumerated(){
                if let file = fData{
                    //                    multipartFormData.append((file), withName: keyName[index],fileName: fileName[index], mimeType: "image/jpg")
                    multipartFormData.append(file, withName: "\(keyName[index])", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                }
            }
            
            //sweta
            for (key, value) in paramValues! {
                print("\(key) + \(value)")
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, to: url, method: .post, headers: headersValues)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    print("\n------------------------API Response---------------------\n",response.data as Any)
                    if((response.error) != nil){
                        print((response.error?.localizedDescription) as Any)
                        //  Alert.showAlert(title: (response.error?.localizedDescription), message: "")
                        //self.showToastMessage(title:(response.error?.localizedDescription)!)
                        FailureBlock(response.error!)
                    }
                    
                    guard let data = response.data else {
                        FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                        return
                    }
                    
                    do {
                        let objModalClass = try JSONDecoder().decode(modelClass!,from: data)
                        //print(objModalClass)
                        SuccessBlock(objModalClass)
                        responseServerErrorDict = [:]
                    } catch let error { //If model class parsing fail
                        FailureBlock(error)
                        self.alertOnTop(message: (error.localizedDescription))
                        print(error)
                    }
                }
                
            case .failure(let encodingError):
                FailureBlock(encodingError)
            }
        }
    }
    
    func apiRequestUploadWithJsonResponse(apiName:String, requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, imagesData:[Data], uploadKey:String, SuccessBlock:@escaping (AnyObject) -> Void, FailureBlock:@escaping (Error)-> Void, ProgressHandler:MyProgressHandler){
        
        let url = strBaseUrl + apiName
        
        //Adding Extra Headers...
        /*
         let newHeadersValues = NSMutableDictionary()
         newHeadersValues.setDictionary(headersValues ?? [:])
         
         //newHeadersValues.setValue(APIConstant.content_value_Json, forKey:APIConstant.content_type)
         newHeadersValues.setValue("\(self.getUserDefault(KEYS_USERDEFAULTS.TOKEN_TYPE) as? String ?? "") \(self.getUserDefault(KEYS_USERDEFAULTS.ACCESS_TOKEN) as? String ?? "")", forKey: APIConstant.Authorization)
         */
        //=========================
        
        print("\n<<<=================================>>>\n")
        print("API Call: \(url)\n")
        print("Headers: \(String(describing: headersValues))\n")
        print("Parameters: \(String(describing: paramValues))\n")
        
        
        if !(SMNetworkManager.shared.isReachable!) {
            
            let view = Bundle.loadView(fromNib:"HSNetworkAlert", withType:HSNetworkAlert.self)
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    self.showLoader()
                    self.apiRequestUploadWithJsonResponse(apiName: apiName, requestType: requestType, paramValues: paramValues, headersValues: headersValues, imagesData: imagesData, uploadKey: uploadKey, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock, ProgressHandler: ProgressHandler)
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let viewToAdd = UIApplication.topViewController()?.view.viewWithTag(5022) ?? UIApplication.topViewController()?.view{
                    view.frame = viewToAdd.bounds
                    viewToAdd.addSubview(view)
                }
                self.hideLoader()
            }
            
            return
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            // import image to request
            for imageData in imagesData {
                //Multiple File Upload as Array
                multipartFormData.append(imageData, withName: "\(uploadKey)[]", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                
                //Single File Upload
                //multipartFormData.append(imageData, withName:uploadKey as String, fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/png")
            }
            
            for (key, value) in paramValues! {
                /*
                 if  (value as AnyObject).isKind(of: NSMutableArray.self) || (value as AnyObject).isKind(of: NSArray.self)
                 {
                 let arrayObj = (value as! NSArray).mutableCopy() as! NSMutableArray
                 
                 let count : Int  = arrayObj.count
                 for i in 0  ..< count
                 {
                 let valueObj = "\(arrayObj[i])"
                 let keyObj = key + "[" + String(i) + "]"
                 
                 print("Key : \(keyObj) , Value : \(valueObj) , Encoding Value : \((valueObj as AnyObject).data(using: String.Encoding.utf8.rawValue)!)")
                 
                 multipartFormData.append(valueObj.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: keyObj)
                 }
                 }
                 else{
                 multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                 }
                 */
                
                ///*
                if  (value as AnyObject).isKind(of: NSMutableArray.self) || (value as AnyObject).isKind(of: NSArray.self) || (value as AnyObject).isKind(of: NSMutableDictionary.self) || (value as AnyObject).isKind(of: NSDictionary.self)
                {
                    
                    print(value)
                    
                    //Jsong Convert...
                    let json = try? JSONSerialization.data(withJSONObject: value, options: [.prettyPrinted])
                    let jsonPresentation = String(data: json!, encoding: .utf8)
                    print(jsonPresentation!)
                    multipartFormData.append((jsonPresentation?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)!, withName: key)
                    
                    /* //Data...
                     //let data = NSKeyedArchiver.archivedData(withRootObject: arrayObj)
                     let data =  try! JSONSerialization.data(withJSONObject: arrayObj)
                     print(data)
                     multipartFormData.append(data, withName: key)
                     */
                    
                }
                else{
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                //*/
            }
            
        }, usingThreshold: 0, to: url, method: requestType, headers: (headersValues as! HTTPHeaders)) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (currentProgress) in
                    //print("upload progress \(currentProgress.fractionCompleted)")
                    if(ProgressHandler != nil){
                        ProgressHandler!(currentProgress)
                    }
                })
                
                upload.responseJSON { response in
                    
                    //Server Side error handling...
                    if let responseDict = response.value as? [String: AnyObject] {
                        //print(responseDict)
                        if let errorDict = responseDict["errors"] as? [String: AnyObject]{
                            responseServerErrorDict = errorDict
                            print(responseServerErrorDict)
                            //print(responseServerErrorDict.keys)
                        }
                    }
                    //==========================
                    
                    print("Uploaded Successfully:\n Response:\n \(response)")
                    SuccessBlock(response as AnyObject)
                    responseServerErrorDict = [:]
                }
            case .failure(let error):
                
                print("Uploaded Failed:\n Error:\n \(error)")
                logw(String(describing: error))
                //self.showToastMessage(title:(error.localizedDescription))
                self.alertOnTop(message: (error.localizedDescription)) //sam
                FailureBlock(error)
            }
        }
    }
    
    
    func multipartRequestWithModalClassForVideo<T:Decodable>(modelClass:T.Type?,apiName:String, fileName:String,keyName:[String],fileData:Data?,videoURL: URL?,requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?,isFromEdit: Bool?, SuccessBlock:@escaping (T) -> Void, FailureBlock:@escaping (Error)-> Void,ProgressHandler:MyProgressHandler) {
        
        if !(SMNetworkManager.shared.isReachable!) {
            
            let view  = UINib(nibName: "HSNetworkAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HSNetworkAlert
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    self.showLoader()
                    self.multipartRequestWithModalClassForVideo(modelClass: modelClass, apiName: apiName, fileName: fileName, keyName: keyName, fileData: fileData, videoURL: videoURL, requestType: requestType, paramValues: paramValues, headersValues: headersValues, isFromEdit: isFromEdit, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock, ProgressHandler: ProgressHandler)
                    //self.hideLoader()
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let viewToAdd = UIApplication.topViewController()?.view.viewWithTag(5022) ?? UIApplication.topViewController()?.view{
                    view.frame = viewToAdd.bounds
                    viewToAdd.addSubview(view)
                }
                self.hideLoader()
            }
            
            return
        }
        
        let url = strBaseUrl + apiName
        
        print("\n------------------------API URL---------------------\n",url)
        
        print("\n------------------------API Request Parameters---------------------\n",paramValues as Any)
        
        ///*
        //SMP: Fix
        //Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 3600 //Not Works
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(3600)
        configuration.timeoutIntervalForRequest = TimeInterval(3600)        
        alamofireUploadManager = Alamofire.SessionManager(configuration: configuration)
        //-----------------------------
        //*/
       
        alamofireUploadManager.upload(multipartFormData: { multipartFormData in
        //Alamofire.upload(multipartFormData: { multipartFormData in
            for strKey in keyName{
                if strKey == KEYS_API.thumbnail{
                    //sam
//                    multipartFormData.append(fileData!, withName: strKey, fileName: "\(Int(Date().timeIntervalSince1970)).jpeg", mimeType: "image/jpeg")
//                    multipartFormData.append(fileData!, withName: strKey, fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                    //multipartFormData.append(fileData!, withName: strKey,fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/\(fileData!.fileExtension))")
                }else{
                    // here you can upload only mp4 video
                    
                    if isFromEdit!{
                        
                    }else{
                        let fileName = videoURL?.lastPathComponent
                        multipartFormData.append(videoURL!, withName: strKey, fileName: fileName!, mimeType: "video/quicktime")
                    }
                    
//                    do {
//                        //let seprateName = fileName?.components(separatedBy: ".")
//                        //let fileString = seprateName![0] + ".mp4"
//                        //let videoData = try Data.init(contentsOf: videoURL!, options: .mappedIfSafe)
//                    } catch {
//                        //handle error
//                        print(error)
//                    }
                    
                    
                    // here you can upload any type of video
//                    multipartFormData.append(videoURL!, withName: "video/mov")
                    //let strUrl = videoURL?.absoluteString
                    //multipartFormData.append(strUrl!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "Type")
                }
            }
            //sweta
            for (key, value) in paramValues! {
                print("\(key) + \(value)")
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, to: url, method: .post, headers: headersValues)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    //self.showLoadingIndicator(progress: Float(progress.fractionCompleted), status: "Uploading...")
                    if(ProgressHandler != nil){
                        ProgressHandler!(progress)
                    }
                })
                
                upload.responseJSON { response in
                    print("\n------------------------API Response---------------------\n",response.data as Any)
                    if((response.error) != nil){
                        print((response.error?.localizedDescription) as Any)
                        //  Alert.showAlert(title: (response.error?.localizedDescription), message: "")
                        self.alertOnTop(message: (response.error?.localizedDescription))
                        //self.showToastMessage(title:(response.error?.localizedDescription)!)
                        FailureBlock(response.error!)
                    }
                    
                    guard let data = response.data else {
                        FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                        return
                    }
                    
                    do {
                        
                        //Temp
                        guard let jsonResult = try JSONSerialization.jsonObject(with: data, options:
                            JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary else{
                                FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                                return
                        }
                        //--------
                        print(jsonResult)
                        
                        let objModalClass = try JSONDecoder().decode(modelClass!,from: data)
                        //print(objModalClass)
                        SuccessBlock(objModalClass)
                        responseServerErrorDict = [:]
                    } catch let error { //If model class parsing fail
                        FailureBlock(error)
                        self.alertOnTop(message: (error.localizedDescription))
                        print(error)
                    }
                }
                
            case .failure(let encodingError):
                FailureBlock(encodingError)
            }
        }
    }
    
    func multipartRequestWithModalClassForS3Video<T:Decodable>(modelClass:T.Type?,apiName:String, fileName:String,keyName:[String],fileData:Data?,requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?,isFromEdit: Bool?, SuccessBlock:@escaping (T) -> Void, FailureBlock:@escaping (Error)-> Void,ProgressHandler:MyProgressHandler) {
        
        if !(SMNetworkManager.shared.isReachable!) {
            
            let view  = UINib(nibName: "HSNetworkAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HSNetworkAlert
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    self.showLoader()
                    self.multipartRequestWithModalClassForS3Video(modelClass: modelClass, apiName: apiName, fileName: fileName, keyName: keyName, fileData: fileData, requestType: requestType, paramValues: paramValues, headersValues: headersValues, isFromEdit: isFromEdit, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock, ProgressHandler: ProgressHandler)
                    //self.hideLoader()
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let viewToAdd = UIApplication.topViewController()?.view.viewWithTag(5022) ?? UIApplication.topViewController()?.view{
                    view.frame = viewToAdd.bounds
                    viewToAdd.addSubview(view)
                }
                self.hideLoader()
            }
            
            return
        }
        
        let url = strBaseUrl + apiName
        
        print("\n------------------------API URL---------------------\n",url)
        
        print("\n------------------------API Request Parameters---------------------\n",paramValues as Any)
        
        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForResource = TimeInterval(3600)
//        configuration.timeoutIntervalForRequest = TimeInterval(3600)
        alamofireUploadManager = Alamofire.SessionManager(configuration: configuration)
        
        alamofireUploadManager.upload(multipartFormData: { multipartFormData in
            //Alamofire.upload(multipartFormData: { multipartFormData in
            for strKey in keyName{
                if strKey == KEYS_API.thumbnail{
                    //sam
                    multipartFormData.append(fileData!, withName: strKey, fileName: "\(Int(Date().timeIntervalSince1970)).jpeg", mimeType: "image/jpeg")
                }
                else{
//                    if isFromEdit!{
//                    }else{
//                        let fileName = videoURL?.lastPathComponent
//                        multipartFormData.append(videoURL!, withName: strKey, fileName: fileName!, mimeType: "video/quicktime")
//                    }
                }
            }
            //sweta
            for (key, value) in paramValues! {
                print("\(key) + \(value)")
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, to: url, method: .post, headers: headersValues)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    //self.showLoadingIndicator(progress: Float(progress.fractionCompleted), status: "Uploading...")
//                    if(ProgressHandler != nil){
//                        ProgressHandler!(progress)
//                    }
                })
                
                upload.responseJSON { response in
                    print("\n------------------------API Response---------------------\n",response.data as Any)
                    if((response.error) != nil){
                        print((response.error?.localizedDescription) as Any)
                        //  Alert.showAlert(title: (response.error?.localizedDescription), message: "")
                        self.alertOnTop(message: (response.error?.localizedDescription))
                        //self.showToastMessage(title:(response.error?.localizedDescription)!)
                        FailureBlock(response.error!)
                    }
                    
                    guard let data = response.data else {
                        FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                        return
                    }
                    
                    do {
                        
                        //Temp
                        guard let jsonResult = try JSONSerialization.jsonObject(with: data, options:
                            JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary else{
                                FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                                return
                        }
                        //--------
                        print(jsonResult)
                        
                        let objModalClass = try JSONDecoder().decode(modelClass!,from: data)
                        //print(objModalClass)
                        SuccessBlock(objModalClass)
                        responseServerErrorDict = [:]
                    } catch let error { //If model class parsing fail
                        FailureBlock(error)
                        self.alertOnTop(message: (error.localizedDescription))
                        print(error)
                    }
                }
                
            case .failure(let encodingError):
                FailureBlock(encodingError)
            }
        }
    }
    
    func multipartRequestWithModalClass<T:Decodable>(modelClass:T.Type?,apiName:String, fileName:String,keyName:String,imgView:UIImageView,requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, SuccessBlock:@escaping (T) -> Void, FailureBlock:@escaping (Error)-> Void) {
        
        
        if !(SMNetworkManager.shared.isReachable!) {
            
            let view = Bundle.loadView(fromNib:"HSNetworkAlert", withType:HSNetworkAlert.self)
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    self.showLoader()
                    self.multipartRequestWithModalClass(modelClass: modelClass, apiName: apiName, fileName: fileName, keyName: keyName, imgView: imgView, requestType: requestType, paramValues: paramValues, headersValues: headersValues, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock)
                    self.hideLoader()
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            if let viewToAdd = UIApplication.topViewController()?.view.viewWithTag(5022){
                view.frame = viewToAdd.bounds
                viewToAdd.addSubview(view)
            }
            self.hideLoader()
            
            return
        }
        
        let image = imgView.image
        let imgData = image!.jpegData(compressionQuality: 0.5)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: keyName,fileName: fileName, mimeType: "image/\(imgData!.fileExtension))")
            for (key, value) in paramValues! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: strBaseUrl + apiName, method: .post, headers: headersValues)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    if((response.error) != nil){
                        self.alertOnTop(message: (response.error?.localizedDescription))
                        //self.showToastMessage(title:(response.error?.localizedDescription)!)
                        FailureBlock(response.error!)
                    }
                    
                    guard let data = response.data else {
                        FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                        return
                    }
                    
                    do {
                        let objModalClass = try JSONDecoder().decode(modelClass!,from: data)
                        //print(objModalClass)
                        SuccessBlock(objModalClass)
                        responseServerErrorDict = [:]
                    } catch let error { //If model class parsing fail
                        //self.showToastMessage(title: "Oops!! There is some problem with request. Please try again")
                        self.alertOnTop(message: (error.localizedDescription))
                        FailureBlock(error)
                        print(error)
                    }
                    
                }
                
            case .failure(let encodingError):
                FailureBlock(encodingError)
            }
        }
    }
    
    //MARK:- Profile Update API
    func multipartRequestForProfileWithModalClassForMedia<T:Decodable>(modelClass:T.Type?,apiName:String, fileName:[String],keyName:[String],fileData:[Data?],requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, SuccessBlock:@escaping (T) -> Void, FailureBlock:@escaping (Error)-> Void) {
        
        if !(SMNetworkManager.shared.isReachable!) {
            
            let view  = UINib(nibName: "HSNetworkAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HSNetworkAlert
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    self.showLoader()
                    self.multipartRequestWithModalClassForMedia(modelClass: modelClass, apiName: apiName, fileName: fileName, keyName: keyName, fileData: fileData, requestType: requestType, paramValues: paramValues, headersValues: headersValues, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock)
                    //self.hideLoader()
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let viewToAdd = UIApplication.topViewController()?.view.viewWithTag(5022) ?? UIApplication.topViewController()?.view{
                    view.frame = viewToAdd.bounds
                    viewToAdd.addSubview(view)
                }
                self.hideLoader()
            }
            
            return
        }
        
        let url = strBaseUrl + apiName
        
        print("\n------------------------API URL---------------------\n",url)
        print("\n------------------------API Request Parameters---------------------\n",paramValues as Any)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (index,fData) in fileData.enumerated(){
                if let file = fData{
                    multipartFormData.append(file, withName: "\(keyName[index])", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                }
            }
            
            //sweta
            for (key, value) in paramValues! {
                print("\(key) + \(value)")
                
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            
        }, to: url, method: .post, headers: headersValues)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    print("\n------------------------API Response---------------------\n",response.data as Any)
                    if((response.error) != nil){
                        print((response.error?.localizedDescription) as Any)
                        self.alertOnTop(message: (response.error?.localizedDescription))
                        //  Alert.showAlert(title: (response.error?.localizedDescription), message: "")
                        //self.showToastMessage(title:(response.error?.localizedDescription)!)
                        FailureBlock(response.error!)
                    }
                    
                    guard let data = response.data else {
                        FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                        return
                    }
                    
                    do {
                        let objModalClass = try JSONDecoder().decode(modelClass!,from: data)
                        //print(objModalClass)
                        SuccessBlock(objModalClass)
                        responseServerErrorDict = [:]
                    } catch let error { //If model class parsing fail
                        FailureBlock(error)
                        self.alertOnTop(message: (error.localizedDescription))
                        print(error)
                    }
                }
                
            case .failure(let encodingError):
                FailureBlock(encodingError)
            }
        }
    }
    
    //MARK:- Custom API for exceptional case
    func callCustomAPIWithModalClass<T:Decodable>(modelClass:T.Type?, apiName:String, requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, SuccessBlock:@escaping (T) -> Void, FailureBlock:@escaping (Error)-> Void){
        
        do {
            let apiURL = "\(strBaseUrl)\(apiName)"
            let postData = try JSONSerialization.data(withJSONObject: paramValues ?? [], options: JSONSerialization.WritingOptions.prettyPrinted)
            
            var request = URLRequest(url: NSURL(string: apiURL)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
            request.httpMethod = requestType.rawValue
            request.allHTTPHeaderFields = headersValues
            request.httpBody = postData as Data
            
            print("\nAPI Endpoint: \(apiURL)\n Request:\(String(describing: paramValues))")
            
            Alamofire.request(request).responseData(completionHandler: { (response) in
                if((response.error) != nil){
                    //self.showToastMessage(title:(response.error?.localizedDescription)!)
                    self.alertOnTop(message: (response.error?.localizedDescription)!) //sam
                    FailureBlock(response.error!)
                }
                else{
                    guard let data = response.data else {
                        FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                        return
                    }
                    
                    //To display json redable format...
                    do {
                        
                        guard let jsonResult = try JSONSerialization.jsonObject(with: data, options:
                            JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary else{
                                return
                        }
                        
                        //Server Side error handling...
                        if let errorDict = jsonResult["errors"] as? [String: AnyObject]{
                            responseServerErrorDict = errorDict
                            print(responseServerErrorDict)
                            //print(responseServerErrorDict.keys)
                        }
                        //==========================
                        
                        print(jsonResult)
                    }catch let error{print(error)
                        //self.showToastMessage(title: msg_NoValidResponseInAPI)
                        self.alertOnTop(message: msg_NoValidResponseInAPI)
                    }
                    
                    //Model parsing...
                    do {
                        let objModalClass = try JSONDecoder().decode(modelClass!,from: data)
                        //print(objModalClass)
                        SuccessBlock(objModalClass)
                        responseServerErrorDict = [:]
                    } catch let error { //If model class parsing fail
                        
                        print(error)
                        logw(String(describing: error))
                        //self.showToastMessage(title: msg_NoValidResponseInAPI)
                        self.alertOnTop(message: msg_NoValidResponseInAPI) //sam
                        FailureBlock(error)
                    }
                }
            })
        } catch let error {
            print(error)
            logw(String(describing: error))
            //self.showToastMessage(title:(error.localizedDescription))
            self.alertOnTop(message: (error.localizedDescription)) //sam
            FailureBlock(error)
        }
    }
    
    //MARK: - Supporting Methods
    fileprivate func handleParseError(_ data: Data) -> Error{
        let error = NSError(domain:APIConstant.parseErrorDomain, code:APIConstant.parseErrorCode, userInfo:[ NSLocalizedDescriptionKey: APIConstant.parseErrorMessage])
        
        print(error.localizedDescription)
        logw(String(describing: error))
        //self.showToastMessage(title:(error.localizedDescription))
        self.alertOnTop(message: (error.localizedDescription)) //sam
        do { //To print response if parsing fail
            let response  = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(response)
        }catch{}
        
        return error
    }
    
    //MARK: - Get HeaderParameter Method
    func getAuthorizationValue(token:String,accessToken:String) -> String {
        let strAuthorization : String = token + " " + accessToken
        return strAuthorization
    }
    
    func getDeviceToken() -> String {
        let strDeviceToken : String = "XYZ"
        return strDeviceToken
    }
    
    func getDefaultHeadersParametersWithContentType(strContentType : String) -> Dictionary<String, String>{
        
        let dictHeader = NSMutableDictionary()                
        dictHeader.setValue(strContentType, forKey:APIConstant.content_type)
        if let autherizationToken = self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) as? String{
            dictHeader.setValue(autherizationToken, forKey: APIConstant.Authorization)

        }
        return dictHeader as! Dictionary<String, String>
    }
    
//    func getBasicAuthHeader(strContentType : String) -> Dictionary<String, String>{
//
//        let dictHeader = NSMutableDictionary()
//        dictHeader.setValue(strContentType, forKey:APIConstant.content_type)
//        dictHeader.setValue(BASIC_AUTH.getBasicAuthToken(), forKey: APIConstant.Authorization)
//
//        return dictHeader as! Dictionary<String, String>
//    }
}

extension NSObject{
    
    func alertOnTop(message:String?){
        let banner = NotificationBanner(title: "", subtitle: message, style: .danger)
        banner.show()
    }
    
    func alertOnTop(message:String?,style:BannerStyle){
        let banner = NotificationBanner(title: "", subtitle: message, style: style)
        banner.show()
    }
    
    func showToastMessage(title:String) {
        DispatchQueue.main.async {
            if let toastView = APPLICATION.appDelegate.window?.viewWithTag(2532515){
                toastView.removeFromSuperview()
            }
            
            var style: ToastStyle = ToastManager.shared.style            
            style.messageColor = UIColor.white
            style.backgroundColor = UIColor.black //themeToastMessage
            
            //APPLICATION.appDelegate.window?.rootViewController?.view.makeToast(title, duration: 1.5, position: .bottom)
            //APPLICATION.appDelegate.window?.rootViewController?.view.makeToast(title, duration: 2.5, position: .bottom, style: style)
            
            UIApplication.topViewController()?.view.makeToast(title, duration: 2.5, position: .bottom, style: style)
            ToastManager.shared.isTapToDismissEnabled = true
        }
    }
    
    func showToastMessage(title:String,view:UIView,position:ToastPosition) {
        DispatchQueue.main.async {
            
            if let toastView = APPLICATION.appDelegate.window?.viewWithTag(2532515){
                toastView.removeFromSuperview()
            }
            view.makeToast(title, duration: 2.5, position:position)
            ToastManager.shared.isTapToDismissEnabled = true
        }
    }
    
    func showToastMessage(title:String,view:UIView,position:ToastPosition,duration:TimeInterval) {
        DispatchQueue.main.async {
            
            if let toastView = APPLICATION.appDelegate.window?.viewWithTag(2532515){
                toastView.removeFromSuperview()
            }
            view.makeToast(title, duration: duration, position:position)
            ToastManager.shared.isTapToDismissEnabled = true
        }
    }
    
    
    fileprivate func handleServersideValidation(meta:Model_Meta?) {
        
        /*
        errors =     {
            "full_name" =         (
                "The full name format is invalid."
            );
        };
        */
        
        var strAlert = msg_NoValidResponseInAPI
        let msgMeta = (meta?.message) ?? ""
        if(!msgMeta.isEmpty){
            strAlert = msgMeta
        }
        
        var aryMessages = [String]()
        for keyName in responseServerErrorDict.keys{
            if let aryMsg = responseServerErrorDict[keyName] as? [String]{
                for strMsg in aryMsg{
                    if !strMsg.isEmpty{
                        aryMessages.append(strMsg)
                    }
                }
            }
        }
        
        if(aryMessages.count > 0){
            strAlert = aryMessages.joined(separator: ", ")
        }
                
        //showToastMessage(title:strAlert)
         alertOnTop(message: strAlert) //sam
    
    }
    
    func handleStatusCode(statusCode:Int,modelErrors:Model_Errors?,meta:Model_Meta?) -> Bool{
        
        var strAlert = ""
        
        if arySuccessCode.contains(statusCode) {
            return true
        }else if statusCode == STATUS_CODE.FAILED_401{
            
            Alert.shared.showAlertWithHandler(title: App_Name, message: STATUS_CODE_MSG.MSG_401, okButtonTitle: str_AlertTextOK) { (action) in
                //Redirect to Login screen
                logw(STATUS_CODE_MSG.MSG_401)
                self.hideLoader()
                GLOBAL.sharedInstance.logOutUserFromApp()
            }
            return false
        }
        /*
        else if statusCode == STATUS_CODE.FAILED_422{
            if meta?.message_code == "USER_ACCOUNT_PENDING"{
                showToastMessage(title:(meta?.message)!)
                
                /*
                 //Redirect to OTP screen
                 let vc = UIStoryboard.init(name:"MainUser", bundle: nil).instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
                 vc.strEmail = DefaultValue.shared.getStringValue(key: USERDEFAULTS_KEYS.email)
                 vc.isFromRegister = true
                 let navigation = APPLICATION.appDelegate.window?.rootViewController as? UINavigationController
                 navigation?.pushViewController(vc, animated: true)
                 */
                
            }
            else if meta?.message_code == "VALIDATION_ERROR"{
                handleServersideValidation(modelErrors)
            }
            else{
                showToastMessage(title:(meta?.message)!)
            }
            return false
        }
        */
        else if aryFailureCode.contains(statusCode){ //invoke if Server size valiation occurs
            handleServersideValidation(meta: meta)
            return false
        }
        else{
            strAlert = (meta?.message) ?? ""
            //showToastMessage(title:strAlert)
            alertOnTop(message: strAlert) //sam
            return false
        }
    }
    
    func handleStatusCodeBackground(statusCode:Int,modelErrors:Model_Errors?,meta:Model_Meta?) -> Bool{
        
        //var strAlert = ""
        
        if arySuccessCode.contains(statusCode) {
            return true
        }else if statusCode == STATUS_CODE.FAILED_401{
            
            Alert.shared.showAlertWithHandler(title: App_Name, message: STATUS_CODE_MSG.MSG_401, okButtonTitle: str_AlertTextOK) { (action) in
                //Redirect to Login screen
                logw(STATUS_CODE_MSG.MSG_401)
                self.hideLoader()
                GLOBAL.sharedInstance.logOutUserFromApp()
            }
            return false
        }
        else if aryFailureCode.contains(statusCode){ //invoke if Server size valiation occurs
            //handleServersideValidation(meta: meta)
            return false
        }
        else{
            //strAlert = (meta?.message) ?? ""
            //showToastMessage(title:strAlert)
            return false
        }
    }
    
    func handleStatusCodeForUsername(statusCode:Int,modelErrors:Model_Errors?,meta:Model_Meta?) -> Bool{
        
        var strAlert = ""
        
        if arySuccessCode.contains(statusCode) {
            return true
        }else if statusCode == STATUS_CODE.FAILED_401{
            
            Alert.shared.showAlertWithHandler(title: App_Name, message: STATUS_CODE_MSG.MSG_401, okButtonTitle: str_AlertTextOK) { (action) in
                //Redirect to Login screen
                logw(STATUS_CODE_MSG.MSG_401)
                self.hideLoader()
                GLOBAL.sharedInstance.logOutUserFromApp()
            }
            return false
        }
            /*
             else if statusCode == STATUS_CODE.FAILED_422{
             if meta?.message_code == "USER_ACCOUNT_PENDING"{
             showToastMessage(title:(meta?.message)!)
             
             /*
             //Redirect to OTP screen
             let vc = UIStoryboard.init(name:"MainUser", bundle: nil).instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
             vc.strEmail = DefaultValue.shared.getStringValue(key: USERDEFAULTS_KEYS.email)
             vc.isFromRegister = true
             let navigation = APPLICATION.appDelegate.window?.rootViewController as? UINavigationController
             navigation?.pushViewController(vc, animated: true)
             */
             
             }
             else if meta?.message_code == "VALIDATION_ERROR"{
             handleServersideValidation(modelErrors)
             }
             else{
             showToastMessage(title:(meta?.message)!)
             }
             return false
             }
             */
        else if aryFailureCode.contains(statusCode){ //invoke if Server size valiation occurs
            //handleServersideValidation(meta: meta)
            return false
        }
        else{
            strAlert = (meta?.message) ?? ""
            //showToastMessage(title:strAlert)
            alertOnTop(message: strAlert) //sam
            return false
        }
    }
}

import Foundation

public extension Data {
    var fileExtension: String {
        var values = [UInt8](repeating:0, count:1)
        self.copyBytes(to: &values, count: 1)
        
        let ext: String
        switch (values[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "png"
        }
        return ext
    }
}
