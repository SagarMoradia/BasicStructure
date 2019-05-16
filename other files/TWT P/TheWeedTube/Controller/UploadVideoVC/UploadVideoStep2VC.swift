//
//  UploadVideoStep2VC.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 25/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Photos
import Alamofire


struct Constants {
    static let minCharsForInput = 1
    static let maxCharsForInput = 30
}

fileprivate extension Selector {
    static let onEditingChanged = #selector(UploadVideoStep2VC.editingChanged(_:))
}

class UploadVideoStep2VC: ParentVC ,UIPickerViewDataSource,UIPickerViewDelegate{
    
    //MARK: - Outlets
    @IBOutlet weak var imgViewThumb: UIImageView!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var viewTags: UIView!
    @IBOutlet weak var viewTagAdds: UIView!
    @IBOutlet weak var btnPublish: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtTitle: TWTextFieldView!
    @IBOutlet weak var txtCategory: TWTextFieldView!
    @IBOutlet weak var txtPrivacy: TWTextFieldView!
    @IBOutlet weak var txtViewDesc: UITextView!
    @IBOutlet weak var lblErrorDesc: UILabel!
    @IBOutlet weak var lblErrorTags: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTags: UILabel!
    @IBOutlet weak var txtTags: UITextField!
    @IBOutlet weak var hashtags: HashtagView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightPrivacyConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK: - Properties
    var thumbImg = UIImage()
    var urlImg : URL?
    var strUrl = String()

    var selectedVideoForEdit: videoListData!
    var dictUploadVideo = [String:Any]()
    var aryHashTag = [String]()
    var categoryId = Int()
    var isFromEdit = Bool()
    
    var pickerPrivacy = UIPickerView()
    var pickerCategory = UIPickerView()
    var arrPrivacy = [Privacy.Public,Privacy.Private]
    var aryModelCategorylist = [categoryData]()
    var arrCategories = NSMutableArray()//For Multiple Selection of Category
    var arrSelectedCategories = [Int]()//For Multiple Selection of Category
    
    var aryKey = [String]()
    
    //For pop up
    //SMP:Change
//    lazy var viewPrivacy = Bundle.loadView(fromNib:"BottomView", withType: BottomView.self)
//    lazy var viewCategory = Bundle.loadView(fromNib:"CategoryView", withType: CategoryView.self)//For Multiple Selection of Category
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTextFieldsDelegate()
        self.txtTitle.txtField.autocapitalizationType = .sentences
        self.txtViewDesc.autocapitalizationType = .sentences
        prepareViews()
        print("\n------------------------------Upload Video Details--------------------------\n",dictUploadVideo)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.txtCategory.txtField.text = GLOBAL.sharedInstance.selectedCatNamesToUpload
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //getPrivacyCallback()
        //getCategoryCallback()
    }
    
    //MARK: - Intial Methods
    fileprivate func setUI(view:UIView) {
        view.layer.borderColor = UIColor.border_color.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 3.0
        view.clipsToBounds = true
    }
    
    func prepareViews() {
        
        if isFromEdit{
            
            self.btnPublish.setTitle("SAVE", for: .normal)
            self.lblTitle.text = "Save Video Detail"
            
            loadImageWith(imgView: imgViewThumb, url: selectedVideoForEdit.thumbnail, placeHolderImageName: "")//PLACEHOLDER_IMAGENAME.Large
            self.txtTitle.txtField.text = selectedVideoForEdit.title ?? ""
            self.txtViewDesc.text = selectedVideoForEdit.description ?? ""
            
            let arrHashTags = selectedVideoForEdit.tags ?? [videoTags]()
            if arrHashTags.count > 0{
                for tag in arrHashTags{
                    let hashtag = HashTag(word: tag.tag ?? "", isRemovable: true)
                    self.hashtags.addTag(tag: hashtag)
                }
            }
            
//            let arrCategories = selectedVideoForEdit.categories ?? [categories]()
////            var strNames = String()
////            var strIDs = String()
//            self.arrSelectedCategories = [Int]()
//            if arrCategories.count > 0{
//
//                let category = arrCategories[0]
//                let cat_name = category.category_title ?? ""
//
//                self.txtCategory.txtField.text = cat_name
//
////                for category in arrCategories{
////                    let cat_id = category.category_id ?? ""
////                    self.arrSelectedCategories.append(Int(cat_id) ?? 0)
////
////                    let cat_name = category.category_title ?? ""
////                    if strNames == ""{
////                        strNames = cat_name+", "
////                    }else{
////                        strNames = strNames+cat_name+", "
////                    }
////                }
////                strNames = String(strNames.dropLast())
////                strNames = String(strNames.dropLast())
////                self.txtCategory.txtField.text = strNames
////
////                //IDs for API
////                for cID in self.arrSelectedCategories{
////                    if strIDs == ""{
////                        strIDs = String(cID)+","
////                    }else{
////                        strIDs = strIDs+String(cID)+","
////                    }
////                }
////                strIDs = String(strIDs.dropLast())
////                GLOBAL.sharedInstance.selectedCatIDsToUpload = strIDs
//
//            }else{
//                self.txtCategory.txtField.text = ""
//            }
            
            
            let privacy = selectedVideoForEdit.privacy ?? "0"
            if privacy == "1"{
                self.txtPrivacy.txtField.text = Privacy.Private
                self.pickerPrivacy.selectRow(1, inComponent: 0, animated: true)
            }else{
                self.txtPrivacy.txtField.text = Privacy.Public
                self.pickerPrivacy.selectRow(0, inComponent: 0, animated: true)
            }
            
            txtCategory.txtField.isUserInteractionEnabled = false
            
        }
        else{
            
            txtCategory.txtField.isUserInteractionEnabled = true
            
            self.btnPublish.setTitle("NEXT", for: .normal)
            self.lblTitle.text = "Upload Video Detail"
            imgViewThumb.image = dictUploadVideo[Upload.thumbImg] as? UIImage
            //self.txtPrivacy.txtField.text = Privacy.Public
            self.pickerPrivacy.selectRow(0, inComponent: 0, animated: false)
        }
        
        setUI(view: viewDescription)
        setUI(view: viewTags)
        setUI(view: viewTagAdds)
        addRadius(button: btnPublish)
        addRadius(button: btnAdd)
        
        txtTags.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtTags.frame.height))
        txtTags.leftViewMode = .always
        
        self.hashtags.delegate = self
        self.txtTags.addTarget(self, action: Selector.onEditingChanged, for: .editingChanged)
        self.setClickable(false)
        
        txtPrivacy.txtField.inputView = pickerPrivacy
        txtPrivacy.txtField.readonly = true
        pickerPrivacy.dataSource = self
        pickerPrivacy.delegate = self
        
        txtCategory.txtField.inputView = pickerCategory
        txtCategory.txtField.readonly = true
        pickerCategory.dataSource = self
        pickerCategory.delegate = self
        
        callGetCategoryAPI(isInMainThread: true)
    }
    
    private func setTextFieldsDelegate() {
        txtTitle.txtField.delegate = self
        txtCategory.txtField.delegate = self
        txtPrivacy.txtField.delegate = self
        txtTags.delegate = self
        
        txtViewDesc.delegate = self
        
        //Remove blinking cursor
        //txtCategory.txtField.tintColor = UIColor.clear
        //txtPrivacy.txtField.tintColor = UIColor.clear
        //Remove Keyboard
//        txtCategory.txtField.inputView = UIView.init(frame: CGRect.zero)
//        txtCategory.txtField.inputAccessoryView = UIView.init(frame: CGRect.zero)
//        txtPrivacy.txtField.inputView = UIView.init(frame: CGRect.zero)
//        txtPrivacy.txtField.inputAccessoryView = UIView.init(frame: CGRect.zero)
    }
   
    
    //MARK: - Callback Methods
//    func getPrivacyCallback() {
//        self.viewPrivacy.handler = CompletionBlock({(index,title) in
//            print("\n---------title--------\n",title)
//            self.txtPrivacy.txtField.text = title
//        })
//    }
    
    
//    func getCategoryCallback() {//For Multiple Selection of Category
//        self.viewCategory.handler = CompletionHandlerBlock({(index,title,id) in
//            print("\n---------id--------\n",id)
//            self.categoryId = id
//            self.txtCategory.txtField.text = title
//        })
//        self.viewCategory.setupData()
//    }

}

//MARK: - Button Event Methods
extension UploadVideoStep2VC{
    
    @IBAction func actionPublish (_ sender : UIButton){
        if validate(){
            let tags = hashtags.getTags()
            for aryTags in tags{
                let strName = aryTags.text
                let strTags = strName.removing(charactersOf: "#")
                aryHashTag.append(strTags)
            }
            
            print("\n----------Array of Hashtag------------\n",aryHashTag)
            
            if isFromEdit{
                
//                let strTags = aryHashTag.joined(separator: ",")
//                let cat = selectedVideoForEdit.categories![0]
//                self.callVideoUpdateAPI(title: txtTitle.txtField.text!, category_id: cat.category_id!, tag: strTags, description: txtViewDesc.text)
                
                let vTitle = txtTitle.txtField.text
                let trimmedString = vTitle!.trimmingCharacters(in: .whitespacesAndNewlines)
                
                let cat = selectedVideoForEdit.categories![0]
                self.dictUploadVideo = [Upload.title : trimmedString, //txtTitle.txtField.text as Any,
                                        Upload.description : txtViewDesc.text,
                                        Upload.tag : aryHashTag,
                                        Upload.category_id : cat.category_id!]
                
                let controller = self.MAKE_STORY_OBJ_R1(Identifier: "UploadVideoStep3VC") as! UploadVideoStep3VC
                controller.dictUploadVideo = self.dictUploadVideo
                controller.isFromEdit = self.isFromEdit
                controller.selectedVideoForEdit = selectedVideoForEdit
                self.PUSH_STORY_OBJ(obj: controller)
                
            }
            else{
                let thumb = dictUploadVideo[Upload.thumbImg]
                let struRL = dictUploadVideo[Upload.strUrl]
                let url = dictUploadVideo[Upload.url]
                
                let vTitle = txtTitle.txtField.text
                let trimmedString = vTitle!.trimmingCharacters(in: .whitespacesAndNewlines)

                self.dictUploadVideo = [Upload.title : trimmedString, //txtTitle.txtField.text as Any,
                                        Upload.description : txtViewDesc.text,
                                        Upload.tag : aryHashTag,
                                        Upload.category_id : categoryId,//GLOBAL.sharedInstance.selectedCatIDsToUpload,
                                        Upload.privacy : txtPrivacy.txtField.text as Any,
                                        Upload.thumbImg : thumb as Any,
                                        Upload.strUrl : struRL as Any,
                                        Upload.url : url as Any]
                
                let controller = self.MAKE_STORY_OBJ_R1(Identifier: "UploadVideoStep3VC") as! UploadVideoStep3VC
                controller.dictUploadVideo = self.dictUploadVideo
                controller.isFromEdit = self.isFromEdit
                self.PUSH_STORY_OBJ(obj: controller)
            }
        }
    }
    
    func downloadVideoFrom(videoUrl:String){

        let destination = DownloadRequest.suggestedDownloadDestination()
        //let temp = self.createTempDirectory()
        self.showLoader()
        Alamofire.download(videoUrl, to: destination).response { response in // method defaults to `.get`
//            print(response.request)
//            print(response.response)
//            print(response.temporaryURL)
//            print(response.destinationURL)
//            print(response.error)
            
            self.hideLoader()
            if response.destinationURL == nil{
                
            }else{
                self.editVideo(url: response.destinationURL!)
            }
        }
    }
    
    func editVideo(url:URL){
        
        let thumb = self.selectedVideoForEdit.thumbnail
        let vPath = url.absoluteString
        let struRL = vPath
        let url = NSURL(string: vPath)
        
        let vTitle = txtTitle.txtField.text
        let trimmedString = vTitle!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.dictUploadVideo = [Upload.title : trimmedString, //self.txtTitle.txtField.text as Any,
                                Upload.description : self.txtViewDesc.text,
                                Upload.tag : self.aryHashTag,
                                Upload.category_id : categoryId,//GLOBAL.sharedInstance.selectedCatIDsToUpload,
            Upload.privacy : self.txtPrivacy.txtField.text as Any,
            Upload.thumbImg : thumb as Any,
            Upload.strUrl : struRL as Any,
            Upload.uuid : selectedVideoForEdit.uuid as Any,
            Upload.url : url as Any]
        
        let controller = self.MAKE_STORY_OBJ_R1(Identifier: "UploadVideoStep3VC") as! UploadVideoStep3VC
        controller.dictUploadVideo = self.dictUploadVideo
        controller.isFromEdit = self.isFromEdit
        self.PUSH_STORY_OBJ(obj: controller)
    }
    
    func createTempDirectory() -> String? {
        let directory = NSTemporaryDirectory()
        let fileName = NSUUID().uuidString
        
        // This returns a URL? even though it is an NSURL class method
        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])
        return fullURL?.absoluteString
    }
    
//    func clearAllFilesFromDocDirectory(){
//        
//        var error: NSErrorPointer = nil
//        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        var directoryContents: NSArray = FileManager.contentsOfDirectoryAtPath(dirPath, error: error)?
//        
//        if directoryContents != nil {
//            for path in directoryContents {
//                let fullPath = dirPath.stringByAppendingPathComponent(path as! String)
//                if fileManager.removeItemAtPath(fullPath, error: error) == false {
//                    println("Could not delete file: \(error)")
//                }
//            }
//        } else {
//            println("Could not retrieve directory: \(error)")
//        }
//    }
    
    @IBAction func actionPlayVideo (_ sender : UIControl){
        
        var url = String()
        
        if self.isFromEdit{
            url = selectedVideoForEdit.video_auto_play ?? ""
        }else{
            url = (dictUploadVideo[Upload.strUrl] as? String)!
        }
        
        if url != ""{
            let player = AVPlayer(url: URL(string: url)!)
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: false) {
            player.play()
            }
        }else{
            Alert.shared.showAlert(title: App_Name, message: "URL is missing!")
        }
    }
    
    @IBAction func onAddHashtag(_ sender: Any) {
        guard let text = self.txtTags.text else {
            return
        }
        let hashtag = HashTag(word: text, isRemovable: true)
        self.hashtags.addTag(tag: hashtag)
        
        self.txtTags.text = ""
        self.setClickable(false)
    }
    
    /*
    @IBAction func actionPrivacyTap (sender: UIButton){
        self.view.endEditing(true)
        
        //SMP:Change
        //self.viewPrivacy.viewMain.backgroundColor = .clear
        self.viewPrivacy.addSubviewWithAnimationBottom(animation: {
        }) {//CompletionBlock
            self.txtPrivacy.isValidate = true
            //self.viewPrivacy.viewMain.backgroundColor = UIColor.init(red: 0.0/255.0, green:0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
        }
    }
    */
    
    @IBAction func actionCategoryTap (sender: UIButton){ //For Multiple Selection of Category
//        self.view.endEditing(true)
//
//        self.viewCategory.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        self.viewCategory.strCategoryScreenTYPE = CategoryScreen_TYPE.UploadCategory
//
//        self.viewCategory.isFromEdit = self.isFromEdit
//        self.viewCategory.arrCategories = self.arrCategories
//        self.viewCategory.handlerCategory = CompletionHandlerBlockForCategory({(strIDs,strNames) in
//            print(strIDs)
//            print(strNames)
//            self.txtCategory.txtField.text = strNames
//            GLOBAL.sharedInstance.selectedCatIDsToUpload = strIDs
//            GLOBAL.sharedInstance.selectedCatNamesToUpload = strNames
//        })
//        self.viewCategory.setupData()
//
//        self.viewCategory.addSubviewWithAnimationBottom(animation: {
//        }) {//CompletionBlock
//        }
    }
}


//MARK: - UITextFieldDelegate Methods
extension UploadVideoStep2VC:UITextFieldDelegate{
    
    func validate() -> Bool{
        if (self.txtTitle.txtField.text?.isEmpty)!{
            txtTitle.errorMessage = Cons_title
            txtTitle.isValidate = false
            return false
        }
        else if (self.txtViewDesc.text?.isEmpty)!{
            lblErrorDesc.isHidden = false
            lblErrorDesc.text = Cons_description
            viewDescription.layer.borderColor = UIColor.txtfieldBorder_red.cgColor
            lblDesc.textColor = UIColor.txtfieldBorder_red
            return false
        }
        else if hashtags.getTags().count == 0{
            lblErrorTags.isHidden = false
            lblErrorTags.text = Cons_tags
            viewTags.layer.borderColor = UIColor.txtfieldBorder_red.cgColor
            lblTags.textColor = UIColor.txtfieldBorder_red
            return false
        }
//        else if (self.txtTags.text?.isEmpty)!{
//            lblErrorTags.isHidden = false
//            lblErrorTags.text = Cons_tags
//            viewTags.layer.borderColor = UIColor.txtfieldBorder_red.cgColor
//            lblTags.textColor = UIColor.txtfieldBorder_red
//            return false
//        }
        else if (self.txtCategory.txtField.text?.isEmpty)!{
            txtCategory.errorMessage = Cons_category
            txtCategory.isValidate = false
            return false
        }
//        else if (self.txtPrivacy.txtField.text?.isEmpty)!{
//            txtPrivacy.errorMessage = Cons_privacy
//            txtPrivacy.isValidate = false
//            return false
//        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtTags{
            guard let text = textField.text else {
                return false
            }
            if text.count >= Constants.minCharsForInput {
                onAddHashtag(textField)
                return true
            }
            return false
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtTitle.txtField {
            txtTitle.isValidate = true
        }else if textField == txtCategory.txtField {
            txtCategory.isValidate = true
        }else if textField == txtPrivacy.txtField {
            txtPrivacy.isValidate = true
        }else if textField == txtTags{
            lblErrorTags.isHidden = true
            viewTags.layer.borderColor = UIColor.txtfieldBorder_gray.cgColor
            lblTags.textColor = UIColor.textColor_black
            
           //space show and remove logic
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92){
                let stricterFilterString = "[A-Z0-9a-z]*"
                let stringTest = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
                let strVal = stringTest.evaluate(with: textField.text)
                
                if strVal{
                    self.setClickable(true)
                    let userEnteredString = textField.text
                    let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: "") as NSString
                    textField.text = newString as String
                    return false
                }
                if string == "" {
                    self.setClickable(false)
                    let userEnteredString = textField.text
                    let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: "") as NSString
                    textField.text = newString as String
                    return false
                }
               
            }
            else{
                if string == " "  {
                    self.setClickable(false)
                    let userEnteredString = textField.text
                    let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: " ") as NSString
                    textField.text = newString as String
                    return false
                }
                if (textField.text?.contains(" "))!{
                    self.setClickable(false)
                    let userEnteredString = textField.text
                    let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
                    textField.text = newString as String
                    return false
                }
                //txtTags.text = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
           
            //check space
//            let whitespaceSet = NSCharacterSet.whitespaces
//            if let _ = string.rangeOfCharacter(from: whitespaceSet) {
//                self.setClickable(false)
//                return false
//            }
            //30 char limit
            let currentCharacterCount = textField.text?.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= Constants.maxCharsForInput
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtPrivacy.txtField {
            self.pickUp(txtPrivacy.txtField, pickerPrivacy)
        }
        else if textField == txtCategory.txtField {
            self.pickUpCategory(txtCategory.txtField, pickerCategory)
        }
    }
    
    @objc
    func editingChanged(_ textField: UITextField) {
        guard let text = txtTags.text else {
            return
        }
        if text.count >= Constants.minCharsForInput {
            self.setClickable(true)
        } else {
            self.setClickable(false)
        }
    }
}

//MARK: - UITextViewDelegate Methods
extension UploadVideoStep2VC:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        lblErrorDesc.isHidden = true
        viewDescription.layer.borderColor = UIColor.txtfieldBorder_gray.cgColor
        lblDesc.textColor = UIColor.textColor_black
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 1001
    }
}

//MARK:- PickerView Delegate & DataSource
extension UploadVideoStep2VC{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerPrivacy {
            return arrPrivacy.count
        }
        else if pickerView == pickerCategory {
            return self.aryModelCategorylist.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerPrivacy {
            return arrPrivacy[row]
        }
        else if pickerView == pickerCategory {
            return aryModelCategorylist[row].name
        }
        else{
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerPrivacy {
            self.txtPrivacy.txtField.text = arrPrivacy[row]
        }
        else if pickerView == pickerCategory {
            self.txtCategory.txtField.text = aryModelCategorylist[row].name
            categoryId = aryModelCategorylist[row].id!
        }
    }
    
}

//MARK: - HashtagViewDelegate Methods
extension UploadVideoStep2VC: HashtagViewDelegate {
    
    func hashtagRemoved(hashtag: HashTag) {
        print(hashtag.text + " Removed!")
    }
    
    func viewShouldResizeTo(size: CGSize) {
        self.heightConstraint.constant = size.height
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - Custom Methods
extension UploadVideoStep2VC{
    func setClickable(_ value: Bool) {
        if value {
            self.btnAdd.isEnabled = true
            self.btnAdd.backgroundColor = UIColor.theme_green
            self.btnAdd.titleLabel?.textColor = UIColor.white
        } else {
            self.btnAdd.isEnabled = false
            self.btnAdd.backgroundColor = UIColor.init(hex: "909090")
            self.btnAdd.titleLabel?.textColor = UIColor.white
        }
    }
    
    //MARK: - Picker Method
    func pickUp(_ textField : UITextField,_ pickerViewD : UIPickerView){
        
        var pickerView = pickerViewD
        
        // UIPickerView
        pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        pickerView.backgroundColor = UIColor.white
        pickerView.reloadAllComponents()
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let label = UILabel(frame: .zero)
        label.text = Cons_Privacy
        label.textAlignment = .center
        label.textColor = UIColor.textColor_gray
        let customBarButton = UIBarButtonItem(customView: label)
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: Cons_Done, style: .plain, target: self, action: #selector(self.doneClick))
        let leftspaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: Cons_Cancel, style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton,leftspaceButton,customBarButton,spaceButton, doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        txtPrivacy.txtField.resignFirstResponder()
        txtPrivacy.isValidate = true
    }
    
    @objc func cancelClick() {
        txtPrivacy.txtField.resignFirstResponder()
    }
    
    func pickUpCategory(_ textField : UITextField,_ pickerViewD : UIPickerView){
        
        var pickerView = pickerViewD
        
        // UIPickerView
        pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        pickerView.backgroundColor = UIColor.white
        pickerView.reloadAllComponents()
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let label = UILabel(frame: .zero)
        label.text = Cons_Category
        label.textAlignment = .center
        label.textColor = UIColor.textColor_gray
        let customBarButton = UIBarButtonItem(customView: label)
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: Cons_Done, style: .plain, target: self, action: #selector(self.doneCategoryClick))
        let leftspaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: Cons_Cancel, style: .plain, target: self, action: #selector(self.cancelCategoryClick))
        toolBar.setItems([cancelButton,leftspaceButton,customBarButton,spaceButton, doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func doneCategoryClick() {
        txtCategory.txtField.resignFirstResponder()
        txtCategory.isValidate = true
    }
    
    @objc func cancelCategoryClick() {
        txtCategory.txtField.resignFirstResponder()
    }
}

//MARK: - API Methods
extension UploadVideoStep2VC{

    func callGetCategoryAPI(isInMainThread:Bool)  {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_CategoryData.self,apiName:APIName.GetCategories, requestType: .get, paramValues: nil, headersValues: headerParams, SuccessBlock: { (response) in
            
            if isInMainThread{
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {

                if response.data != nil{
                    self.aryModelCategorylist = [categoryData]()
                    self.aryModelCategorylist = response.data ?? [categoryData]()
                    print("\n----------------Category Data-----------------\n",self.aryModelCategorylist)
                    
                    if self.aryModelCategorylist.count > 0{
                        //self.updateArrFromData()
                        
                        if !self.isFromEdit{
                            //self.txtCategory.txtField.text = self.aryModelCategorylist[0].name
                            //self.pickerCategory.selectRow(0, inComponent: 0, animated: false)
                        }else{
                            self.updateArrFromData()
                        }
                    }else{
                    }
                }else{
                }
                
                self.pickerCategory.reloadAllComponents()
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
    
    func setIndexforSelectedCategory(){
        let arrCategories = selectedVideoForEdit.categories ?? [categories]()
        self.arrSelectedCategories = [Int]()
        if arrCategories.count > 0{
            
            let category = arrCategories[0]
            let cat_name = category.category_title ?? ""
            
            self.txtCategory.txtField.text = cat_name
            
//            for index in 0...self.aryModelCategorylist.count {
//                let cat = self.aryModelCategorylist[index]
//                let cName = cat.name ?? ""
//                if cName == cat_name{
//                    self.pickerCategory.selectRow(index, inComponent: 0, animated: false)
//                }
//            }

            for cat in self.arrCategories{
                let cate = cat as! NSDictionary
                let name = cate["name"] as! String
                if name == cat_name{
                    let indx = self.arrCategories.index(of: cat)
                    self.pickerCategory.selectRow(indx, inComponent: 0, animated: false)
                }
            }
            
        }else{
            self.txtCategory.txtField.text = ""
        }
    }
    
    func updateArrFromData() {
        
        for cat in self.aryModelCategorylist{
            let cID = cat.id ?? 0
            let cUuid = cat.uuid ?? ""
            let cName = cat.name ?? ""
            var isSelected = Bool()
            
            if self.isFromEdit{
                if self.arrSelectedCategories.count > 0{
                    for cat_id in self.arrSelectedCategories{
                        if cat_id == cID{
                            isSelected = true
                        }
                    }
                }else{
                    isSelected = false
                }
            }else{
                isSelected = false
            }
            
            let dict = NSMutableDictionary()
            dict.setValue(cID, forKey: "id")
            dict.setValue(cUuid, forKey: "uuid")
            dict.setValue(cName, forKey: "name")
            dict.setValue(isSelected, forKey: "isSelected")
            
            self.arrCategories.add(dict)
        }
        self.setIndexforSelectedCategory()
        GLOBAL.sharedInstance.arrCategory = self.arrCategories
    }
    
    func callVideoUpdateAPI(title:String,category_id:String,tag:String,description:String)  {
        
        self.showLoader()
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let v_uuid = selectedVideoForEdit.uuid
        
        let queryParams = NSMutableDictionary()
        queryParams.setValue(title, forKey: KEYS_API.title)
        queryParams.setValue(category_id, forKey: KEYS_API.category_id)
        queryParams.setValue(description, forKey: KEYS_API.description)
        queryParams.setValue(tag, forKey: KEYS_API.tag)
        queryParams.setValue(0, forKey: KEYS_API.privacy)
        queryParams.setValue(v_uuid, forKey: KEYS_API.uuid)
        queryParams.setValue("Yes", forKey: KEYS_API.ispublish)
        
        print("\n-------------------------Parameters :-----------------------\n",queryParams)
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: EditVideoModel.self,apiName:APIName.VideoUpdate, requestType: .post, paramValues: (queryParams as! Dictionary<String, Any>), headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            let statusCode = response.meta?.status_code
            
            if self.handleStatusCode(statusCode: statusCode!, modelErrors: response.errors, meta: response.meta) {
                
                let vUuid = response.data!.uuid ?? ""
                
                let msg = response.meta?.message ?? ""
                
                GLOBAL.sharedInstance.selectedCatIDsToUpload = ""
                GLOBAL.sharedInstance.selectedCatNamesToUpload = ""
                GLOBAL.sharedInstance.arrCategory = NSMutableArray()
                let controller = self.MAKE_STORY_OBJ_R1(Identifier: "UploadVideoStep4VC") as! UploadVideoStep4VC
                controller.videoUuid = vUuid
                controller.msgSuccess = msg
                controller.isFromEdit = self.isFromEdit
                controller.hidesBottomBarWhenPushed = true
                self.PUSH_STORY_OBJ(obj: controller)
                
//                Alert.shared.showAlertWithHandler(title: App_Name, message: msg, okButtonTitle: Cons_Ok, handler: { (action) in
//                })
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
        //ModelSetAccountSettings
//        API.sharedInstance.multipartRequestWithModalClassForVideo(modelClass: EditVideoModel.self, apiName: APIName.VideoUpdate,fileName:"",keyName:aryKey,fileData:Data(), videoURL: NSURL() as URL, requestType: .post, paramValues: (queryParams as! Dictionary<String, Any>), headersValues: headerParams, isFromEdit: true, SuccessBlock: { (response) in
//
//            self.hideLoader()
//
//            let statusCode = response.meta?.status_code
//
//            if self.handleStatusCode(statusCode: statusCode!, modelErrors: response.errors, meta: response.meta) {
//
//                let vUuid = response.data!.uuid ?? ""
//
//                let msg = response.meta?.message ?? ""
//
//                Alert.shared.showAlertWithHandler(title: App_Name, message: msg, okButtonTitle: Cons_Ok, handler: { (action) in
//
//                    GLOBAL.sharedInstance.selectedCatIDsToUpload = ""
//                    GLOBAL.sharedInstance.selectedCatNamesToUpload = ""
//                    GLOBAL.sharedInstance.arrCategory = NSMutableArray()
//                    let controller = self.MAKE_STORY_OBJ_R1(Identifier: "UploadVideoStep4VC") as! UploadVideoStep4VC
//                    controller.videoUuid = vUuid
//                    controller.msgSuccess = msg
//                    controller.isFromEdit = self.isFromEdit
//                    controller.hidesBottomBarWhenPushed = true
//                    self.PUSH_STORY_OBJ(obj: controller)
//                })
//            }
//
//        }, FailureBlock: { (error) in
//            self.hideLoader()
//
//        }, ProgressHandler: { (progress) in
//            print("progress: \(progress)")
//        })
    }
}


extension String {
    func removing(charactersOf string: String) -> String {
        let characterSet = CharacterSet(charactersIn: string)
        let components = self.components(separatedBy: characterSet)
        return components.joined(separator: "")
    }
}
