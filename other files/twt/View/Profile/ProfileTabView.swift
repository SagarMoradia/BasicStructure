//
//  ProfileTabView.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 15/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class ProfileTabView: UIView {

    @IBOutlet weak var ctrlVideos: UIControl!
    @IBOutlet weak var ctrlPlayList: UIControl!
    @IBOutlet weak var ctrlAbout: UIControl!
    @IBOutlet weak var ctrlFilter: UIControl!
    @IBOutlet weak var lblSelectedFilter: UILabel!
    @IBOutlet weak var selectedTabView : UIView!
    
    var currentPage = 0
    
    //MARK: - Event Methods
    @IBAction func btnTabChanged(_ sender: UIControl) {
        
//        if currentPage == sender.tag - 2000{
//            return
//        }
//
//        let lblOld = self.viewWithTag(1000+currentPage) as! UILabel
//        lblOld.font = fontType.InterUI_Medium_13
//        lblOld.textColor = UIColor.textColor_black_unselected
//
//        currentPage = sender.tag - 2000
////
////        if currentPage == 0{
////            print("\n---------------About Tab-------------\n")
////            viewAbout.isHidden    = false
////            viewVideos.isHidden   = true
////            viewPlaylist.isHidden = true
////
////        }else if currentPage == 1{
////            print("\n---------------Videos Tab-------------\n")
////            viewAbout.isHidden    = true
////            viewVideos.isHidden   = false
////            viewPlaylist.isHidden = true
////
////        }else if currentPage == 2{
////            print("\n---------------Bill Tab-------------\n")
////            viewAbout.isHidden    = true
////            viewVideos.isHidden   = true
////            viewPlaylist.isHidden = false
////
////        }
////
//        let lblNew = self.viewWithTag(1000+currentPage) as! UILabel
//        lblNew.font = fontType.InterUI_Medium_13
//        lblNew.textColor = UIColor.theme_green
//
//        UIView.animate(withDuration: 0.25) {
//            self.selectedTabView.frame = CGRect(x: sender.frame.minX, y: self.selectedTabView.frame.minY, width: sender.frame.width, height: self.selectedTabView.frame.height)
//        }
        
    }
}
