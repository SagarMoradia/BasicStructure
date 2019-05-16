//
//  ParentNavigationController.swift
//  DELRentals
//
//  Created by Sweta Vani on 09/10/18.
//  Copyright © 2018 Sweta Vani. All rights reserved.
//

import UIKit
import SideMenu

class ParentNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        SideMenuManager.default.menuAddPanGestureToPresent(toView: navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: view)
        
        // Do any additional setup after loading the view.
        
        //self.navigationBar.barTintColor = UIColor.theme_gray_New
        self.navigationBar.tintColor = UIColor.white
        
        //self.navigationBar.isTranslucent = false
        
        var textAttributes = [NSAttributedString.Key : Any]()
        
        if Device.IS_IPHONE_5{
            textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                              NSAttributedString.Key.font:fontType.InterUI_Medium_16 as Any] as [NSAttributedString.Key : Any]
        }else{
            textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                              NSAttributedString.Key.font:fontType.InterUI_Medium_16 as Any] as [NSAttributedString.Key : Any]
        }
        self.navigationBar.titleTextAttributes = textAttributes
        
        UINavigationBar.appearance().shadowImage = UIImage()
        
        //Remove black 1 PX line from Navigation controller
        UINavigationBar.appearance().setBackgroundImage(UIImage(),for: .any,barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.hidesBarsOnSwipe = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public init(viewcontroller: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        
        if (viewcontroller != nil) {
            self.viewControllers = [viewcontroller!]
            
            var textAttributes = [NSAttributedString.Key : Any]()
            
            if Device.IS_IPHONE_5{
                textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                                  NSAttributedString.Key.font:fontType.InterUI_Medium_16 as Any] as [NSAttributedString.Key : Any]
            }else{
                textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                                  NSAttributedString.Key.font:fontType.InterUI_Medium_16 as Any] as [NSAttributedString.Key : Any]
            }
            
            
            //            let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,
            //                                  NSAttributedStringKey.font:fontType.large_bold as Any] as [NSAttributedStringKey : Any]
            self.navigationBar.titleTextAttributes = textAttributes
            
            //Remove black 1 PX line from Navigation controller
            UINavigationBar.appearance().setBackgroundImage(UIImage(),for: .any,barMetrics: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
            
        }
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
