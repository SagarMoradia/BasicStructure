//
//  EditProfileVC.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 15/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

struct SocialListAPI{
    let social_media_name:String?
    let social_media_url:String?
}

class SocialList{
    let social_media_name:String
    var social_media_url:String
    var is_expanded:Bool
    var is_switchON:Bool
    
    
    init(objSocialListAPI:SocialListAPI) {
        self.social_media_name = objSocialListAPI.social_media_name ?? ""
        self.social_media_url = objSocialListAPI.social_media_url ?? ""
        
        if objSocialListAPI.social_media_url?.count ?? -1 > 0{
            self.is_expanded = true
            self.is_switchON = true
        }else{
            self.is_expanded = false
            self.is_switchON = false
        }
    }
}


class EditProfileVC: ParentVC,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var viewAbout: UIView!
    @IBOutlet weak var txtViewAbout: UITextView!
    @IBOutlet weak var conHeightAbout: NSLayoutConstraint!
    @IBOutlet weak var conHeightSocialAccount: NSLayoutConstraint!
    @IBOutlet weak var cntrlProfile: UIControl!
    @IBOutlet weak var cntrlUploadCover: UIControl!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var imgViewCoverPic: UIImageView!
    @IBOutlet weak var txtFirstName: TWTextFieldView!
    @IBOutlet weak var txtLastName: TWTextFieldView!
    @IBOutlet weak var txtEmail: TWTextFieldView!
    @IBOutlet weak var txtDOB: TWTextFieldView!
    @IBOutlet weak var ViewProfile: UIView!
    @IBOutlet weak var imgvNewsLetter: UIImageView!
    @IBOutlet weak var conHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblAboutTitle: UILabel!
    @IBOutlet weak var lblAboutError: UILabel!
    
    //MARK: - Properties
    var arySocialAccount = [SocialList]()
    var dictEditProfiile : ProfileData!
    var strProfileNameForAPI = String()
    var strCoverNameForAPI = String()
    let datePicker = UIDatePicker()
    var selectedDate = Date()
    var strNewsletter = String()
    
    var aryKey = [String]()
    
    var selectedImages=[UIImage]()
    var strSociallinkURl = ""
    //Static variable
    static let sectionHeight = CGFloat(50.0)
    static let rowHeight = CGFloat(60.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
//        if self.dictEditProfiile == nil {
            callGetProfileAPI(isInMainThread: true)
//        }else{
//            self.setUpData()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTextFieldsDelegate()
    }
    
    //MARK: - Intial Methods
    func prepareViews() {
        tblProfile.register(UINib.init(nibName: "CellSocialAccounts", bundle: nil), forCellReuseIdentifier: "CellSocialAccounts")
        tblProfile.tableFooterView = UIView()
        
        self.viewAbout.layer.borderColor = UIColor.border_color.cgColor
        self.viewAbout.layer.borderWidth = 1.0
        self.viewAbout.layer.cornerRadius = 3.0
        self.viewAbout.clipsToBounds = true
        
        self.addRound(control: cntrlProfile)
        self.cntrlProfile.layer.borderColor = UIColor.white_border_color.cgColor
        self.cntrlProfile.layer.borderWidth = 0.5
        
        self.addRound(control: cntrlUploadCover)
        self.cntrlUploadCover.layer.borderColor = UIColor.white_border_color.cgColor
        self.cntrlUploadCover.layer.borderWidth = 0.5
        
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.height/2
        imgViewProfile.layer.masksToBounds = true
        
        imgViewProfile.layer.borderWidth = 1.0
        imgViewProfile.layer.borderColor = UIColor(hex:SideMenuHexColor.TextColor).cgColor
        imgViewProfile.layer.masksToBounds = true
        
        txtViewAbout.delegate = self
        
        //txt date
        txtDOB.txtField.readonly = true
        self.showdatePicker()
        //Remove blinking cursor
        txtDOB.txtField.tintColor = UIColor.clear
    }
    
    private func setTextFieldsDelegate() {
        txtFirstName.txtField.delegate = self
        txtLastName.txtField.delegate = self
        txtEmail.txtField.delegate = self
        txtEmail.txtField.isUserInteractionEnabled = false
        txtDOB.txtField.delegate = self
    }
    
    fileprivate func setUpData() {
        let strAbout = dictEditProfiile?.user_data?.about_me ?? ""
        txtViewAbout.text = strAbout

        txtFirstName.txtField.text = dictEditProfiile?.user_data?.first_name ?? ""
        txtLastName.txtField.text = dictEditProfiile?.user_data?.last_name ?? ""
        txtEmail.txtField.text = dictEditProfiile?.user_data?.email ?? ""
        
        let dob = dictEditProfiile.user_data?.date_of_birth ?? ""
        if dob == ""{
            txtDOB.txtField.text = ""
        }
        else{
            txtDOB.txtField.text = self.getFormattedDate(stringDate: dob)
        }
//        txtDOB.txtField.text = self.getFormattedDate(stringDate: dictEditProfiile.user_data?.date_of_birth ?? "")
        
        //News letter subscription
        let news = dictEditProfiile?.user_data?.subscribe_newsletter ?? ""
        if news == "true"{
            imgvNewsLetter.image = UIImage(named : "Check")
        }else{
            imgvNewsLetter.image = UIImage(named : "Uncheck")
        }
        
        //Profile image
        let strImage = dictEditProfiile?.user_data?.profile_photo
        if strImage == nil || strImage == ""{
            imgViewProfile.image = UIImage(named:Cons_Profile_Image_Name)
            imgViewProfile.contentMode = .center
        }else{
            let profileURL = dictEditProfiile?.user_data?.profile_photo!
            if self.verifyUrl(urlString: profileURL){
                loadImageWith(imgView: imgViewProfile, url: profileURL)
                imgViewProfile.contentMode = .scaleAspectFill
            }else{
                imgViewProfile.image = UIImage(named: Cons_Profile_Image_Name)
                imgViewProfile.contentMode = .center
            }
        }
        
        //Cover image
        let coverURL = dictEditProfiile?.user_data?.cover_photo
        if self.verifyUrl(urlString: coverURL){
            loadImageWith(imgView: imgViewCoverPic, url: coverURL)
            imgViewCoverPic.contentMode = .scaleAspectFill
        }else{
            //topView.imgvCover.image = UIImage(named: PLACEHOLDER_IMAGENAME.Large)
            imgViewCoverPic.contentMode = .scaleAspectFit
        }
        
        if (dictEditProfiile.user_data?.social_accounts?.count)! > 0{
            populateSocialData()
        }else{
            conHeightSocialAccount.constant = 0
        }
    }
    
    fileprivate func populateSocialData(){
        
        for arrSocial in (dictEditProfiile.user_data?.social_accounts)!{
            let objSocialListAPI = SocialListAPI(social_media_name: arrSocial.social_media_name, social_media_url: arrSocial.social_media_url)
            let objSocialList = SocialList(objSocialListAPI: objSocialListAPI)
            arySocialAccount.append(objSocialList)
        }
        
        print("\n---------------Main array-------------\n",arySocialAccount)

        self.tblProfile.reloadData()
        setTableHeight()
       
    }
    
    fileprivate func setTableHeight() {
        
        if arySocialAccount.count == 0{
            conHeightSocialAccount.constant = 0
        }else{
            
            tblProfile.isScrollEnabled = false
            var tableHeight = CGFloat(70.0)
            
            for objSocialList in arySocialAccount {
                if objSocialList.is_expanded{
                    tableHeight = tableHeight + EditProfileVC.rowHeight + EditProfileVC.sectionHeight
                }else{
                    tableHeight = tableHeight + EditProfileVC.rowHeight
                }
            }
            
            conHeightSocialAccount.constant = tableHeight + 20
            tblProfile.setNeedsDisplay()
        }
    }
    
    //MARK: - Event Methods
    @IBAction func btnNewsletterTap(_ sender: UIButton) {
        if GLOBAL.sharedInstance.isNewsletter {
            GLOBAL.sharedInstance.isNewsletter = false
            DefaultValue.shared.setBoolValue(value: GLOBAL.sharedInstance.isNewsletter, key: KEYS_USERDEFAULTS.IS_NEWSLETTER)
            imgvNewsLetter.image = UIImage(named : "Uncheck")
            strNewsletter = "false"
        }else{
            GLOBAL.sharedInstance.isNewsletter = true
            DefaultValue.shared.setBoolValue(value: GLOBAL.sharedInstance.isNewsletter, key: KEYS_USERDEFAULTS.IS_NEWSLETTER)
            imgvNewsLetter.image = UIImage(named : "Check")
            strNewsletter = "true"
        }
    }
}

//MARK: - UITextFieldDelegate Methods
extension EditProfileVC{
    func validate() -> Bool{
        if (self.txtFirstName.txtField.text?.isEmpty)!{
            txtFirstName.errorMessage = Cons_blank_firstName
            txtFirstName.isValidate = false
            return false
        }
        else if (self.txtLastName.txtField.text?.isEmpty)!{
            txtLastName.errorMessage = Cons_blank_lastName
            txtLastName.isValidate = false
            return false
        }
        else if (self.txtEmail.txtField.text?.isEmpty)!{
            txtEmail.errorMessage = Cons_blank_email
            txtEmail.isValidate = false
            return false
        }
        else if !(txtEmail.txtField.text?.isValidEmail)!{
            txtEmail.errorMessage = Cons_valid_email
            txtEmail.isValidate = false
            return false
        }
        else if (txtDOB.txtField.text?.isEmpty)!{
            txtDOB.errorMessage = Cons_blank_dob
            txtDOB.isValidate = false
            return false
        }
        else if (txtViewAbout.text.isEmpty){
            lblAboutError.isHidden = false
            lblAboutError.text = Cons_blank_about
            viewAbout.layer.borderColor = UIColor.txtfieldBorder_red.cgColor
            lblAboutTitle.textColor = UIColor.txtfieldBorder_red
            return false
            
            
            //self.showToastMessage(title: Cons_blank_about)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFirstName.txtField {
            txtFirstName.isValidate = true
        }else if textField == txtLastName.txtField {
            txtLastName.isValidate = true
        }else if textField == txtEmail.txtField {
            txtEmail.isValidate = true
        }else if textField == txtDOB.txtField {
            txtDOB.isValidate = true
        }
        return true
    }
}


//MARK: - UITextViewDelegate Methods
extension EditProfileVC:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        lblAboutError.isHidden = true
        viewAbout.layer.borderColor = UIColor.txtfieldBorder_gray.cgColor
        lblAboutTitle.textColor = UIColor.textColor_black
    }
}

extension EditProfileVC {
    //MARK: - Datepicker Methods
    func showdatePicker(){
        
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(handledatePicker(sender:)), for: .valueChanged)
        
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let label = UILabel(frame: .zero)
        label.text = Cons_DOB
        label.textAlignment = .center
        label.textColor = UIColor.textColor_gray
        let customBarButton = UIBarButtonItem(customView: label)
        
        let doneButton = UIBarButtonItem(title: Cons_Done, style: .plain, target: self, action: #selector(donedatePicker));
        let leftspaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: Cons_Cancel, style: .plain, target: self, action: #selector(canceldatePicker));
        toolbar.setItems([cancelButton,leftspaceButton,customBarButton,spaceButton, doneButton], animated: false)
        
        txtDOB.txtField.inputAccessoryView = toolbar
        txtDOB.txtField.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        txtDOB.txtField.text = formatter.string(from: datePicker.date)
        txtDOB.txtField.resignFirstResponder()
        self.txtDOB.isValidate = true
        self.selectedDate = datePicker.date
        
    }
    
    @objc func canceldatePicker(){
        txtDOB.txtField.resignFirstResponder()
    }
    
    //MARK:- DatePicker Value Changed
    @objc func handledatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        txtDOB.txtField.text = dateFormatter.string(from: sender.date)
    }
}

//MARK: - Tableview Datasource and Delegate Methods
extension EditProfileVC{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arySocialAccount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblProfile.dequeueReusableCell(withIdentifier: "CellSocialAccounts", for: indexPath) as! CellSocialAccounts
        cell.objSocialList = arySocialAccount[indexPath.row]
        cell.cntrlSwitch.addTarget(self, action: #selector(actionSwitch(sender:)), for: .valueChanged)
        cell.txtSocialLink.addTarget(self, action: #selector(textValueChange(textField:)), for: .editingChanged)
        
        cell.lblSocialLink.tag = indexPath.row
        cell.cntrlSwitch.tag = indexPath.row
        cell.txtSocialLink.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return arySocialAccount[indexPath.row].is_expanded ? EditProfileVC.rowHeight + EditProfileVC.sectionHeight : EditProfileVC.rowHeight
    }
}

//MARK: User action events
extension EditProfileVC{
    
    @objc func actionSwitch(sender: PVSwitch) {
        let path = IndexPath(row: sender.tag, section: 0)
        
        arySocialAccount[sender.tag].is_switchON = !arySocialAccount[sender.tag].is_switchON
        arySocialAccount[sender.tag].is_expanded = !arySocialAccount[sender.tag].is_expanded
        self.tblProfile.reloadRows(at: [path], with: .automatic)
        setTableHeight()
    }
    
    @objc func textValueChange(textField: UITextField) {
        let indexpath = NSIndexPath(row: textField.tag, section: 0)
        let currentcell = tblProfile.cellForRow(at: indexpath as IndexPath) as! CellSocialAccounts
        strSociallinkURl = currentcell.lblSocialLink.text!
        arySocialAccount[textField.tag].social_media_url = strSociallinkURl + textField.text!
    }
    
    @IBAction func cntrlImageUpload( _ sender: UIControl){
        
        let alert:UIAlertController=UIAlertController(title: Cons_Image_Picker_Title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: Cons_Camera, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            imagePicker.sharedInstance.openImagePickerWithSourceType(source: UIImagePickerController.SourceType.camera, handler: { (image, url, status) in
                
                if sender.tag == 101{
                    self.imgViewProfile.image = image
                    self.imgViewProfile.setNeedsDisplay()
                    self.imgViewProfile.contentMode = .scaleAspectFill
                    self.strProfileNameForAPI = (image?.imageName)!
                }else{
                    self.imgViewCoverPic.image = image
                    self.imgViewCoverPic.setNeedsDisplay()
                    self.imgViewCoverPic.contentMode = .scaleAspectFill
                    self.strCoverNameForAPI = (image?.imageName)!
                }
            }, isVideo: false)
        }
        let gallaryAction = UIAlertAction(title: Cons_Gallery, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            imagePicker.sharedInstance.openImagePickerWithSourceType(source: UIImagePickerController.SourceType.photoLibrary, handler: { (image, url, status) in
                
                if sender.tag == 101{
                    self.imgViewProfile.image = image
                    self.imgViewProfile.setNeedsDisplay()
                    self.imgViewProfile.contentMode = .scaleAspectFill
                    self.strProfileNameForAPI = (image?.imageName)!
                }else{
                    self.imgViewCoverPic.image = image
                    self.imgViewCoverPic.setNeedsDisplay()
                    self.imgViewCoverPic.contentMode = .scaleAspectFill
                    self.strCoverNameForAPI = (image?.imageName)!
                }
            }, isVideo: false)
        }
        let cancelAction = UIAlertAction(title: Cons_Cancel, style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveTap(_ sender: UIButton) {
        if validate(){
            
//            for objSocial in arySocialAccount{
//                let valueMediaName = objSocial.social_media_name
//                let valueMediaURL = objSocial.social_media_url
//                if objSocial.is_switchON{
//                    if valueMediaURL == ""{
//
//                    }
//                }
//            }
            
            callUpdateProfileAPI(firstName: txtFirstName.txtField.text!, lastName: txtLastName.txtField.text!, email: txtEmail.txtField.text!, about: txtViewAbout.text, dateOfBirth: txtDOB.txtField.text!)
        }
    }
    
    
}

//MARK: - API Methods
extension EditProfileVC{
    func callGetProfileAPI(isInMainThread:Bool)  {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: String] = [KEYS_API.platform : APIConstant.platform,
                                             KEYS_API.version : KEYS_API.app_version]
        
        if isInMainThread{
            self.showLoader()
        }
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: ModelGetProfile.self,apiName:APIName.GetProfile, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            if isInMainThread{
                self.hideLoader()
            }
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
               
                if response.data != nil{
                    self.dictEditProfiile = response.data
                    print("\n-------------------------Edit Profile :-----------------------\n",self.dictEditProfiile as Any)
                    //self.strProfileNameForAPI = (response.data?.profile_image?.components(separatedBy: "/").last)!
                    self.setUpData()
                }
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }

    func callUpdateProfileAPI(firstName:String,lastName:String,email:String,about:String,dateOfBirth:String)  {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams = NSMutableDictionary()
        queryParams.setValue(firstName, forKey: KEYS_API.first_name)
        queryParams.setValue(lastName, forKey: KEYS_API.last_name)
        queryParams.setValue(email, forKey: KEYS_API.email)
        
        queryParams.setValue("+1 987654321", forKey: KEYS_API.phone_number)
        queryParams.setValue(dateOfBirth, forKey: KEYS_API.date_of_birth)
        queryParams.setValue(strNewsletter, forKey: "subscribe_newsletter")
        queryParams.setValue(about, forKey: KEYS_API.about_me)
        queryParams.setValue(APIConstant.platform, forKey: KEYS_API.platform)
        queryParams.setValue(KEYS_API.app_version, forKey: KEYS_API.version)
        
        //For Social Accounts
        for (index,objSocial) in arySocialAccount.enumerated(){
            let keyMediaName =  "social_accounts[\(index)][social_media_name]"
            let valueMediaName = objSocial.social_media_name
            queryParams.setValue(valueMediaName, forKey: keyMediaName)

            let keyMediaURL =  "social_accounts[\(index)][social_media_url]"
            let valueMediaURL = objSocial.social_media_url
            if !objSocial.is_switchON{
                queryParams.setValue("", forKey: keyMediaURL)
            }else{
                queryParams.setValue(valueMediaURL, forKey: keyMediaURL)
            }
        }
        
        print("\n-------------------------Parameters :-----------------------\n",queryParams)
        
        if self.strProfileNameForAPI != ""{
             self.selectedImages.append(self.imgViewProfile.image!)
             aryKey.append("profile_image")
        }
        
        if self.strCoverNameForAPI != ""{
            self.selectedImages.append(self.imgViewCoverPic.image!)
            aryKey.append("cover_image")
            
        }
        
        var fileName:[String]? = []
        var fileData:[Data]? = []
        var fileKeyName:[String]? = []
        for (index,image) in selectedImages.enumerated() {
            queryParams[aryKey[index]] = "image\(index)"
            fileName?.append("image\(index)")
            fileKeyName?.append(aryKey[index])
            let imgData = image.jpegData(compressionQuality: 0.5)
            fileData?.append(imgData!)
        }
        
        
        self.showLoader()
        
        API.sharedInstance.multipartRequestForProfileWithModalClassForMedia(modelClass: ModelSetAccountSettings.self, apiName: APIName.SetProfile,fileName:fileName!,keyName:fileKeyName!,fileData:fileData!, requestType: .post, paramValues: (queryParams as! Dictionary<String, Any>), headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            let statusCode = response.meta?.status_code
            
            if self.handleStatusCode(statusCode: statusCode!, modelErrors: response.errors, meta: response.meta) {
                Alert.shared.showAlertWithHandler(title: App_Name, message: (response.meta?.message)!, okButtonTitle: Cons_Ok, handler: { (action) in
                    self.POP_VC()
                })
            }
            
        }) { (error) in
            self.hideLoader()
        }
        
}
  
}

extension Collection where Element: Hashable {
    var orderedSet: [Element] {
        var set: Set<Element> = []
        return reduce(into: []) { set.insert($1).inserted ? $0.append($1) : () }
    }
}

extension Array where Element: UIImage {
    func unique() -> [UIImage] {
        var unique = [UIImage]()
        for image in self {
            if !unique.contains(image) {
                unique.append(image)
            }
        }
        return unique
    }
}
