//
//  ChangePasswordVC.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 11/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

class ChangePasswordVC: ParentVC,UITextFieldDelegate {

    //MARK: - Outlets
    @IBOutlet weak var txtCurrentPassword: TWTextFieldView!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmNewPassword: TWTextFieldView!
    @IBOutlet weak var btnSavePassword: UIButton!
    @IBOutlet weak var lblErrorNewPassword: UILabel!
    @IBOutlet weak var lblNewPassword: UILabel!
    @IBOutlet weak var viewNewPassword: UIView!
    
    
    //MARK: - Properties
   
    
    //MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTextFieldsDelegate()
    }
    

    //MARK: - Intial Methods
    private func setTextFieldsDelegate() {
        txtCurrentPassword.txtField.delegate = self
        txtNewPassword.delegate = self
        txtConfirmNewPassword.txtField.delegate = self
        self.txtCurrentPassword.txtField.isSecureTextEntry = true
        self.txtNewPassword.isSecureTextEntry = true
        self.txtConfirmNewPassword.txtField.isSecureTextEntry = true
    }
    
    fileprivate func setUpUI() {
        txtNewPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtNewPassword.frame.height))
        txtNewPassword.leftViewMode = .always
        txtNewPassword.layer.borderColor = UIColor.border_color.cgColor
        txtNewPassword.layer.borderWidth = 1.0
        txtNewPassword.layer.cornerRadius = 3.0
        txtNewPassword.clipsToBounds = true
        addRadius(button: btnSavePassword)
    }
    
    //MARK: - Validation Methods
    func validate() -> Bool{
        if (self.txtCurrentPassword.txtField.text?.isEmpty)!{
            txtCurrentPassword.errorMessage = Cons_Current_Password
            txtCurrentPassword.isValidate = false
            return false
        }
        else if (self.txtNewPassword.text?.isEmpty)!{
            lblErrorNewPassword.isHidden = false
            lblErrorNewPassword.text = Cons_New_Password
            txtNewPassword.layer.borderColor = UIColor.txtfieldBorder_red.cgColor
            lblNewPassword.textColor = UIColor.txtfieldBorder_red
            txtNewPassword.textColor = UIColor.txtfieldBorder_red
            //txtNewPassword.errorMessage = Cons_New_Password
            //txtNewPassword.isValidate = false
            return false
        }
        else if Validator.isvalidPassword(self.txtNewPassword.text!) {
            lblErrorNewPassword.isHidden = false
            lblErrorNewPassword.text = Cons_Valid_Password
            txtNewPassword.layer.borderColor = UIColor.txtfieldBorder_red.cgColor
            lblNewPassword.textColor = UIColor.txtfieldBorder_red
            txtNewPassword.textColor = UIColor.txtfieldBorder_red
            //txtNewPassword.errorMessage = Cons_Valid_Password
            //txtNewPassword.isValidate = false
            return false
        }
        else if (self.txtConfirmNewPassword.txtField.text?.isEmpty)!{
            txtConfirmNewPassword.errorMessage = Cons_confirm_password
            txtConfirmNewPassword.isValidate = false
            return false
        }
//        else if ((self.txtConfirmNewPassword.txtField.text?.count)! < 8){
//            txtConfirmNewPassword.errorMessage = Cons_Password_Length
//            txtConfirmNewPassword.isValidate = false
//            return false
//        }
        else if !Validator.isPasswordMatch(txtNewPassword.text!, txtConfirmNewPassword.txtField.text!){
            txtConfirmNewPassword.errorMessage = Cons_Password_Match
            txtConfirmNewPassword.isValidate = false
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
        if textField == txtCurrentPassword.txtField {
            txtCurrentPassword.isValidate = true
        }else if textField == txtNewPassword {
            lblErrorNewPassword.isHidden = true
            txtNewPassword.layer.borderColor = UIColor.txtfieldBorder_gray.cgColor
            lblNewPassword.textColor = UIColor.textColor_black
            txtNewPassword.textColor = UIColor.textColor_gray
            //txtNewPassword.isValidate = true
        }else if textField == txtConfirmNewPassword.txtField {
            txtConfirmNewPassword.isValidate = true
        }
        return true
    }
    
    //MARK: - Action Methods
    @IBAction func btnSavePasswordTap(_ sender: UIButton) {
        if validate(){
            //api call
            self.callChangePasswordAPI()
        }
    }
    
    //MARK: - API Methods
    func callChangePasswordAPI(){
        
        let headerParams = API.sharedInstance.getDefaultHeadersParametersWithContentType(strContentType: APIConstant.content_value_Json)
        
        let queryParams: [String: String] = [KEYS_API.old_password: txtCurrentPassword.txtField.text!,
                                             KEYS_API.new_password: txtNewPassword.text!]
        
        self.showLoader()
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_ChangePasswordResponce.self,apiName:APIName.ChangePassword, requestType: .post, paramValues: queryParams, headersValues: headerParams, SuccessBlock: { (response) in
            
            self.hideLoader()
            
            //let modelLoginResponse = response as! Model_LoginResponse
            
            let statusCode  = response.meta?.status_code ?? 0
            
            if self.handleStatusCode(statusCode:statusCode, modelErrors: response.errors, meta:response.meta){
                
                let strMessage = response.meta?.message ?? ""
                self.setUserDefault(self.txtConfirmNewPassword.txtField.text ?? "", KeyToSave: KEYS_USERDEFAULTS.USER_PASSWORD)
                
                Alert.shared.showAlertWithHandler(title: App_Name, message: strMessage, okButtonTitle: str_AlertTextOK, handler: { (index) in
                    if(index == AlertAction.Ok){
                        self.POP_VC()
                        //self.redirctToLoginScreen()
                    }
                })
                
            }
        }, FailureBlock: { (error) in
            self.hideLoader()
            //No need to show error message here, it will display from api class itself...
        })
    }
}
