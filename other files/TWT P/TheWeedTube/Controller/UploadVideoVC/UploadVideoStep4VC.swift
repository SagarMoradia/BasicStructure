//
//  UploadVideoStep4VC.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 27/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class UploadVideoStep4VC: ParentVC {
    
    //MARK: - Outlets
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var lblUpdateMsg: UILabel!
    
    var isFromEdit = Bool()
    var videoUuid = String()
    var msgSuccess = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        addRadius(button: btnVideo)
        
        if isFromEdit{
            self.btnVideo.isHidden = false
            //lblUpdateMsg.text = "Your video has been updated successfully"
        }else{
            self.btnVideo.isHidden = true
            //lblUpdateMsg.text = "Your video has been successfully uploaded"
        }
        
        lblUpdateMsg.text = msgSuccess
    }
    
}

//MARK: - Button Event Methods
extension UploadVideoStep4VC{
    @IBAction func actionHome (_ sender : UIButton){
       self.redirectToHomeScreen()
    }
    
    @IBAction func actionSeeTheVideo (_ sender : UIButton){
        //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
        let vcDetail = self.MAKE_STORY_OBJ_TABBAR(Identifier: "VideoDetailVC") as! VideoDetailVC
        vcDetail.strSelectedVideoId = self.videoUuid
        vcDetail.isFromPlaylist = false
//        self.navigationController?.present(vcDetail, animated: true, completion: nil)
        self.pushVCWithPresentAnimation(controller: vcDetail)
    }
}
