//
//  RegisterVC.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 08/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

struct Gender {
    static let Male = "Male"
    static let Female = "Female"
}

class RegisterVC: ParentVC,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    //MARK: - Outlets
    @IBOutlet weak var txtFirstName: TWTextFieldView!
    @IBOutlet weak var txtLastName: TWTextFieldView!
    @IBOutlet weak var txtEmail: TWTextFieldView!
    @IBOutlet weak var txtUserName: TWTextFieldView!
    @IBOutlet weak var txtDOB: TWTextFieldView!
    @IBOutlet weak var txtGender: TWTextFieldView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: TWTextFieldView!
    
    @IBOutlet weak var lblErrorPassword: UILabel!
    @IBOutlet weak var lblPassword: UILabel!

    @IBOutlet weak var imgvTerms: UIImageView!
    @IBOutlet weak var imgvNewsLetter: UIImageView!
    
    @IBOutlet weak var lblAgreeTerms: UILabel!
    @IBOutlet weak var lblAlready: UILabel!

    //MARK: - Properties
    var isTermsSelected = Bool()
    var isNewsSelected  = Bool()
    
    let datePicker = UIDatePicker()
    var selectedDate = Date()
    var pickerGender = UIPickerView()
    var arrGender = [Gender.Male,Gender.Female,"Non-Binary","Prefer not to answer"]
    
    var strDateOfBirth = String()
    var strAgreement = String()
    var strNewsletter = String()

    var strUsername = String()
    
    //MARK: - UIViewController Methods
    override func viewDidLoad() {
        isMenuGestureEnable = false
        super.viewDidLoad()
        prepareViews()
        setUpUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default // .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setTextFieldsDelegate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        GLOBAL.sharedInstance.isAgreement = false
        DefaultValue.shared.setBoolValue(value: GLOBAL.sharedInstance.isAgreement, key: KEYS_USERDEFAULTS.IS_AGREEMENT_TERMS)
    }
    
    //MARK: - Intial Methods
    private func setTextFieldsDelegate() {
        txtFirstName.txtField.delegate       = self
        txtLastName.txtField.delegate        = self
        txtEmail.txtField.delegate           = self
        txtUserName.txtField.delegate        = self
        txtDOB.txtField.delegate             = self
        txtGender.txtField.delegate          = self
        txtPassword.delegate        = self
        txtConfirmPassword.txtField.delegate = self
        
        self.txtEmail.txtField.keyboardType = .emailAddress
        self.txtPassword.isSecureTextEntry = true
        self.txtConfirmPassword.txtField.isSecureTextEntry = true
        
        //Remove blinking cursor
        //txtDOB.txtField.tintColor = UIColor.clear
        //Remove Keyboard for DOB
        //txtDOB.txtField.inputView = UIView.init(frame: CGRect.zero)
        //txtDOB.txtField.inputAccessoryView = UIView.init(frame: CGRect.zero)
    }
    
    private func prepareViews() {
        
        //agree terms
        let astr1 = "Agree to "
        let astr2 = "Terms of Service"
        let astr3 = " & "
        let astr4 = "Privacy Policy"
        let astrText = astr1+astr2+astr3+astr4
        var amutableString = NSMutableAttributedString()
        amutableString = NSMutableAttributedString(string: astrText, attributes: [NSAttributedString.Key.font:fontType.InterUI_Medium_11!])
        amutableString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.textColor_gray, range: NSRange(location:0,length:astr1.count))
        amutableString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.textColor_gray, range: NSRange(location:astr1.count+astr2.count,length:astr3.count))
        self.lblAgreeTerms.attributedText = amutableString
        
        //Login Button
        let str1 = "Already have an account? "
        let str2 = "Login"
        let strText = str1+str2
        var mutableString = NSMutableAttributedString()
        mutableString = NSMutableAttributedString(string: strText, attributes: [NSAttributedString.Key.font:fontType.InterUI_Medium_12!])
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.textColor_gray, range: NSRange(location:0,length:str1.count))
        self.lblAlready.attributedText = mutableString
        
        txtGender.txtField.inputView = pickerGender
        txtGender.txtField.readonly = true
        pickerGender.dataSource = self
        pickerGender.delegate = self
        
        
        //txt date
        txtDOB.txtField.readonly = true
        self.showdatePicker()
        
//        self.txtGender.txtField.text = arrGender[0]
//        self.pickerGender.selectRow(0, inComponent: 0, animated: false)
        
        //api event
        //txtUserName.txtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    fileprivate func setUpUI() {
        txtPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtPassword.frame.height))
        txtPassword.leftViewMode = .always
        txtPassword.layer.borderColor = UIColor.border_color.cgColor
        txtPassword.layer.borderWidth = 1.0
        txtPassword.layer.cornerRadius = 3.0
        txtPassword.clipsToBounds = true
    }
    
    
    private func isValidateInfo() -> Bool{
        
        let whitespace = NSCharacterSet.whitespaces
        let phraseEmail = txtEmail.txtField.text ?? ""
        let rangeEmail = phraseEmail.rangeOfCharacter(from: whitespace)
        
        let phraseUsername = txtUserName.txtField.text ?? ""
        let rangeUsername = phraseUsername.rangeOfCharacter(from: whitespace)
        
        if (txtFirstName.txtField.text?.isEmpty)!{
            txtFirstName.errorMessage = Cons_blank_firstName
            txtFirstName.isValidate = false
            return false
        }
        else if ((txtFirstName.txtField.text?.count)!) < 3{
            txtFirstName.errorMessage = Cons_name_minimum
            txtFirstName.isValidate = false
            return false
        }
        else if (txtLastName.txtField.text?.isEmpty)!{
            txtLastName.errorMessage = Cons_blank_lastName
            txtLastName.isValidate = false
            return false
        }
        else if ((txtLastName.txtField.text?.count)!) < 2{
            txtLastName.errorMessage = Cons_name_minimum
            txtLastName.isValidate = false
            return false
        }
        else if (txtEmail.txtField.text?.isEmpty)!{
            txtEmail.rightImage = UIImage(named: "txtInvalid")
            txtEmail.errorMessage = Cons_blank_email
            txtEmail.isValidate = false
            txtEmail.addRightImage()
            return false
        }
        else if rangeEmail != nil {
            txtEmail.errorMessage = Cons_valid_email
            txtEmail.isValidate = false
            return false
        }
        else if !(txtEmail.txtField.text?.isValidEmail)!{
            txtEmail.rightImage = UIImage(named: "txtInvalid")
            txtEmail.errorMessage = Cons_valid_email
            txtEmail.isValidate = false
            txtEmail.addRightImage()
            return false
        }
        else if (txtUserName.txtField.text?.isEmpty)!{
            txtUserName.rightImage = UIImage(named: "txtInvalid")
            txtUserName.errorMessage = Cons_blank_userName
            txtUserName.isValidate = false
            txtUserName.addRightImage()
            return false
        }
        else if rangeUsername != nil {
            txtUserName.errorMessage = Cons_valid_userName
            txtUserName.isValidate = false
            return false
        }
        else if ((txtUserName.txtField.text?.count)!) < 4{
            self.txtUserName.rightImage = UIImage(named: "txtInvalid")
            self.txtUserName.errorMessage = Cons_Invalid_Username
            self.txtUserName.isValidate = false
            self.txtUserName.addRightImage()
            return false
        }
        else if (txtDOB.txtField.text?.isEmpty)!{
            txtDOB.errorMessage = Cons_blank_dob
            txtDOB.isValidate = false
            return false
        }
        else if (txtGender.txtField.text?.isEmpty)!{
            txtGender.errorMessage = Cons_blank_gender
            txtGender.isValidate = false
            return false
        }
        else if (txtPassword.text?.isEmpty)!{
            lblErrorPassword.isHidden = false
            lblErrorPassword.text = Cons_New_Password
            txtPassword.layer.borderColor = UIColor.txtfieldBorder_red.cgColor
            lblPassword.textColor = UIColor.txtfieldBorder_red
            txtPassword.textColor = UIColor.txtfieldBorder_red
            //txtPassword.errorMessage = Cons_blank_password
            //txtPassword.isValidate = false
            return false
        }
        else if Validator.isvalidPassword(self.txtPassword.text!) {
            lblErrorPassword.isHidden = false
            lblErrorPassword.text = Cons_Valid_Password
            txtPassword.layer.borderColor = UIColor.txtfieldBorder_red.cgColor
            lblPassword.textColor = UIColor.txtfieldBorder_red
            txtPassword.textColor = UIColor.txtfieldBorder_red
            return false
        }
//        else if ((self.txtPassword.txtField.text?.count)! < 8){
//            txtPassword.errorMessage = Cons_Password_Length
//            txtPassword.isValidate = false
//            return false
//        }
        else if (txtConfirmPassword.txtField.text?.isEmpty)!{
            txtConfirmPassword.errorMessage = Cons_blank_confirmPassword
            txtConfirmPassword.isValidate = false
            return false
        }
        else if !Validator.isPasswordMatch(txtPassword.text!, txtConfirmPassword.txtField.text!){
            txtConfirmPassword.errorMessage = Cons_Valid_Password_Match
            txtConfirmPassword.isValidate = false
            return false
        }
        else if GLOBAL.sharedInstance.isAgreement == false{
            self.alertOnTop(message: Cons_Agreements_Privacy)
            //self.showToastMessage(title: Cons_Agreements_Privacy)
            return false
        }
        return true
    }
    
    //MARK: - UITextFieldDelegate Methods
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
            let userEnteredString = textField.text
            let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
            let charCount = textField.text?.count
            if newString == "" || charCount == 0{
                txtEmail.removeRightImage()
            }
        }else if textField == txtUserName.txtField {
            txtUserName.isValidate = true
            let userEnteredString = textField.text
            let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
            strUsername = newString as String
            print(newString)
            var charCount = textField.text?.count
        
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")

            if (isBackSpace == -92){
                charCount = charCount! - 1
                if charCount! >= 4{
                    self.callUsernameAPI(inMainthread: true)
                }
                if charCount == 0 || charCount == 1 || charCount == 2 || charCount == 3{
                    self.txtUserName.removeRightImage()
                }
               
            }else{
                if charCount == 0 || charCount == 1 || charCount == 2{
                    self.txtUserName.removeRightImage()
                }
                if charCount! >= 3{
                    self.callUsernameAPI(inMainthread: true)
                }
            }
            
           
        }else if textField == txtDOB.txtField {
            txtDOB.isValidate = true
        }else if textField == txtGender.txtField {
            txtGender.isValidate = true
        }else if textField == txtPassword {
            lblErrorPassword.isHidden = true
            txtPassword.layer.borderColor = UIColor.txtfieldBorder_gray.cgColor
            lblPassword.textColor = UIColor.textColor_black
            txtPassword.textColor = UIColor.textColor_gray
            //txtPassword.isValidate = true
        }else if textField == txtConfirmPassword.txtField {
            txtConfirmPassword.isValidate = true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtGender.txtField {
            self.pickUp(txtGender.txtField, pickerGender)
        }else if textField == txtDOB.txtField{
            //let date = Date()
            //datePicker.setDate(date, animated: false)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtEmail.txtField{
            if (textField.text?.count)! > 0 {
                if !Validator.isValidEmail(txtEmail.txtField.text!){
               // if !(txtEmail.txtField.text?.isValidEmail)!{
                    txtEmail.rightImage = UIImage(named: "txtInvalid")
                    txtEmail.errorMessage = Cons_valid_email
                    txtEmail.isValidate = false
                    txtEmail.addRightImage()
                }
                else{
                    txtEmail.rightImage = UIImage(named: "txtValid")
                    txtEmail.isValidate = true
                    txtEmail.addRightImage()
                }
            }
        }
        if textField == txtUserName.txtField{
            let charCount = textField.text?.count
            if (textField.text?.count)! > 0 {
                self.txtUserName.removeRightImage()
            }
            if charCount! < 4{
                if charCount == 0{
                    self.txtUserName.removeRightImage()
                    return
                }
                self.txtUserName.rightImage = UIImage(named: "txtInvalid")
                self.txtUserName.errorMessage = Cons_Invalid_Username
                self.txtUserName.isValidate = false
                self.txtUserName.addRightImage()
            }
        }
    }
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerGender {
            return arrGender.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerGender {
            return arrGender[row]
        }else{
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerGender {
            self.txtGender.txtField.text = arrGender[row]
        }
    }
    
    //MARK: - Username api Methods
    @objc func textFieldDidChange(_ textField: UITextField){
        if textField.text!.count == 3{
            self.callUsernameAPI(inMainthread: true)
        }
    }
    
    //MARK: - Action Methods
    @IBAction func btnAgreementsTap(_ sender: UIButton) {
        if GLOBAL.sharedInstance.isAgreement {
            GLOBAL.sharedInstance.isAgreement = false
            DefaultValue.shared.setBoolValue(value: GLOBAL.sharedInstance.isAgreement, key: KEYS_USERDEFAULTS.IS_AGREEMENT_TERMS)
            imgvTerms.image = UIImage(named : "Uncheck")
            strAgreement = "false"
        }else{
            GLOBAL.sharedInstance.isAgreement = true
            DefaultValue.shared.setBoolValue(value: GLOBAL.sharedInstance.isAgreement, key: KEYS_USERDEFAULTS.IS_AGREEMENT_TERMS)
            imgvTerms.image = UIImage(named : "Check")
            strAgreement = "true"
        }
    }
    
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
    
    @IBAction func btnBackTap(_ sender: UIControl) {
        POP_VC()
    }
    
    @IBAction func btnRegisterTap(_ sender: UIButton) {
        if self.isValidateInfo(){
            print("Registered")
          
            self.callRegisterAPI()

//            let queryParams: [String: String] = [KEYS_API.first_name : txtFirstName.txtField.text!,
//                                                 KEYS_API.last_name : txtLastName.txtField.text!,
//                                                 KEYS_API.email: txtEmail.txtField.text!,
//                                                 KEYS_API.username: txtUserName.txtField.text!,
//                                                 KEYS_API.date_of_birth: self.txtDOB.txtField.text!,
//                                                 KEYS_API.gender: txtGender.txtField.text!,
//                                                 KEYS_API.password: txtPassword.text!,
//                                                 KEYS_API.confirm_password: txtConfirmPassword.txtField.text!,
//                                                 KEYS_API.agreedToTermsAndPrivacyPolicy: "true", //strAgreement,
//                                                 KEYS_API.subscribe_newsletter: strNewsletter,
//                                                 KEYS_API.platform : APIConstant.platform,
//                                                 KEYS_API.device_token : GLOBAL.sharedInstance.getDeviceToken(),
//                                                 KEYS_API.version : KEYS_API.app_version]
//
//            let termsVC = UIStoryboard.init(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
//            termsVC.isFromRegister = true
//            termsVC.paramRegister = queryParams
//            self.navigationController?.pushViewController(termsVC, animated: true)
        }
    }
    
    @IBAction func btnTermsOfServiceTap(_ sender: UIButton) {
        let objTermsService = self.MAKE_STORY_OBJ_MAIN(Identifier: STORYBOARD_IDENTIFIER.CmsVC) as! CmsVC
        objTermsService.navigationTitle = WebViewTitle.TermsOfService
        objTermsService.webURL = WebURL().TermsOfService
        self.navigationController?.pushViewController(objTermsService, animated: true)
    }
    
    @IBAction func btnPrivacyPolicyTap(_ sender: UIButton) {
        let objPrivacyPolicy = self.MAKE_STORY_OBJ_MAIN(Identifier: STORYBOARD_IDENTIFIER.CmsVC) as! CmsVC
        objPrivacyPolicy.navigationTitle = WebViewTitle.Privacy
        objPrivacyPolicy.webURL = WebURL().Privacy
        self.navigationController?.pushViewController(objPrivacyPolicy, animated: true)
    }
    
    //MARK: - Datepicker Methods
    func showdatePicker(){
        
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        let calendar = Calendar.current
        let backDate = calendar.date(byAdding: .year, value: -21, to: Date())
        
        datePicker.date = backDate!

        
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
    
    @IBAction func btnChangeDate(_ sender:UIButton){
        let datePicker = ActionSheetDatePicker(title:"", datePickerMode: UIDatePicker.Mode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            guard let date = value as? Date else{
                return
            }
            
            self.selectedDate = date
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            self.txtDOB.txtField.text = formatter.string(from: date)
            //self.strDateOfBirth = self.getFormattedDate(stringDate: self.txtDOB.txtField.text!)
            self.txtDOB.isValidate = true
            //current time
            if formatter.string(from: date) == formatter.string(from: Date()){
               
            }
            
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        
        datePicker?.maximumDate = Date()
        datePicker?.show()
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
        label.text = Cons_Gender
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
        
        if self.txtGender.txtField.text == ""{
            self.txtGender.txtField.text = arrGender[0]
        }
    }
    
    //MARK:- Picker Button
    @objc func doneClick() {
        
        txtGender.txtField.resignFirstResponder()
        txtGender.isValidate = true
    }
    
    @objc func cancelClick() {
        txtGender.txtField.resignFirstResponder()
    }
}

extension RegisterVC{
    //MARK: - API Methods
    func callRegisterAPI()  {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: String] = [KEYS_API.first_name : txtFirstName.txtField.text!,
                                             KEYS_API.last_name : txtLastName.txtField.text!,
                                             KEYS_API.email: txtEmail.txtField.text!,
                                             KEYS_API.username: txtUserName.txtField.text!,
                                             KEYS_API.date_of_birth: self.txtDOB.txtField.text!,
                                             KEYS_API.gender: txtGender.txtField.text!,
                                             KEYS_API.password: txtPassword.text!,
                                             KEYS_API.confirm_password: txtConfirmPassword.txtField.text!,
                                             KEYS_API.agreedToTermsAndPrivacyPolicy: strAgreement,
                                             KEYS_API.subscribe_newsletter: strNewsletter,
                                             KEYS_API.platform : APIConstant.platform,
                                             KEYS_API.device_token : GLOBAL.sharedInstance.getDeviceToken(),
                                             KEYS_API.version : KEYS_API.app_version]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: ModelRegistration.self,apiName:APIName.Register, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                Alert.shared.showAlertWithHandler(title: App_Name, message: (response.meta?.message)!, okButtonTitle: Cons_Ok, handler: { (action) in
                    //Redirect to Login screen
                    self.POP_VC()
                })
            }
            
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
        
    }
    
    func callUsernameAPI(inMainthread: Bool)  {
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: String] = [KEYS_API.username : strUsername,//txtUserName.txtField.text!,
                                             KEYS_API.platform : APIConstant.platform,
                                             KEYS_API.version : KEYS_API.app_version]
        
        //self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: ModelRegistration.self,apiName:APIName.Username, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            print("\n-------------------------API Response :-----------------------\n",response)
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCodeForUsername(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
            
                self.txtUserName.rightImage = UIImage(named: "txtValid")
                self.txtUserName.isValidate = true
                self.txtUserName.addRightImage()
            }else{
                self.txtUserName.rightImage = UIImage(named: "txtInvalid")
                self.txtUserName.errorMessage = (response.meta?.message)!
                self.txtUserName.isValidate = false
                self.txtUserName.addRightImage()
                
                
            }
            
        }, FailureBlock: { (error) in
            //self.hideLoader()
        })
        
    }
}
