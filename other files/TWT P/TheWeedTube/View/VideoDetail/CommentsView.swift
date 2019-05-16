//
//  CommentsView.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 12/03/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

typealias CompletionHandlerBlockComment = (( _ index:Int, _ strTitle:String, _ propertyId:Int)->())?

class CommentsView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    //MARK: - Outlets Methods
    @IBOutlet weak var tblViewComments: UITableView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    
    var modelCommentListingData : Model_CommentListingData? = nil
    var aryVideoComments = [Model_CommentListingData]()
    var isFromComment = Bool()
    var isFromCommentListing = Bool()
    var isAllReplyLoaded = Bool()
    
    //MARK: - Properties Methods
    //Callback
    var handler: CompletionHandlerBlockComment!
    var handlerComment: indexHandlerBlock!
    var indexForClose = -1
    
    //Callback
    var handlerReport: indexHandlerBlock!
    
    //For pop up
    var viewKeyboard = Bundle.loadView(fromNib:"KeyboardView", withType: KeyboardView.self)
    var strUsername = String()
    
    
    override func draw(_ rect: CGRect) {
        
    }
    
    override func awakeFromNib() {
        tblViewComments.register(UINib.init(nibName: "VideoCommentCell", bundle: nil), forCellReuseIdentifier: "VideoCommentCell")
        tblViewComments.register(UINib.init(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tblViewComments.tableFooterView = UIView()
        
        self.setupPagination()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    

    //MARK: - UI Methods
    func setupUI(){
        
        isAllReplyLoaded = false
        self.aryVideoComments = [Model_CommentListingData]()
        self.callGetVideoCommentsReplyListAPI(inMainthread: true)
    }
    
    fileprivate func setupPagination() {
        
        tblViewComments.addInfiniteScroll { [weak self] (tableView) -> Void in
            guard let tempSelf = self else{
                return
            }
            tempSelf.callGetVideoCommentsReplyListAPI(inMainthread: false)
        }
        
        tblViewComments.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return !self.isAllReplyLoaded
        }
    }
    
    func setUpKeyboard(sender:UIButton,_ txtComment: String, _ intKeyboardValue: Int)  {
        self.viewKeyboard.handler = CompletionHandlerKeyboard({(index,title) in
            print("\n title: \(title)")

            if index == KeyboardEvent.AddReply.rawValue{ //add comment
                //send button

                if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
                    Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Subscribe_Comment, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                        switch(index){
                        case 1:
                            self.redirctToLoginScreen()
                        default:
                            print("Cancel tapped")
                        }
                    })
                }else{
                    GLOBAL.sharedInstance.callVideoAddCommentReplyAPI(strCommentUUID: self.modelCommentListingData?.comment_uuid ?? "", strComment: title, isInMainThread: true,completionBlock: { (status, message, modelComment) in
                        
                        
                        if(status && modelComment != nil){
                            self.alertOnTop(message: message, style: .success)
                            //Updating cell after successful api call...
                            //self.aryVideoComments.append(modelComment!)
                            self.aryVideoComments.insert(modelComment!, at: 0)
                            self.tblViewComments.reloadData()
                            
                            var replyCount = Int(self.modelCommentListingData?.reply_count ?? "0")!
                            replyCount = replyCount + 1
                            self.modelCommentListingData?.reply_count = String(replyCount)
                            //-----------------------------------------
                        }
                    })
                    
                }
            }
            else if index == KeyboardEvent.EditReply.rawValue{//Edit comment
                let indexPath = self.indexPathForControl(sender, tableView: self.tblViewComments)
                var strCommentId = ""
                var strComment = ""
                if indexPath.section == 0{
                     strCommentId = self.modelCommentListingData?.comment_uuid ?? ""
                     strComment = self.viewKeyboard.txtReply.text ?? ""
                }else{
                    strCommentId = self.aryVideoComments[indexPath.row].reply_uuid ?? ""
                    strComment = self.viewKeyboard.txtReply.text ?? ""
                }
                
                GLOBAL.sharedInstance.callEditCommentAPI(strCommentID: strCommentId, strComment: strComment, isInMainThread: true,completionBlock: { (status, message,modelComment) in
                    
                    if(status){
                        self.alertOnTop(message: message, style: .success)
                        //Updating cell after successful api call...
                        //self.aryVideoComments.insert(modelComment!, at: 0)
                        
                        if indexPath.section == 0{
                            self.modelCommentListingData?.comment = strComment
                        }else{
                            self.aryVideoComments[indexPath.row].comment = strComment
                        }
                        
                        self.tblViewComments.reloadData()
                        //-----------------------------------------
                    }
                })
            }
            
            
            self.viewKeyboard.txtReply.text = ""
            self.viewKeyboard.cntrlSend.isHidden = true
        })

        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewKeyboard.frame = UIScreen.main.bounds
            self.viewKeyboard.keyboardEventVal = KeyboardEvent(rawValue: intKeyboardValue)!
            let keyboardType = KeyboardEvent(rawValue: intKeyboardValue)!
            if keyboardType.rawValue == KeyboardEvent.AddReply.rawValue{
                self.viewKeyboard.txtReply.placeholder = txt_Add_Reply
            }else{
                self.viewKeyboard.txtReply.text = txtComment + " "
            }
            self.viewKeyboard.setKeyboard()
            UIApplication.shared.keyWindow?.addSubview(self.viewKeyboard)
        }) { (result : Bool) in
            if self.isFromComment{
                self.isFromComment = false
                //for username display
                if self.strUsername != ""{
                    //self.viewKeyboard.txtReply.text = self.strUsername + " "
                }
            }else{
                self.isFromComment = true
            }
        }
    }
    
    //MARK: - Tableview datasource delegate  Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
             return 1
        }
       return self.aryVideoComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            cell.modelCommentListingData = self.modelCommentListingData
            
            cell.btnCommentMore.tag = indexPath.row
            cell.btnCommentReply.tag = indexPath.row
            cell.cntrlProfile.addTarget(self, action: #selector(btnMainProfileTap(sender:)), for:.touchUpInside)
            cell.btnCommentLike.addTarget(self, action: #selector(btnCommentLikeTap(sender:)), for:.touchUpInside)
            cell.btnCommentDisLike.addTarget(self, action: #selector(btnCommentDisLikeTap(sender:)), for:.touchUpInside)
            cell.btnCommentMore.addTarget(self, action: #selector(btnMoreTap(sender:)), for: .touchUpInside)
            cell.btnReply.addTarget(self, action: #selector(btnKeyboardTap(sender:)), for: .touchUpInside)
            cell.btnCommentReply.addTarget(self, action: #selector(btnCommentTap(sender:)), for: .touchUpInside)
            
            cell.textLabel?.backgroundColor = UIColor.clear
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCommentCell", for: indexPath) as! VideoCommentCell
        cell.modelCommentListingData = self.aryVideoComments[indexPath.row]
        
        cell.btnCommentLike.addTarget(self, action: #selector(btnCommentLikeTap(sender:)), for:.touchUpInside)
        cell.btnCommentDisLike.addTarget(self, action: #selector(btnCommentDisLikeTap(sender:)), for:.touchUpInside)
        cell.btnCommentMore.addTarget(self, action: #selector(btnMoreTap(sender:)), for: .touchUpInside)
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.conHeightReply.constant = 0
        cell.btnCommentReply.isHidden = true
        cell.btnCommentMore.tag = indexPath.row
        cell.cntrlProfile.tag = indexPath.row
        cell.cntrlProfile.addTarget(self, action: #selector(btnProfileTap(sender:)), for:.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func btnMainProfileTap(sender:UIControl){
        let objCmnt = self.modelCommentListingData
        let strUserUUID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID)
        let strUserID = objCmnt!.user_uuid ?? ""
        if strUserUUID != nil{
            //not allowed for own profile
            if strUserID != ""{ //(strUserUUID as! String) != strUserID &&
                if strUserID == (strUserUUID as! String){
                    self.redirectToProfileScreen(isForOwn: true, strUserID: strUserID)
                }
                else{
                    self.redirectToProfileScreen(isForOwn: false, strUserID: strUserID)
                }
            }
        }else{
            if strUserID != ""{
                self.redirectToProfileScreen(isForOwn: false, strUserID: strUserID)
            }
        }
    }
    @objc func btnProfileTap(sender:UIControl){
        let objCmnt = self.aryVideoComments[sender.tag]
        let strUserUUID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID)
        let strUserID = objCmnt.user_uuid ?? ""
        if strUserUUID != nil{
            //not allowed for own profile
            if strUserID != ""{ //(strUserUUID as! String) != strUserID &&
                if strUserID == (strUserUUID as! String){
                    self.redirectToProfileScreen(isForOwn: true, strUserID: strUserID)
                }
                else{
                    self.redirectToProfileScreen(isForOwn: false, strUserID: strUserID)
                }
            }
        }else{
            if strUserID != ""{
                self.redirectToProfileScreen(isForOwn: false, strUserID: strUserID)
            }
        }
    }
    func redirectToProfileScreen(isForOwn: Bool,strUserID:String){
        let viewController = UIStoryboard.init(name: ("Main"), bundle: nil).instantiateViewController(withIdentifier: "ProfileMainVC") as! ProfileMainVC
        viewController.hidesBottomBarWhenPushed = true
        viewController.user_uuid = strUserID
        viewController.isForOwnProfile = isForOwn
        let topNavigationVC = UIApplication.topViewController()
        topNavigationVC?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Button Event Methods
    @IBAction func actionHide(_ sender:UIControl){
        //Hide with animation
        
        self.isFromComment = false
        
        if(handler != nil){
            handler!(indexForClose,"close pressed",0) //To reload previous screen data...
        }
        
        UIView.animate(withDuration: 0.6, animations: {
            self.frame = CGRect.init(x: 0, y: 2000, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (result : Bool) in
            self.removeFromSuperview()
        }
    }
    
    //MARK:- Comment List Section Event
    @objc func btnCommentLikeTap(sender:UIControl){
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Subscribe_Like, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.redirctToLoginScreen()
                default:
                    print("Cancel tapped")
                }
            })
        }else{
            let indexPath = self.indexPathForControl(sender, tableView: self.tblViewComments)
            
            let modelCommentListingData : Model_CommentListingData?
            var strApiName = ""
            var strCommentUUID = String()
            if(indexPath.section == 0){
                modelCommentListingData = self.modelCommentListingData
                strApiName = APIName.VideoCommentLikeUnlike
                strCommentUUID = modelCommentListingData?.comment_uuid ?? ""
            }
            else{
                modelCommentListingData = self.aryVideoComments[indexPath.row]
                strApiName = APIName.VideoReplyCommentLikeUnlike
                strCommentUUID = modelCommentListingData?.comment_uuid ?? ""
                if strCommentUUID == ""{
                    strCommentUUID = modelCommentListingData?.reply_uuid ?? ""
                }
            }
            
            let strLikeStatus = "Yes"
            GLOBAL.sharedInstance.callVideoCommentLikeUnlikeAPI(strCommentUUID: strCommentUUID , strIsLike: strLikeStatus, strApiName: strApiName , isInMainThread: true,completionBlock: { (status, message) in
                
                //self.alertOnTop(message: message)
                //self.showToastMessage(title: message)
                
                if(status){
                    //Updating cell after successful api call...
                    if(modelCommentListingData?.is_like?.lowercased() == "yes"){
                        modelCommentListingData?.is_like = ""
                        modelCommentListingData?.like_count = String(Int(modelCommentListingData?.like_count ?? "0")! - 1)
                    }
                    else if(modelCommentListingData?.is_like?.lowercased() == "no"){ //DisLike selected
                        modelCommentListingData?.is_like = "Yes"
                        modelCommentListingData?.like_count = String(Int(modelCommentListingData?.like_count ?? "0")! + 1)
                        modelCommentListingData?.dislike_count = String(Int(modelCommentListingData?.dislike_count ?? "0")! - 1)
                    }
                    else{
                        modelCommentListingData?.is_like = "Yes"
                        modelCommentListingData?.like_count = String(Int(modelCommentListingData?.like_count ?? "0")! + 1)
                    }
                    
                    if(indexPath.section == 0){
                        let cell = self.tblViewComments.cellForRow(at: indexPath) as! CommentCell
                        cell.updateLikeDislikeSelection()
                    }
                    else{
                        let cell = self.tblViewComments.cellForRow(at: indexPath) as! VideoCommentCell
                        cell.updateLikeDislikeSelection()
                    }
                    
                    //-----------------------------------------
                }
            })
        }
       
    }
    
    @objc func btnCommentDisLikeTap(sender:UIControl){
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Subscribe_DisLike, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.redirctToLoginScreen()
                default:
                    print("Cancel tapped")
                }
            })
        }else{
            let indexPath = self.indexPathForControl(sender, tableView: self.tblViewComments)
            
            let modelCommentListingData : Model_CommentListingData?
            var strApiName = ""
            var strCommentUUID = String()
            if(indexPath.section == 0){
                modelCommentListingData = self.modelCommentListingData
                strApiName = APIName.VideoCommentLikeUnlike
                strCommentUUID = modelCommentListingData?.comment_uuid ?? ""
            }
            else{
                modelCommentListingData = self.aryVideoComments[indexPath.row]
                strApiName = APIName.VideoReplyCommentLikeUnlike
                strCommentUUID = modelCommentListingData?.comment_uuid ?? ""
                if strCommentUUID == ""{
                    strCommentUUID = modelCommentListingData?.reply_uuid ?? ""
                }
            }
            
            let strLikeStatus = "No"
            GLOBAL.sharedInstance.callVideoCommentLikeUnlikeAPI(strCommentUUID: strCommentUUID, strIsLike: strLikeStatus, strApiName: strApiName, isInMainThread: true,completionBlock: { (status, message) in
                
                //self.alertOnTop(message: message)
                //self.showToastMessage(title: message)
                
                if(status){
                    //Updating cell after successful api call...
                    if(modelCommentListingData?.is_like?.lowercased() == "yes"){
                        modelCommentListingData?.is_like = "No"
                        modelCommentListingData?.like_count = String(Int(modelCommentListingData?.like_count ?? "0")! - 1)
                        modelCommentListingData?.dislike_count = String(Int(modelCommentListingData?.dislike_count ?? "0")! + 1)
                    }
                    else if(modelCommentListingData?.is_like?.lowercased() == "no"){ //DisLike selected
                        modelCommentListingData?.is_like = ""
                        modelCommentListingData?.dislike_count = String(Int(modelCommentListingData?.dislike_count ?? "0")! - 1)
                    }
                    else{
                        modelCommentListingData?.is_like = "No"
                        modelCommentListingData?.dislike_count = String(Int(modelCommentListingData?.dislike_count ?? "0")! + 1)
                    }
                    
                    if(indexPath.section == 0){
                        let cell = self.tblViewComments.cellForRow(at: indexPath) as! CommentCell
                        cell.updateLikeDislikeSelection()
                    }
                    else{
                        let cell = self.tblViewComments.cellForRow(at: indexPath) as! VideoCommentCell
                        cell.updateLikeDislikeSelection()
                    }
                    //-----------------------------------------
                }
            })
        }
        
       
    }
    
    //MARK:- More Button Events
    @objc func btnMoreTap(sender: UIButton) {
        let tappedButtonIndex = self.indexPathForControl(sender, tableView: self.tblViewComments)
        print("\(tappedButtonIndex.row)" + " " + "\(tappedButtonIndex.section)")
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
            Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_NonLogin_message, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                switch(index){
                case 1:
                    self.redirctToLoginScreen()
                default:
                    print("Cancel tapped")
                }
            })
        }else{
            let strUserUUID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID)
            var strUserOwnUUID = ""
            if tappedButtonIndex.section == 0{
                strUserOwnUUID = self.modelCommentListingData?.user_uuid ?? ""
            }else{
                strUserOwnUUID = self.aryVideoComments[tappedButtonIndex.row].user_uuid ?? ""
            }
           if strUserUUID != nil{
                if (strUserUUID as! String) == strUserOwnUUID{
                    
                    DispatchQueue.main.async {
                        
                        let viewComment = Bundle.loadView(fromNib: "ReportActionSheet", withType: ReportActionSheet.self)
                        viewComment.frame = UIScreen.main.bounds
                        if tappedButtonIndex.section == 0{
                            viewComment.strCommentId = self.modelCommentListingData?.comment_uuid ?? ""
                            viewComment.strPopUpTYPE = PopUpType.CommentListOwn
                        }else{
                            viewComment.strCommentId = self.aryVideoComments[tappedButtonIndex.row].comment_uuid ?? ""
                            viewComment.strPopUpTYPE = PopUpType.CommentList
                        }
                        
                        viewComment.setupPopUpUI()
                        
                        viewComment.addSubviewWithAnimationBottom(animation: {
                        }, completion: {
                        })
                        
                        //Callback
                        viewComment.handlerBlock = CompletionHandler({index,status  in
                            if index == 102{ //0 => Edit
                                var strComment = ""
                                if tappedButtonIndex.section == 0{
                                    strComment = self.modelCommentListingData?.comment ?? ""
                                }else{
                                    strComment = self.aryVideoComments[tappedButtonIndex.row].comment ?? ""
                                }
                                self.setUpKeyboard(sender: sender, strComment, KeyboardEvent.EditReply.rawValue)
                                
                            }else { //1 => Delete
                                print("\n----------- status---------\n",status)
                                if status == Cons_Success{
                                    if tappedButtonIndex.section == 0{
                                        //Parent
                                        self.indexForClose = 999
                                        self.actionHide(sender)
                                    }else{
                                        self.indexForClose = 1000
                                        self.aryVideoComments.remove(at: tappedButtonIndex.row)
                                        //update comment count
                                        var commentCount = Int(self.modelCommentListingData?.reply_count ?? "") ?? 0
                                        if commentCount > 0{
                                            commentCount = commentCount - 1
                                            self.modelCommentListingData?.reply_count = String(commentCount)
                                        }
                                    }
                                    self.tblViewComments.reloadData()
                                }
                                
                            }
                        })
                    }
                }
            }
            else{
                //Report pop up
                DispatchQueue.main.async {
                    
                    //Callback
                    self.handlerReport = indexHandlerBlock({(index) in
                        if index == 0{ //0 => Report
                            if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) == nil{
                                Alert.shared.showAlertWithHandler(title: App_Name, message: Cons_Report, buttonsTitles: [Cons_Cancel, Cons_Ok], showAsActionSheet: false, handler: { (index) in
                                    switch(index){
                                    case 1:
                                        self.redirctToLoginScreen()
                                    default:
                                        print("Cancel tapped")
                                    }
                                })
                            }else{
                                GLOBAL.sharedInstance.callReportcategorylistAPI(isInMainThread: true, completionBlock: { (status, message) in
                                    
                                    let viewReportVideoPopup = Bundle.loadView(fromNib: "ReportVideoPopup", withType: ReportVideoPopup.self)
                                    viewReportVideoPopup.frame = UIScreen.main.bounds
                                    viewReportVideoPopup.viewMain.backgroundColor = .clear
                                    viewReportVideoPopup.strSelectedVideoId = self.aryVideoComments[tappedButtonIndex.row].comment_uuid ?? ""
                                    viewReportVideoPopup.addSubviewWithAnimationCenter(animation: {
                                    }) {//Completion
                                        
                                        if(GLOBAL.sharedInstance.arrayReportCategoryData.count > 0){
                                            let modelReportCategoryData = GLOBAL.sharedInstance.arrayReportCategoryData[0]
                                            viewReportVideoPopup.txtCategory.txtField.text = modelReportCategoryData.title ?? ""
                                            viewReportVideoPopup.strReportCategoryUUID = modelReportCategoryData.uuid ?? ""
                                        }
                                    }
                                })
                            }
                            
                        }
                    })
                    
                    let viewAddStash = Bundle.loadView(fromNib: "ReportActionSheet", withType: ReportActionSheet.self)
                    viewAddStash.frame = UIScreen.main.bounds
                    viewAddStash.strPopUpTYPE = PopUpType.ReportOther
                    viewAddStash.setupPopUpUI()
                    if(self.handler != nil){
                        viewAddStash.handler = self.handlerReport
                    }
                    //SMP:Change
                    //viewAddStash.viewMain.backgroundColor = .clear
                    viewAddStash.addSubviewWithAnimationBottom(animation: {
                    }, completion: {
                        //viewAddStash.viewMain.backgroundColor = UIColor.init(red: 0.0/255.0, green:0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
                    })
                }
            }
        }
    }

    
    //MARK: - Keyboard Event Methods
    @objc func btnKeyboardTap(sender:UIButton){
        
        isFromComment = false
        setUpKeyboard(sender: sender, "", KeyboardEvent.AddReply.rawValue)
        
    }
    
    @objc func btnCommentTap(sender:UIButton){
        let strUserUUID = self.getUserDefault(KEYS_USERDEFAULTS.USER_UUID) as? String
        let strUserOwnUUID = self.modelCommentListingData?.user_uuid ?? ""
        if strUserUUID != ""{
            if strUserUUID != strUserOwnUUID{
                isFromComment = true
            }else{
                isFromComment = false
            }
        }
        setUpKeyboard(sender: sender, "", KeyboardEvent.AddReply.rawValue)
        
    }
    
    
    //MARK: - API
    func callGetVideoCommentsReplyListAPI(inMainthread: Bool){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: Any] = [KEYS_API.platform : APIConstant.platform,
                                          KEYS_API.version : KEYS_API.app_version,
                                          KEYS_API.uuid : self.modelCommentListingData?.comment_uuid ?? "",
                                          KEYS_API.start : String(self.aryVideoComments.count),
                                          KEYS_API.length : PAGE_LIMIT_DETAIL,]
        
        if inMainthread {
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_VideoCommentListingResponse.self,apiName:APIName.VideoCommentReplyList, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.tblViewComments.finishInfiniteScroll()
            
            if inMainthread {
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                //self.totalRecords = response.recordsTotal ?? 0
                
                if self.aryVideoComments.count == 0{
                    self.aryVideoComments = [Model_CommentListingData]()
                }
                
                let responseArray = response.data?.original?.data ?? [Model_CommentListingData]()
                self.aryVideoComments.append(contentsOf: (responseArray))
                
                if(responseArray.count >= Int(PAGE_LIMIT_DETAIL)!){
                    self.isAllReplyLoaded = false
                }
                else{
                    self.isAllReplyLoaded = true
                }
                
                self.tblViewComments.reloadData()
            }
            
            
        }, FailureBlock: { (error) in
            self.tblViewComments.finishInfiniteScroll()
            if inMainthread {
                self.hideLoader()
            }
            self.tblViewComments.reloadData()
        })
    }
}
