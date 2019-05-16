//
//  NSObject+Extension.swift
//  Created by Sandip Patel (SM) on 19/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

import UIKit
//import SDWebImage
import SVProgressHUD
import Alamofire
//import AlamofireImage


extension NSObject {
    
    //MARK:- Shorten Syntex Constants
    var IS_IPAD : Bool{
        return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
    }    
    var SCREEN_WIDTH : CGFloat{
        return (UIScreen.main.bounds.size.width)
    }
    var SCREEN_HEIGHT : CGFloat{
        return (UIScreen.main.bounds.size.height)
    }
    
    //MARK:- Scalling factor for devices
    //Device Layout Reference Guide URL: http://iosres.com/
    var SCALE_W : CGFloat{
        return (SCREEN_WIDTH / 320) //iPhone Default base width = 320
    }
    var SCALE_W_IPAD : CGFloat{
        return (SCREEN_WIDTH / 1024) //iPad Default base width = 1024 (Landscape mode)
    }
    var SCALE_H : CGFloat{
        return (SCREEN_HEIGHT / 568) //iPhone Default base height = 568
    }
    
    //MARK:- Screen Center Constant
    var CENTER_X : CGFloat{
        return (SCREEN_WIDTH / 2)
    }
    var CENTER_Y : CGFloat{
        return (SCREEN_HEIGHT / 2)
    }
    
    var RATIO : CGFloat{
        return 0.8
    }
    
    func getPlaceholderImage(strImageName : String) -> UIImage{
        return UIImage.init(named: strImageName)!
    }
    
    //MARK:- Load Image with Activity Indicator
//    func loadImageWith(imgView: UIImageView, url: String?, strPlaceHolder: String) { //SMP: CONFIG SETUP
//
//        //With SDWebImage
//        ///*
//
//        imgView.sd_setShowActivityIndicatorView(true)
//        imgView.sd_setIndicatorStyle(UIActivityIndicatorView.Style.gray)
//        if url != nil {
//            imgView.sd_setImage(with: URL.init(string: url!), placeholderImage: self.getPlaceholderImage(strImageName: strPlaceHolder), options:SDWebImageOptions.scaleDownLargeImages, completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
//
//                if ((error) != nil) {
//                    imgView.image = self.getPlaceholderImage(strImageName: strPlaceHolder)
//                }
//                else{
//                    //imgView.image =  image?.af_imageAspectScaled(toFit: imgView.frame.size)
//
//                    ///* //SMP: Fix
//                    //Image scall down based on image size, not by imageView size...
//                    if(image == nil){
//                        return
//                    }
//                    let wMax = ((image?.size.width)! > imgView.frame.size.width) ? image?.size.width : imgView.frame.size.width
//                    let scalDownFactor = (imgView.frame.size.width / wMax!)
//                    imgView.image =  image?.af_imageAspectScaled(toFit: CGSize.init(width: (image?.size.width)! * scalDownFactor, height: (image?.size.height)! * scalDownFactor))
//                    //--------------------------------------------------------------
//                    //*/
//                }
//            })
//        }
//        else{
//            imgView.image = self.getPlaceholderImage(strImageName: strPlaceHolder)
//        }
//
//        //*/
//
//        //With AlamofireImage
//        /*
//         if url != nil {
//         imgView.af_setImage(withURL: URL.init(string: url!)!, placeholderImage: self.getPlaceholderImage())
//         }
//         else{
//         imgView.image = UIImage.init(named: "ic_placeholder")
//         }
//         */
//    }
    
//    func loadImageButtonWith(btnView: UIButton, url: String?, strPlaceHolder: String) { //SMP: CONFIG SETUP
//
//        //With SDWebImage
//        ///*
//        btnView.sd_setShowActivityIndicatorView(true)
//        btnView.sd_setIndicatorStyle(UIActivityIndicatorView.Style.gray)
//        if url != nil {
//
//            btnView.sd_setImage(with: URL(string: url!), for: .normal, placeholderImage: self.getPlaceholderImage(strImageName: strPlaceHolder), options: SDWebImageOptions.scaleDownLargeImages) { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
//                if ((error) != nil) {
//                    btnView.setImage(self.getPlaceholderImage(strImageName: strPlaceHolder), for: .normal)
//
//                } else {
//                    //imgView.image =  image?.af_imageAspectScaled(toFit: imgView.frame.size)
//
//                    ///* //SMP: Fix
//                    //Image scall down based on image size, not by imageView size...
//                    if(image == nil) { return }
//                    let wMax = ((image?.size.width)! > btnView.frame.size.width) ? image?.size.width : btnView.frame.size.width
//                    let scalDownFactor = (btnView.frame.size.width / wMax!)
//
//                    btnView.setImage(image?.af_imageAspectScaled(toFit: CGSize.init(width: (image?.size.width)! * scalDownFactor, height: (image?.size.height)! * scalDownFactor)), for: .normal)
//                    //--------------------------------------------------------------
//                    //*/
//                }
//            }
//        } else {
//            btnView.setImage(self.getPlaceholderImage(strImageName: strPlaceHolder), for: .normal)
//        }
//    }
    
    
    //MARK: - User Defaults as Array
    func setUserDefaultWithArray(_ ObjectToSave : [AnyObject]?  , KeyToSave : String)
    {
        let defaults = UserDefaults.standard
        
        if (ObjectToSave != nil)
        {
            
            defaults.set([ObjectToSave], forKey: KeyToSave)
        }
        else
        {
            defaults.removeObject(forKey: KeyToSave)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    //MARK: - User Defaults Save and Retrive Methods
    func setUserDefaultWithModelObject<T:Encodable>(modelClass:T.Type?, modelToSave : Any?, KeyToSave : String){
        
        let defaults = UserDefaults.standard
        if (modelToSave != nil){
            let data = try! JSONEncoder().encode(modelToSave as! T)
            defaults.set(data, forKey: KeyToSave)
        }
        else{
            defaults.removeObject(forKey: KeyToSave)
        }
        UserDefaults.standard.synchronize()
        
    }
    func getUserDefaultWithModelObject<T:Decodable>(modelClass:T.Type?, KeyToGetValue : String) -> AnyObject?{
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: KeyToGetValue){
            let modelData = try! JSONDecoder().decode(modelClass!, from: data)
            return modelData as AnyObject
        }
        return nil
    }
    
    func setUserDefault(_ ObjectToSave : Any?  , KeyToSave : String){
        
        let defaults = UserDefaults.standard
        if (ObjectToSave != nil){
            defaults.set(ObjectToSave, forKey: KeyToSave)
        }
        else{
            defaults.removeObject(forKey: KeyToSave)
        }
        UserDefaults.standard.synchronize()
    }
    
    func getUserDefault(_ KeyToGetValue : String) -> AnyObject?{
        
        let defaults = UserDefaults.standard
        if let name = defaults.value(forKey: KeyToGetValue){
            return name as AnyObject?
        }
        return nil
    }
    
    func clearAllUserDefaultStorage(){
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    //MARK: - Get Properties.plist Values
    func getInfoPlist(indexString:NSString) ->AnyObject{
        let path = Bundle.main.path(forResource: "Properties", ofType: "plist")
        let storedvalues = NSDictionary(contentsOfFile: path!)
        let response: AnyObject? = storedvalues?.object(forKey: indexString) as AnyObject
        return response!
    }
    
    func getAppVersionAndBuildNumber() -> String {
        
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "1.0"
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? "1.0"
        let versionAndBuildNumber = "Ver #\(versionNumber) ( Build #\(buildNumber) )"
        return versionAndBuildNumber
    }
    
    //MARK: - Show / Hide Loading Indicator
    func showLoader(){
        DispatchQueue.main.async {
            SVProgressHUD.show()
            SVProgressHUD.setMaxSupportedWindowLevel(UIWindow.Level.alert + 1)
            SVProgressHUD.setBackgroundColor(UIColor.white)
            SVProgressHUD.setForegroundColor(UIColor.theme_green)
            APPLICATION.appDelegate.window?.isUserInteractionEnabled = false
        }
    }
    func showLoader(progress:Float, status:String){
        DispatchQueue.main.async {
            SVProgressHUD.showProgress(progress, status: status)
            SVProgressHUD.setBackgroundColor(UIColor.white)
            SVProgressHUD.setForegroundColor(UIColor.theme_green)
            APPLICATION.appDelegate.window?.isUserInteractionEnabled = false
        }
    }
    func showLoadingIndicator(progress:Float, status:String){
        DispatchQueue.main.async {
            SVProgressHUD.showProgress(progress, status: status)
            SVProgressHUD.setBackgroundColor(UIColor.theme_green)
            SVProgressHUD.setBackgroundColor(UIColor.white)
            APPLICATION.appDelegate.window?.isUserInteractionEnabled = false
        }
    }
    func showLoader(status:String){
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: status)
            SVProgressHUD.setBackgroundColor(UIColor.white)
            SVProgressHUD.setForegroundColor(UIColor.theme_green)
            APPLICATION.appDelegate.window?.isUserInteractionEnabled = false
        }
    }
    func hideLoader(){
        DispatchQueue.main.async {
            APPLICATION.appDelegate.window?.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
        }
    }
    func shareProduct(strTitle: String, image : UIImage?, url : String , vc : UIViewController){
        
        //release
        return
        
        var aryShare = [Any]()
        if strTitle != ""{
            aryShare.append(strTitle)
        }
        if url != ""{
            aryShare.append(url)
        }
        if image != nil{
            aryShare.append(image as Any)
        }
        
        let activityViewController = UIActivityViewController(activityItems: aryShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc.view
        vc.present(activityViewController, animated: true, completion: nil)
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //MARK:- Profile Pic Method
    func verifyUrl(urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func setDefaultPic(strImg: String,imgView : UIImageView,strImgName : String){
        let profileURL = strImg
        if self.verifyUrl(urlString: profileURL){
            //imgAuther.frame = CGRect(x: 0.0, y: 0.0, width: viewUserProfile.frame.width, height: viewUserProfile.frame.height)
            loadImageWith(imgView: imgView, url: profileURL)
            imgView.contentMode = .scaleAspectFill
        }else{
            //imgAuther.frame = CGRect(x: 12.0, y: 12.0, width: viewUserProfile.frame.width-24.0, height: viewUserProfile.frame.height-24.0)
            imgView.image = UIImage(named: strImgName)
            imgView.contentMode = .scaleAspectFit
        }
    }
    
    //MARK:- Utility Methods
    func numberFormatterWithComma(num:Double, fractionDigits:Int) -> String { //String With $ and Comma grouping after three digits
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        let result = formatter.string(from: NSNumber(value: num))
        return result ?? ""
    }
    
    func removeNumberFormatter(strPrice:String) -> String { //Removing $ and Comma
        var strNewPrice = strPrice.replacingOccurrences(of: "$", with: "")
        strNewPrice = strNewPrice.replacingOccurrences(of: ",", with: "")
        return strNewPrice
    }
    
    func getDocumentsDirectory() -> URL {
        //        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //        return paths[0]
        
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath =  tDocumentDirectory.appendingPathComponent("CWAT_TEMP")
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    NSLog("Couldn't create folder in document directory")
                    NSLog("==> Document directory is: \(filePath)")
                    return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                }
            }
            
            NSLog("==> Document directory is: \(filePath)")
            return filePath
        }
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func clearAllFilesFromTempDirectory(){        
        let fileManager = FileManager.default
        do {
            let strTempPath = getDocumentsDirectory().path
            let filePaths = try fileManager.contentsOfDirectory(atPath: strTempPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: strTempPath + "/" + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    func indexPathForControl(_ sender:AnyObject, tableView: UITableView) -> IndexPath {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:tableView)
        let indexPath:IndexPath = tableView.indexPathForRow(at: buttonPosition)!
        return indexPath
    }
    
    //        func indexOfView(view:UIView, forView tableView:UITableView)->IndexPath{
    //            let pointInSuperView:CGPoint =  (view.superview?.convert(view.center, to: tableView))!
    //            let indexPath:IndexPath = tableView.indexPathForRow(at: pointInSuperView)!
    //            return indexPath
    //        }
    
    func getRole() -> String {
        let strRole : String = "USER"
        return strRole
    }
    func getCurrentTimeZone() -> String{
        //Asia/Kolkata  ==> iOS
        //Asia/Calcutta ==> Android
        let strTimeZone = String (TimeZone.current.identifier)
        if strTimeZone.lowercased().contains("Asia/Kolkata".lowercased()){  //Note: To make common for both iOS and Android...
            return "Asia/Calcutta"
        }
        return strTimeZone
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        let maxHeight: Float = 500.0
        let maxWidth: Float = 500.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 1.0
        //50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect.init(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
//        let imageData = UIImageJPEGRepresentation(img!,CGFloat(compressionQuality))
        let imageData = img?.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
    }
    
    func resizeImages(with image: UIImage, scaledTo newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
    
    func getMediaFileSize(filePath : String) -> Double {
        
        var fileSize : UInt64 = 0
        var fileSizeMB : Double = 0.0
        
        do {
            let attr : NSDictionary? = try FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary
            if let _attr = attr {
                fileSize = _attr.fileSize()
                fileSizeMB = Double(fileSize)/1024.0/1024.0
                
                print("fileSize ==> \(filePath) : BYTE - \(fileSize) ==> MB - \(fileSizeMB)")
            }
        } catch {
            print("Error: not able to get fileSize...")
        }
        
        return fileSizeMB
    }
    
}
