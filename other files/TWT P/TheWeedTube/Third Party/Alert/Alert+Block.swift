//
//  Alert+Block.swift
//  Created by Sandip Patel (SM) on 19/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

import Foundation
import UIKit
import NotificationBannerSwift

enum AlertAction{
    case Ok
    case Cancel
}

typealias AlertCompletionHandler = ((_ index:AlertAction)->())?
typealias AlertCompletionHandlerInt = ((_ index:Int)->())

class Alert{
    
    private var alertWindow: UIWindow
    static var shared = Alert()
    
    init() {
        alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.isHidden = true
    }
    
    //MARK: - Single button with default titles (OK) , without handler block
    func showAlert(title:String?, message:String?){
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: str_AlertTextOK, style:.default, handler:{(alert) in
                self.alertWindow.isHidden = true
            }))
            self.alertWindow.isHidden = false
            self.alertWindow.rootViewController?.present(alert, animated: false)
        }
    }
    
    //MARK: - Two buttons with default titles (OK , CANCEL)
    func showAlertWithHandler(title:String?, message:String?, handler:AlertCompletionHandler){
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
            alert.addAction(UIAlertAction(title:str_AlertTextOK, style:.default, handler: { (alert) in
                self.alertWindow.isHidden = true
                handler?(AlertAction.Ok)
            }))
            
            alert.addAction(UIAlertAction(title:str_AlertTextCANCEL, style:.default, handler: { (alert) in
                self.alertWindow.isHidden = true
                handler?(AlertAction.Cancel)
            }))
            
            self.alertWindow.isHidden = false
            self.alertWindow.rootViewController?.present(alert, animated: false)
        }
    }
    
    //MARK: - Single button with custom titles
    func showAlertWithHandler(title:String?, message:String?, okButtonTitle:String, handler:AlertCompletionHandler){
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
            alert.addAction(UIAlertAction(title:okButtonTitle, style:.default, handler: { (alert) in
                self.alertWindow.isHidden = true
                handler?(AlertAction.Ok)
            }))
            
            self.alertWindow.isHidden = false
            self.alertWindow.rootViewController?.present(alert, animated: false)
        }
    }
    
    //MARK: - Two buttons with custom titles
    func showAlertWithHandler(title:String?, message:String?, okButtonTitle:String, cancelButtionTitle:String,handler:AlertCompletionHandler){
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
            alert.addAction(UIAlertAction(title:okButtonTitle, style:.default, handler: { (alert) in
                self.alertWindow.isHidden = true
                handler?(AlertAction.Ok)
            }))
            
            alert.addAction(UIAlertAction(title:cancelButtionTitle, style:.default, handler: { (alert) in
                self.alertWindow.isHidden = true
                handler?(AlertAction.Cancel)
            }))
            
            self.alertWindow.isHidden = false
            self.alertWindow.rootViewController?.present(alert, animated: false)
        }
    }
    
    //MARK: - Multiple buttons with custom titles
    func showAlertWithHandler(title:String?, message:String?, buttonsTitles:[String], showAsActionSheet: Bool,handler:@escaping AlertCompletionHandlerInt){
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title:title, message: message, preferredStyle: (showAsActionSheet ?.actionSheet : .alert))
            
            for btnTitle in buttonsTitles{
                alert.addAction(UIAlertAction(title:btnTitle, style:.default, handler: { (alert) in
                    self.alertWindow.isHidden = true
                    handler(buttonsTitles.index(of: btnTitle)!)
                }))
            }
            
            //let topVC = UIApplication.topViewController()
            //topVC?.present(alert, animated: true)
            self.alertWindow.isHidden = false
            self.alertWindow.rootViewController?.present(alert, animated: false)
        }
    }
    
    func showAlertWithHandler(title:String?, message:String?, buttonsTitles:[String], showAsActionSheet: Bool,handler:@escaping AlertCompletionHandlerInt,tagValue:Int){
        
        DispatchQueue.main.async {
            
            
        }
        let topVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
//
//        let title = """
//"""
        
        let alert = UIAlertController(title:title, message: message, preferredStyle: (showAsActionSheet ?.actionSheet : .alert))
        
        alert.customID = tagValue
        
        print("Alert Frame : ", alert.view.frame)
        
        let imgvLogo = UIImageView(frame: CGRect.init(x: 105.0, y: 10.0, width: 64.0, height: 64.0)) //(UIScreen.main.bounds.width/2)-32 //(alert.view.frame.width/3)-21
        print("Logo Frame : ", imgvLogo.frame)
        imgvLogo.image = UIImage(named: "Logo")
        //alert.view.addSubview(imgvLogo)
        
        for btnTitle in buttonsTitles{
            alert.addAction(UIAlertAction(title:btnTitle, style:.default, handler: { (alert) in
                handler(buttonsTitles.index(of: btnTitle)!)
            }))
        }
        
        self.alertWindow.isHidden = false
        self.alertWindow.rootViewController?.present(alert, animated: false)
    }
    
    func alertOnTop(message:String?){
        let banner = NotificationBanner(title: "", subtitle: message, style: .danger)
        banner.show()
    }
}


