//
//  CreateNewPlaylistPopup.swift
//  TheWeedTube
//
//  Created by Sandip Patel on 06/03/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import UIKit

class CreateNewPlaylistPopup: UIView {
    
    @IBOutlet weak var btnPrivacy: UIControl!
    @IBOutlet weak var btnCreateNew: UIControl!
    @IBOutlet weak var btnCancel: UIControl!
    @IBOutlet weak var viewMain: UIButton!
    @IBOutlet weak var txtPlaylistName: TWTextFieldView!
    @IBOutlet weak var txtPrivacy: TWTextFieldView!
    
    var strSelectedVideoId = ""
    var strPlaylistUUID = ""
    var viewCategory = Bundle.loadView(fromNib:"CategoryView", withType: CategoryView.self)
    
    
    @IBAction func btnCloseTap(_ sender: Any){
        self.hidePopUp()
    }
    
    //MARK:- Common Method
    func hidePopUp(){
        self.endEditing(true)
        self.removeFromSuperviewWithAnimationCenter(animation: {
        }) {//Completion
        }
    }
    
    //MARK:- Action Methods
    @IBAction func btnPrivacyTap(){
        
        self.endEditing(true)
        
        self.viewCategory.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.viewCategory.strCategoryScreenTYPE = CategoryScreen_TYPE.LocalList
        self.viewCategory.aryLocalList = Cons_AryPrivacy
        self.viewCategory.handlerString = CompletionHandlerBlockString({(index,title,uuid) in
            print("\n title: \(title) , uuid: \(uuid) \n")
            
            self.txtPrivacy.txtField.text = title
        })
        self.viewCategory.setupData()
        
        self.viewCategory.addSubviewWithAnimationBottom(animation: {
        }) {//CompletionBlock
        }
    }
    
    @IBAction func btnCancelTap(){
        self.hidePopUp()
    }
    
    @IBAction func btnCreateNewTap(){
        self.endEditing(true)
        
        let playlistName = self.txtPlaylistName.txtField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let playlistType = self.txtPrivacy.txtField.text?.lowercased() ?? ""
        let playlistTypeValue = (playlistType == "private") ? "0" : "1" //0 - private, 1 - public
        
        if(playlistName.isEmpty){
            self.alertOnTop(message: msg_PlaylistName, style: .danger)
            return
        }
        
        GLOBAL.sharedInstance.callAddToPlaylistAPI(strPlaylistId: self.strPlaylistUUID, strVideoId: self.strSelectedVideoId, strPlaylistName: playlistName, strPlaylistType: playlistTypeValue, isFromCreate: true, isInMainThread: true, completionBlock: { (status, message) in
            
            self.removeFromSuperviewWithAnimationCenter(animation: {
            }) {//Completion
            }
            
            if(status){
                self.alertOnTop(message: message, style: .success)
            }
        })
        
//        GLOBAL.sharedInstance.callCreatePlaylistAPI(strPlaylistName: playlistName, strType: playlistTypeValue, isInMainThread: true, completionBlock: { (status, message) in
//
//            self.removeFromSuperviewWithAnimationCenter(animation: {
//            }) {//Completion
//
//                GLOBAL.sharedInstance.callGetUserPlaylistAPI(isInMainThread: true, completionBlock: { (status, message) in
//
//                    if(status){
//                        let viewAddToPlaylistPopup = Bundle.loadView(fromNib: "AddToPlaylistPopup", withType: AddToPlaylistPopup.self)
//                        viewAddToPlaylistPopup.frame = UIScreen.main.bounds
//                        viewAddToPlaylistPopup.viewMain.backgroundColor = .clear
//                        viewAddToPlaylistPopup.strSelectedVideoId = self.strSelectedVideoId
//                        viewAddToPlaylistPopup.addSubviewWithAnimationCenter(animation: {
//                        }) {//Completion
//
//                            if(GLOBAL.sharedInstance.arrayPlaylistData.count > 0){
//                                viewAddToPlaylistPopup.btnPlaylist.isUserInteractionEnabled = true
//                                viewAddToPlaylistPopup.btnAddToPlaylist.isUserInteractionEnabled = true
//                                viewAddToPlaylistPopup.btnAddToPlaylistLabel.textColor = UIColor.theme_green
//                                let modelPlaylistData = GLOBAL.sharedInstance.arrayPlaylistData[0]
//                                viewAddToPlaylistPopup.txtPlaylistName.txtField.text = modelPlaylistData.name ?? ""
//                                viewAddToPlaylistPopup.strPlaylistUUID = modelPlaylistData.uuid ?? ""
//                            }
//                            else{
//                                //self.alertOnTop(message: "No playlist found! Please create new playlist")
//                                viewAddToPlaylistPopup.btnPlaylist.isUserInteractionEnabled = false
//                                viewAddToPlaylistPopup.btnAddToPlaylist.isUserInteractionEnabled = false
//                                viewAddToPlaylistPopup.btnAddToPlaylistLabel.textColor = UIColor.textColor_gray
//                            }
//                            viewAddToPlaylistPopup.txtPrivacy.txtField.text = Cons_AryPrivacy[0]
//                        }
//                    }
//                })
//
//            }
//
//            if(status){
//                self.alertOnTop(message: message, style: .success)
//            }
//        })
    }
}
