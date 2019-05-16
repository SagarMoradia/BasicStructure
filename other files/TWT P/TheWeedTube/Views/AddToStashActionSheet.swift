//
//  AddToStashActionSheet.swift
//  TheWeedTube
//
//  Created by Vivek Bhoraniya on 15/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

struct AddToStash_TYPE{
    static let Home = "Home"
    static let MyStash = "MyStash"
    static let VideoDetail = "VideoDetail"
    static let VideoDetailPlaylist = "VideoDetailPlaylist"
    static let Users = "Users"
    static let Profile = "Profile"
    static let CategoryDetail = "CategoryDetail"
    static let Search = "Search"
}

class AddToStashActionSheet: UIView {
    
    //Callback
    var handler: indexHandlerBlock!
    //var handlerBlock : CompletionHandler!
    var strSelectedVideoId = ""
    var selectedVideo: videoListData!
    
    var isForOwnProfile = Bool()
    
    var strAddToStashType = AddToStash_TYPE.Home
    
    @IBOutlet weak var btnStash: UIControl!
    @IBOutlet weak var btnAddToPlayList: UIControl!
    @IBOutlet weak var btnShare: UIControl!
    @IBOutlet weak var viewMain: UIButton!
    @IBOutlet weak var lblStash: UILabel!
    @IBOutlet weak var imgStash: UIImageView!
    @IBOutlet weak var imgvPlaylist: UIImageView!
    @IBOutlet weak var lblPlaylist: UILabel!
    @IBOutlet weak var conHeight: NSLayoutConstraint!
    @IBOutlet weak var conPlaylistHeight: NSLayoutConstraint!
    
    //MARK:- UI Method
    func setupUI(){
        if self.strAddToStashType == AddToStash_TYPE.MyStash{
            lblStash.text = Cons_Remove_Stash
            conPlaylistHeight.constant = 0
        }else if self.strAddToStashType == AddToStash_TYPE.Profile{
            if isForOwnProfile{
                lblStash.text = Cons_Edit
                imgStash.image = UIImage(named: "edit_video")
                
                lblPlaylist.text = Cons_Delete
                imgvPlaylist.image = UIImage(named: "Delete_video")
            }
        }
        else if self.strAddToStashType == AddToStash_TYPE.VideoDetail{
            conHeight.constant = 0
        }
    }
    
    //MARK:- Hide Method
    @IBAction func btnCloseTap(_ sender: Any){
        self.hidePopUp()
    }
    
    
    //MARK:- Common Method
    func hidePopUp(){
        //SMP:Change
        //self.viewMain.backgroundColor = .clear
        self.removeFromSuperviewWithAnimationBottom(animation: {            
        }) {//Completion
        }
    }
    
    //MARK:- Stash Actionsheet Methods
    @IBAction func btnStashTap(_ sender:UIControl){
        
        if(self.handler != nil){
            self.handler!(0)
            self.hidePopUp()
        }
        
//        if self.isForOwnProfile{
//            if(self.handlerBlock != nil){
//                self.handlerBlock!(0,"")
//                self.hidePopUp()
//            }
//        }else{
//
//        }
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Subscribe_stash, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.redirctToLoginScreen()
                default:
                    print("Cancel tapped")
                }
            })
        }else{
            
            if self.isForOwnProfile{
                print("Redirect to Video upload screen")
                //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                self.hidePopUp()
                let controller = UIStoryboard.init(name: ("Main_R1"), bundle: nil).instantiateViewController(withIdentifier: "UploadVideoStep2VC") as! UploadVideoStep2VC
                controller.selectedVideoForEdit = self.selectedVideo
                controller.isFromEdit = true
                let topNavigationVC = UIApplication.topViewController()
                topNavigationVC?.navigationController?.pushViewController(controller, animated: true)
                
            }else{
                if self.strAddToStashType == AddToStash_TYPE.MyStash{
                    //Remove from stash api call
                    print("Remove from stash api call")
                }else{
                    GLOBAL.sharedInstance.callAddToStashAPI(strUserId: "", strVideoId: self.strSelectedVideoId, isInMainThread: true, completionBlock: { (status, message) in
                        
                        if(status){
                            self.alertOnTop(message: message, style: .success)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func btnAddToPlayListTap(_ sender:UIControl){
        
        if(self.handler != nil){
            self.handler!(1)
            self.hidePopUp()
        }
        
//        if self.isForOwnProfile{
//            if(self.handlerBlock != nil){
//                self.handlerBlock!(1,"")
//                self.hidePopUp()
//            }
//        }else{
//
//        }
        
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Subscribe_playlist, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.redirctToLoginScreen()
                default:
                    print("Cancel tapped")
                }
            })
        }else{
            
            if self.isForOwnProfile{
                //Alert.shared.showAlert(title: App_Name, message: Cons_In_Progress)
                
//                Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Delete_Video_message, buttonsTitles: [Cons_No, Cons_Yes], showAsActionSheet: false, handler: { (index) in
//                    switch(index){
//                    case 1:
//                        print("Call Delete API")
//                    default:
//                        print("Cancel tapped")
//                        self.hidePopUp()
//                    }
//                })
            }else{
                GLOBAL.sharedInstance.callGetUserPlaylistAPI(isInMainThread: true, completionBlock: { (status, message) in
                    
                    if(status){
                        let viewAddToPlaylistPopup = Bundle.loadView(fromNib: "AddToPlaylistPopup", withType: AddToPlaylistPopup.self)
                        viewAddToPlaylistPopup.frame = UIScreen.main.bounds
                        viewAddToPlaylistPopup.viewMain.backgroundColor = .clear
                        viewAddToPlaylistPopup.strSelectedVideoId = self.strSelectedVideoId
                        viewAddToPlaylistPopup.addSubviewWithAnimationCenter(animation: {
                        }) {//Completion
                            
                            if(GLOBAL.sharedInstance.arrayPlaylistData.count > 0){
                                viewAddToPlaylistPopup.btnPlaylist.isUserInteractionEnabled = true
                                viewAddToPlaylistPopup.btnAddToPlaylist.isUserInteractionEnabled = true
                                viewAddToPlaylistPopup.btnAddToPlaylistLabel.textColor = UIColor.theme_green
                                let modelPlaylistData = GLOBAL.sharedInstance.arrayPlaylistData[0]
                                viewAddToPlaylistPopup.txtPlaylistName.txtField.text = modelPlaylistData.name ?? ""
                                viewAddToPlaylistPopup.strPlaylistUUID = modelPlaylistData.uuid ?? ""
                            }
                            else{
                                //self.alertOnTop(message: "No playlist found! Please create new playlist")
                                viewAddToPlaylistPopup.btnPlaylist.isUserInteractionEnabled = false
                                viewAddToPlaylistPopup.btnAddToPlaylist.isUserInteractionEnabled = false
                                viewAddToPlaylistPopup.btnAddToPlaylistLabel.textColor = UIColor.textColor_gray
                            }
                            viewAddToPlaylistPopup.txtPrivacy.txtField.text = Cons_AryPrivacy[0]
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func btnShareTap(){

        if(self.handler != nil){
            self.handler!(1)
            self.hidePopUp()
        }
        
        GLOBAL.sharedInstance.openSharingIndicator(url: Share_Url) {
        }

//        if self.isForOwnProfile{
//
//            if(self.handlerBlock != nil){
//                self.handlerBlock!(1,"")
//                self.hidePopUp()
//            }
//        }else{
//
//        }
    }
    
    @IBAction func btnCancelTap(_ sender: UIControl){
        self.hidePopUp()
    }
    
}
