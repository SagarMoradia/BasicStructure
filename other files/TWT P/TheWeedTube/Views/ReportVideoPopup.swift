//
//  ReportVideoPopup.swift
//  TheWeedTube
//
//  Created by Sandip Patel on 01/03/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import UIKit

class ReportVideoPopup: UIView {
    
    
    @IBOutlet weak var textViewDescription: UITextView!{
        didSet {
            makeBorder(yourView: textViewDescription, cornerRadius: 5, borderWidth: 1.0, borderColor: UIColor.txtfieldBorder_gray, borderColorAlpha: 1.0)
        }
    }
    @IBOutlet weak var btnCategory: UIControl!
    @IBOutlet weak var btnReport: UIControl!
    @IBOutlet weak var viewMain: UIButton!
    @IBOutlet weak var txtCategory: TWTextFieldView!
    
    var isFromProfile = Bool()
    var strSelectedVideoId = ""
    var strUserId = ""
    var strReportCategoryUUID = ""
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
    @IBAction func btnReportCategoryTap(){
        
        print("\(GLOBAL.sharedInstance.arrayReportCategoryData)")
        
        //SMP:Change
        self.viewCategory.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.viewCategory.strCategoryScreenTYPE = CategoryScreen_TYPE.ReportCategory
        self.viewCategory.aryModelReportCategorylist = GLOBAL.sharedInstance.arrayReportCategoryData
        self.viewCategory.handlerString = CompletionHandlerBlockString({(index,title,uuid) in
            print("\n title: \(title) , uuid: \(uuid) \n")
            
            self.strReportCategoryUUID = uuid
            self.txtCategory.txtField.text = title
        })
        self.viewCategory.setupData()
        
        self.viewCategory.addSubviewWithAnimationBottom(animation: {
        }) {//CompletionBlock
        }
    }
    
    @IBAction func btnReportTap(){
        if self.textViewDescription.text != ""{
            
            if self.isFromProfile{
                GLOBAL.sharedInstance.callReportUserAPI(strCategoryId: strReportCategoryUUID, strUserId: strUserId, strDescription: self.textViewDescription.text ?? "", isInMainThread: true, completionBlock: { (status, message) in
                    
                    self.removeFromSuperviewWithAnimationCenter(animation: {
                    }) {//Completion
                        print("Reported Complete")
                    }
                    
                    if(status){
                        self.alertOnTop(message: message, style: .success)
                    }
                })
            }
            else{
                GLOBAL.sharedInstance.callAddReportAPI(strCategoryId: strReportCategoryUUID, strVideoId: strSelectedVideoId, strDescription: self.textViewDescription.text ?? "", isInMainThread: true, completionBlock: { (status, message) in
                    
                    self.removeFromSuperviewWithAnimationCenter(animation: {
                    }) {//Completion
                    }
                    
                    if(status){
                        self.alertOnTop(message: message, style: .success)
                    }
                })
            }
            
        }else{
            Alert.shared.showAlert(title: App_Name, message: msg_Description)
        }
       
    }
}
