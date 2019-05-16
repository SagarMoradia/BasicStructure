//
//  ForgotPasswordVC.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 04/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class ForgotPasswordVC: ParentVC,UITextFieldDelegate {

    //MARK: - Outlets
    @IBOutlet weak var lblAlready: UILabel!
    @IBOutlet weak var txtEmail: TWTextFieldView!

    
    //MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txtEmail.txtField.keyboardType = .emailAddress
        txtEmail.txtField.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Intial Methods
    private func prepareViews() {
        //Login Button
        let str1 = "Remember my password? "
        let str2 = "Login"
        let strText = str1+str2
        var mutableString = NSMutableAttributedString()
        mutableString = NSMutableAttributedString(string: strText, attributes: [NSAttributedString.Key.font:fontType.InterUI_Medium_12!])
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.textColor_gray, range: NSRange(location:0,length:str1.count))
        self.lblAlready.attributedText = mutableString
    }
    
    private func isValidateInfo() -> Bool{
        self.view.endEditing(true)
        let whitespace = NSCharacterSet.whitespaces
        let phrase = txtEmail.txtField.text ?? ""
        let range = phrase.rangeOfCharacter(from: whitespace)
        
        if (txtEmail.txtField.text?.isEmpty)!{
            txtEmail.errorMessage = Cons_blank_email
            txtEmail.isValidate = false
            return false
        }
        else if range != nil {
            txtEmail.errorMessage = Cons_valid_email
            txtEmail.isValidate = false
            return false
        }
        else if !(txtEmail.txtField.text?.isValidEmail)!{
            txtEmail.errorMessage = Cons_valid_email
            txtEmail.isValidate = false
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
        txtEmail.isValidate = true
        return true
    }
    
    //MARK: - Action Methods
    @IBAction func btnBackTap(_ sender: UIButton) {
        POP_VC()
    }
    
    @IBAction func btnSendEmailTap(_ sender: UIButton) {
        if self.isValidateInfo(){
            callForgotPasswordAPI()
        }
    }
    
}


//MARK: Forgot Password API Calling

extension ForgotPasswordVC{
    
    fileprivate func callForgotPasswordAPI(){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
    
        let queryParams: [String: String] = [KEYS_API.email: txtEmail.txtField.text!,
                                             KEYS_API.platform : APIConstant.platform,
                                             KEYS_API.version : KEYS_API.app_version
        ]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: ModelCommonResponse.self,apiName:APIName.ForgotPassword, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta) {
                let objForgotPasswordSuccess = self.MAKE_STORY_OBJ_MAIN(Identifier: STORYBOARD_IDENTIFIER.ForgotPasswordSuccessVC) as! ForgotPasswordSuccessVC
                objForgotPasswordSuccess.emailID = self.txtEmail.txtField.text!
                self.PUSH_STORY_OBJ(obj: objForgotPasswordSuccess)
            }
        }, FailureBlock: { (error) in
            self.hideLoader()
        })
    }
}
