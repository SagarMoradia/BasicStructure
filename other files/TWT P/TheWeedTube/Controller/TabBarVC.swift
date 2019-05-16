//
//  VendorTabBarVC.swift
//  DELRentals
//
//  Created by Sagar Moradia on 23/10/18.
//  Copyright © 2018 Sweta Vani. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate {

    //MARK:- Outlets Methods
    @IBOutlet weak var mainTabbar: UITabBar!
    var viewBottom = UIView()
    
    //MARK:- UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.addViewInTabbar()
    }
    
    //MARK:- TabBarController Delegate Methods
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let width = SCREEN_WIDTH/3
        let xPosition = CGFloat(tabBarController.selectedIndex) * width

        UIView.animate(withDuration: 0.25) {
            self.viewBottom.frame = CGRect(x: xPosition, y: self.viewBottom.frame.origin.y, width: width, height: 2.0)
        }
       
    }
    
    //MARK:- Helper Methods
    func addViewInTabbar() {
        let width = SCREEN_WIDTH/3
        viewBottom = UIView(frame: CGRect(x: 0, y: self.tabBar.frame.height - 2, width: width, height: 2.0))
        viewBottom.backgroundColor = UIColor.white
        self.tabBar.addSubview(viewBottom)
    }
}
