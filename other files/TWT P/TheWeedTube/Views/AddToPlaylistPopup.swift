//
//  AddToPlaylistPopup.swift
//  TheWeedTube
//
//  Created by Sandip Patel on 05/03/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import UIKit

class AddToPlaylistPopup: UIView {
    
    @IBOutlet weak var btnPlaylist: UIControl!
    @IBOutlet weak var btnPrivacy: UIControl!
    @IBOutlet weak var btnCreateNew: UIControl!
    @IBOutlet weak var btnAddToPlaylist: UIControl!
    @IBOutlet weak var btnAddToPlaylistLabel: UILabel!
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
        self.removeFromSuperviewWithAnimationCenter(animation: {
        }) {//Completion
        }
    }
    
    //MARK:- Action Methods
    @IBAction func btnPlaylistTap(){
        
        print("\(GLOBAL.sharedInstance.arrayPlaylistData)")
        
        //SMP:Change
        self.viewCategory.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.viewCategory.strCategoryScreenTYPE = CategoryScreen_TYPE.AddToPlaylist
        self.viewCategory.aryModelPlaylistData = GLOBAL.sharedInstance.arrayPlaylistData
        
        self.viewCategory.handlerString = CompletionHandlerBlockString({(index,title,uuid) in
            print("\n title: \(title) , uuid: \(uuid) \n")
            
            self.strPlaylistUUID = uuid
            self.txtPlaylistName.txtField.text = title
        })
        self.viewCategory.setupData()
        
        self.viewCategory.addSubviewWithAnimationBottom(animation: {
        }) {//CompletionBlock
        }
    }
    
    @IBAction func btnPrivacyTap(){
        
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
    
    @IBAction func btnAddToPlaylistTap(){
        
        GLOBAL.sharedInstance.callAddToPlaylistAPI(strPlaylistId: self.strPlaylistUUID, strVideoId: strSelectedVideoId, strPlaylistName: "", strPlaylistType: "", isFromCreate: false, isInMainThread: true, completionBlock: { (status, message) in
            
            self.removeFromSuperviewWithAnimationCenter(animation: {
            }) {//Completion
            }
            
            if(status){
                self.alertOnTop(message: message, style: .success)
            }
        })
    }
    
    @IBAction func btnCreateNewTap(){
        
        self.removeFromSuperviewWithAnimationCenter(animation: {
        }) {//Completion
            
            let viewCreateNewPlaylistPopup = Bundle.loadView(fromNib: "CreateNewPlaylistPopup", withType: CreateNewPlaylistPopup.self)
            viewCreateNewPlaylistPopup.frame = UIScreen.main.bounds
            viewCreateNewPlaylistPopup.viewMain.backgroundColor = .clear
            viewCreateNewPlaylistPopup.strSelectedVideoId = self.strSelectedVideoId
            viewCreateNewPlaylistPopup.addSubviewWithAnimationCenter(animation: {
            }) {//Completion
                viewCreateNewPlaylistPopup.txtPrivacy.txtField.text = Cons_AryPrivacy[0]
            }
        }
    }
}
