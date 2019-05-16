//
//  LoginVC.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 04/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit
import Crashlytics

class LoginVC: ParentVC,UITextFieldDelegate {

    //MARK: - Outlets
    @IBOutlet weak var txtEmail: TWTextFieldView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnRemberMe: UIButton!
    @IBOutlet weak var lblAlready: UILabel!
    @IBOutlet weak var imgvIsRemember: UIImageView!
    @IBOutlet weak var lblErrorPassword: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    
    //MARK: - Properties
    var attrs = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0),
        NSAttributedString.Key.foregroundColor : UIColor.theme_green,
        NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
    var attributedString = NSMutableAttributedString(string:"")
    
    lazy var viewAgeVerification = Bundle.loadView(fromNib:"AgeVerificationView", withType: AgeVerificationView.self)
    
    //MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.addAgeVerificationView(fromLoginAPI:false)
        prepareViews()
        
        
        /*
         //Demo
         nimesh.surani@brainvire.com/Admin@123
         
         
         //Live
         sagar.moradia@brainvire.com/Sam@1234567
         vasim.mansuri@brainvire.com/admin123
         
         jay.voralia@brainvire.com/Brain@2019
         rahul.trivedi@brainvire.com/Brain@2019
         hiren.raval@brainvire.com/Brain@2019
         */
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DefaultValue.shared.setBoolValue(value: false, key: KEYS_USERDEFAULTS.IS_SKIP)
        
        if !DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_AGE_VERIFIED){
            self.addAgeVerificationView(fromLoginAPI:false)
        }
        
        self.checkForLogin()
        self.setTextFieldsDelegate()
        
//        self.txtEmail.txtField.text = "sagar.moradia@brainvire.com"
//        self.txtPassword.text = "Sam@1234567"
        
//        self.txtEmail.txtField.text = "jay.voralia@brainvire.com"
//        self.txtPassword.text = "Brain@2019"
        
//        self.txtEmail.txtField.text = "vitrag.shah@brainvire.com"
//        self.txtPassword.text = "Brain@2019"

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        txtEmail.isValidate = true
        lblErrorPassword.isHidden = true
        txtPassword.layer.borderColor = UIColor.txtfieldBorder_gray.cgColor
        lblPassword.textColor = UIColor.textColor_black
        txtPassword.textColor = UIColor.textColor_gray
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default // .default
    }
    
    //MARK: - Intial Methods
    private func setTextFieldsDelegate() {
        txtEmail.txtField.delegate = self
        txtPassword.delegate = self
        self.txtEmail.txtField.keyboardType = .emailAddress
        self.txtPassword.isSecureTextEntry = true



    }
    
    func addAgeVerificationView(fromLoginAPI:Bool) {
        
        if !DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_AGE_VERIFIED){
            self.viewAgeVerification.frame = (APPLICATION.appDelegate.window?.bounds)!//self.view.bounds
            self.viewAgeVerification.setUpUI()
            
            self.viewAgeVerification.addSubviewWithAnimationCenter(animation: {                
            }) {//Completion
                self.viewAgeVerification.backgroundColor = UIColor.init(red: 0.0/255.0, green:0.0/255.0, blue: 0.0/255.0, alpha: 0.8)
            }
            
            self.viewAgeVerification.handler = alertHandler({(index) in
                if index == 200{
                    DefaultValue.shared.setBoolValue(value: true, key: KEYS_USERDEFAULTS.IS_AGE_VERIFIED)
                    if fromLoginAPI{
                        self.callAPILogin()
                    }
                }else {
                    let objTermsService = self.MAKE_STORY_OBJ_MAIN(Identifier: STORYBOARD_IDENTIFIER.CmsVC) as! CmsVC
                    objTermsService.navigationTitle = WebViewTitle.TermsOfService
                    objTermsService.webURL = WebURL().TermsOfService
                    objTermsService.isFromAge = true
                    self.navigationController?.pushViewController(objTermsService, animated: true)
                }
            })
        }
    }
    
    private func prepareViews() {

        //Skip button
        let buttonTitleStr = NSMutableAttributedString(string:"Skip", attributes:attrs)
        attributedString.append(buttonTitleStr)
        btnSkip.setAttributedTitle(attributedString, for: .normal)
        
        //Register Button
        let str1 = "Don’t have an account? "
        let str2 = "Register"
        let strText = str1+str2
        var mutableString = NSMutableAttributedString()
        mutableString = NSMutableAttributedString(string: strText, attributes: [NSAttributedString.Key.font:fontType.InterUI_Medium_12!])
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.textColor_gray, range: NSRange(location:0,length:str1.count))
        self.lblAlready.attributedText = mutableString
        
        setUpUI()
    }
    
    fileprivate func setUpUI() {
        txtPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtPassword.frame.height))
        txtPassword.leftViewMode = .always
        txtPassword.layer.borderColor = UIColor.border_color.cgColor
        txtPassword.layer.borderWidth = 1.0
        txtPassword.layer.cornerRadius = 3.0
        txtPassword.clipsToBounds = true
    }
    
    func checkForLogin() {
        if DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_REMEMBER_ME) {
            imgvIsRemember.image = UIImage(named : "Check")
            btnRemberMe.isSelected = true
            txtEmail.txtField.text = getUserDefault(KEYS_USERDEFAULTS.USER_EMAIL) as? String ?? ""
            txtPassword.text = getUserDefault(KEYS_USERDEFAULTS.USER_PASSWORD) as? String ?? ""
        }
        else{
            imgvIsRemember.image = UIImage(named : "Uncheck")
            btnRemberMe.isSelected = false
            txtEmail.txtField.text = ""
            txtPassword.text = ""
        }
    }
    
    private func isValidateInfo() -> Bool{
        let whitespace = NSCharacterSet.whitespaces
        let phrase = txtEmail.txtField.text ?? ""
        let range = phrase.rangeOfCharacter(from: whitespace)
        
        if (txtEmail.txtField.text?.isEmpty)!{
            txtEmail.errorMessage = Cons_blank_email
            txtEmail.isValidate = false
            return false
        }
        else if range != nil {
            txtEmail.errorMessage = Cons_blank_email
            txtEmail.isValidate = false
            return false
        }
//        else if !(txtEmail.txtField.text?.isValidEmail)!{
//            txtEmail.errorMessage = Cons_valid_email
//            txtEmail.isValidate = false
//            return false
//        }
        else if (txtPassword.text?.isEmpty)!{
            lblErrorPassword.isHidden = false
            lblErrorPassword.text = Cons_New_Password
            txtPassword.layer.borderColor = UIColor.txtfieldBorder_red.cgColor
            lblPassword.textColor = UIColor.txtfieldBorder_red
            txtPassword.textColor = UIColor.txtfieldBorder_red
//            txtPassword.errorMessage = Cons_blank_password
//            txtPassword.isValidate = false
            return false
        }
//        else if Validator.isvalidPassword(self.txtPassword.text!) {
//            lblErrorPassword.isHidden = false
//            lblErrorPassword.text = Cons_Valid_Password
//            txtPassword.layer.borderColor = UIColor.txtfieldBorder_red.cgColor
//            lblPassword.textColor = UIColor.txtfieldBorder_red
//            txtPassword.textColor = UIColor.txtfieldBorder_red
//            //txtNewPassword.errorMessage = Cons_Valid_Password
//            //txtNewPassword.isValidate = false
//            return false
//        }
        
//        else if ((self.txtPassword.txtField.text?.count)! < 8){
//            txtPassword.errorMessage = Cons_Password_Length
//            txtPassword.isValidate = false
//            return false
//        }
        return true
    }
    
    //MARK: - UITextFieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtEmail.txtField {
            txtEmail.isValidate = true
        }else if textField == txtPassword {
            lblErrorPassword.isHidden = true
            txtPassword.layer.borderColor = UIColor.txtfieldBorder_gray.cgColor
            lblPassword.textColor = UIColor.textColor_black
            txtPassword.textColor = UIColor.textColor_gray
            //txtPassword.isValidate = true
        }
        return true
    }
    
    //MARK: - Action Methods
    @IBAction func btnLoginTap(_ sender: UIButton) {

        self.view.endEditing(true)
        
        if self.isValidateInfo(){
            if !DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_AGE_VERIFIED){
                self.addAgeVerificationView(fromLoginAPI:true)
            }else{
                callAPILogin()
            }
        }
    }
    
    @IBAction func btnForgotPasswordTap(_ sender: UIButton) {
        self.PUSH_STORY_MAIN(Identifier: STORYBOARD_IDENTIFIER.ForgotPasswordVC)
    }
    
    @IBAction func btnRememberMeTap(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            imgvIsRemember.image = UIImage(named : "Check")
        }else{
            imgvIsRemember.image = UIImage(named : "Uncheck")
        }
        DefaultValue.shared.setBoolValue(value: sender.isSelected, key: KEYS_USERDEFAULTS.IS_REMEMBER_ME)
    }
    
    @IBAction func btnSkipTap(_ sender: UIButton) {
        if !DefaultValue.shared.getBoolValue(key: KEYS_USERDEFAULTS.IS_AGE_VERIFIED){
            self.addAgeVerificationView(fromLoginAPI:false)
        }else{
            DefaultValue.shared.setBoolValue(value: true, key: KEYS_USERDEFAULTS.IS_SKIP)
            redirectToHomeScreen()
        }
    }
    
    @IBAction func btnRegisterTap(_ sender: UIButton) {
        self.PUSH_STORY_MAIN(Identifier: STORYBOARD_IDENTIFIER.RegisterVC)
    }

}


//MARK:API CAlling

extension LoginVC{
    //MARK:- API
    fileprivate func callAPILogin(){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: String] = [KEYS_API.email: txtEmail.txtField.text!,
                                             KEYS_API.password: txtPassword.text!,
                                             KEYS_API.platform : APIConstant.platform,
                                             KEYS_API.device_token : GLOBAL.sharedInstance.getDeviceToken(),
                                             KEYS_API.version : KEYS_API.app_version
        ]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: LoginModel.self,apiName:APIName.Login, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                
                let strTokenType = response.data?.token_type ?? ""
                let strAccessToken = response.data?.access_token ?? ""
                let strAuthorizationValue = API.sharedInstance.getAuthorizationValue(token: strTokenType, accessToken: strAccessToken)

                print(strAuthorizationValue)
                self.setUserDefault(response.data?.access_token ?? "", KeyToSave: KEYS_USERDEFAULTS.ACCESS_TOKEN)
                self.setUserDefault(strAuthorizationValue, KeyToSave: KEYS_USERDEFAULTS.AUTHORIZATION)
                
                self.setUserDefault(self.txtEmail.txtField.text ?? "", KeyToSave: KEYS_USERDEFAULTS.USER_EMAIL)
                self.setUserDefault(self.txtPassword.text ?? "", KeyToSave: KEYS_USERDEFAULTS.USER_PASSWORD)
                
                self.setUserDefault(response.data?.user_detail?.uuid ?? "", KeyToSave: KEYS_USERDEFAULTS.USER_UUID)
                
                //let menuUserName = "\(response.data?.user_detail?.first_name ??  response.data?.user_detail?.username ?? "") \(response.data?.user_detail?.last_name ?? "")"
                
                let menuUserName = response.data?.user_detail?.username ?? ""
                
                
                let menuUserProfileImage = response.data?.user_detail?.profile_photo ?? ""
                
                self.setUserDefault(response.data?.user_detail?.first_name ?? nil, KeyToSave: KEYS_USERDEFAULTS.USER_FIRSTNAME)
                self.setUserDefault(menuUserName, KeyToSave: KEYS_USERDEFAULTS.USER_FULLNAME)
                self.setUserDefault(menuUserProfileImage, KeyToSave: KEYS_USERDEFAULTS.USER_PHOTO)
                
                DefaultValue.shared.setBoolValue(value: true, key: KEYS_USERDEFAULTS.IS_LOGIN)

                self.redirectToHomeScreen()
            }
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
}
