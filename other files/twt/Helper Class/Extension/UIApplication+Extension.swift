//
//  UIApplication+Extension.swift
//  Created by Sandip Patel (SM) on 19/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        return viewController
    }
    
    class func topNavigationController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UINavigationController? {
        
        if let nav = viewController as? UINavigationController {
            return nav
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return selected as? UINavigationController
            }
        }
        if let presented = viewController?.presentedViewController {
            return topNavigationController(presented)
        }
        
        
        return viewController?.navigationController
    }
}

struct APPLICATION {
    
    @available(iOS 9.0, *)
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let rootViewController = UIApplication.shared.keyWindow?.rootViewController
    let topVCForPresent = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController != nil ? UIApplication.shared.keyWindow?.rootViewController?.presentedViewController : UIApplication.shared.keyWindow?.rootViewController
    
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom  == .phone
    
    static var APP_STATUS_BAR_COLOR = UIColor(red: CGFloat(27.0/255.0), green: CGFloat(32.0/255.0), blue: CGFloat(42.0/255.0), alpha: 1)
    static var APP_NAVIGATION_BAR_COLOR = UIColor(red: CGFloat(41.0/255.0), green: CGFloat(48.0/255.0), blue: CGFloat(63.0/255.0), alpha: 1)
    static let applicationName = App_Name
    static let googleClientID = "1019988643660-gt0p5f235oi0qt244ebdplb7a68avn1t.apps.googleusercontent.com"
}
