//
//  ReportActionSheet.swift
//  TheWeedTube
//
//  Created by Sandip Patel on 01/03/19.
//  Copyright © 2019 Brainvire. All rights reserved.
//

import UIKit

typealias CompletionHandler = (( _ index:Int, _ strStatus:String)->())?

struct PopUpType {
    static let ReportActionSheet = "ReportActionSheet"
    static let CommentListOwn = "CommentListOwn"
    static let CommentList = "CommentList"
    static let ReportOther = "ReportOther"
}

class ReportActionSheet: UIView {
    
    //Callback
    var handler: indexHandlerBlock!
    var handlerBlock : CompletionHandler!
    
    @IBOutlet weak var btnReport: UIControl!
    @IBOutlet weak var btnQuality: UIControl!
    @IBOutlet weak var imgQuality: UIImageView!
    @IBOutlet weak var lblQuality: UILabel!
    @IBOutlet weak var imgReport: UIImageView!
    @IBOutlet weak var lblReport: UILabel!
    @IBOutlet weak var viewMain: UIButton!
    @IBOutlet weak var conHeight: NSLayoutConstraint!
    
    var strPopUpTYPE = PopUpType.ReportActionSheet
    var strCommentId = String()
    
    var isFromProfile = String()
    
    //MARK:- UI Method
    func setupPopUpUI(){
        if self.strPopUpTYPE == PopUpType.ReportActionSheet{
            
            
            if isFromProfile.lowercased() == "yes"{
                conHeight.constant = 0.0
                imgReport.image = UIImage.init(named: "unblock")
                lblReport.text = "Unblock"
            }
            else if isFromProfile.lowercased() == "no"{
                conHeight.constant = 46.0
                
                imgReport.image = UIImage.init(named: "block")
                lblReport.text = "Block"
                
                imgQuality.image = UIImage.init(named: "quality_setting")
                lblQuality.text = "Report"
            }
            else{
                conHeight.constant = 0.0
                imgReport.image = UIImage.init(named: "report")
                lblReport.text = "Report"
            }
            
        }
        if self.strPopUpTYPE == PopUpType.CommentListOwn || self.strPopUpTYPE == PopUpType.CommentList{
            imgQuality.image = UIImage.init(named: "edit")
            lblQuality.text = "Edit"
            imgReport.image = UIImage.init(named: "delete")
            lblReport.text = "Delete"
            btnQuality.isHidden = true
        }
        else if self.strPopUpTYPE == PopUpType.ReportOther{
            conHeight.constant = 0
        }
    }
    
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
    @IBAction func btnReportTap(_ sender: UIControl){
       
        if self.strPopUpTYPE == PopUpType.CommentListOwn || self.strPopUpTYPE == PopUpType.CommentList{
            //Delete
            if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
                Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_message_Delete, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                    switch(index){
                    case 1:
                        self.redirctToLoginScreen()
                    default:
                        print("Cancel tapped")
                    }
                })
                if (handlerBlock != nil){
                    self.handlerBlock!(sender.tag,"")
                    self.hidePopUp()
                }
            }else{
                Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Comment_Delete, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                    switch(index){
                    case 1:
                        if self.strPopUpTYPE == PopUpType.CommentListOwn{
                            self.callDeleteCommentAPI(sender) // Delete 0th level comment
                        }
                        else if self.strPopUpTYPE == PopUpType.CommentList{
                            self.callReplyDeleteCommentAPI(sender)
                        }
                    default:
                        print("Cancel tapped")
                    }
                })
            }
        }else{
            //Report
            if(handler != nil){
                handler!(0)
                self.hidePopUp()
            }
        }
       
        
    }
    
    
    @IBAction func btnQualityTap(_ sender: UIControl){
        
       if self.strPopUpTYPE == PopUpType.CommentListOwn || self.strPopUpTYPE == PopUpType.CommentList{
            //Edit
        if (handlerBlock != nil){
            self.handlerBlock!(sender.tag,"")
            self.hidePopUp()
        }
        }else{
            //quality
            if(handler != nil){
                handler!(1)
                self.hidePopUp()
            }
        }
    }
    
    @IBAction func btnCancelTap(_ sender: UIControl){
        self.hidePopUp()
    }
    
    //MARK:- API Methods
    fileprivate func callDeleteCommentAPI(_ sender: UIControl) {
        //delete api call
        GLOBAL.sharedInstance.callDeleteCommentAPI(strCommentID: strCommentId, isInMainThread: true) { (status, message) in
            if(status){
                self.alertOnTop(message: message, style: .success)
                self.handlerBlock!(sender.tag,Cons_Success)
            }else{
                self.handlerBlock!(sender.tag,Cons_Fail)
            }
            self.hidePopUp()
        }
    }
    
    fileprivate func callReplyDeleteCommentAPI(_ sender: UIControl) {
        //reply delete api call
        GLOBAL.sharedInstance.callReplyDeleteCommentAPI(strCommentID: strCommentId, isInMainThread: true) { (status, message) in
            if(status){
                self.alertOnTop(message: message, style: .success)
                self.handlerBlock!(sender.tag,Cons_Success)
            }else{
                self.handlerBlock!(sender.tag,Cons_Fail)
            }
            self.hidePopUp()
        }
    }
    
}
